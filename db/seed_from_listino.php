<?php
declare(strict_types=1);

/**
 * Seed DB da public/data/listino.json
 *
 * Uso:
 *   php db/seed_from_listino.php
 *
 * Richiede:
 *   - api/_config.local.php configurato (DB + app_secret)
 *   - tabelle create (db/schema.sql)
 */

require_once __DIR__ . '/../api/_bootstrap.php';

$jsonPath = __DIR__ . '/../data/listino.json';
if (!file_exists($jsonPath)) {
  fwrite(STDERR, "Errore: file non trovato: {$jsonPath}\n");
  exit(1);
}

$raw = file_get_contents($jsonPath);
if ($raw === false) {
  fwrite(STDERR, "Errore: impossibile leggere {$jsonPath}\n");
  exit(1);
}

$data = json_decode($raw, true);
if (!is_array($data)) {
  fwrite(STDERR, "Errore: JSON non valido in {$jsonPath}\n");
  exit(1);
}

$pdo = db();
$pdo->beginTransaction();

try {
  // Famiglie (ensure)
  $ensureFamily = function (string $slug, string $label) use ($pdo): int {
    $stmt = $pdo->prepare('SELECT id FROM device_families WHERE slug = ? LIMIT 1');
    $stmt->execute([$slug]);
    $row = $stmt->fetch();
    if ($row) return (int)$row['id'];
    $ins = $pdo->prepare('INSERT INTO device_families (slug, label) VALUES (?, ?)');
    $ins->execute([$slug, $label]);
    return (int)$pdo->lastInsertId();
  };

  $familyIphone = $ensureFamily('iphone', 'iPhone');
  $familyIpad = $ensureFamily('ipad', 'iPad');
  $familyOther = $ensureFamily('other', 'Altro');

  // Upsert devices per categoria, preservando sort_order dal JSON.
  $upsertDevice = function (int $familyId, string $category, string $label, ?string $shortLabel, int $sortOrder) use ($pdo): int {
    $sel = $pdo->prepare('SELECT id FROM devices WHERE category = ? AND label = ? LIMIT 1');
    $sel->execute([$category, $label]);
    $row = $sel->fetch();
    if ($row) {
      $id = (int)$row['id'];
      $upd = $pdo->prepare('UPDATE devices SET family_id=?, short_label=?, sort_order=?, is_active=1 WHERE id=?');
      $upd->execute([$familyId, $shortLabel, $sortOrder, $id]);
      return $id;
    }
    $ins = $pdo->prepare('INSERT INTO devices (family_id, category, label, short_label, sort_order, is_active) VALUES (?, ?, ?, ?, ?, 1)');
    $ins->execute([$familyId, $category, $label, $shortLabel, $sortOrder]);
    return (int)$pdo->lastInsertId();
  };

  // Upsert repair types (scope iphone).
  $upsertRepair = function (string $key, string $label, string $scope, int $sortOrder) use ($pdo): int {
    $sel = $pdo->prepare('SELECT id FROM repair_types WHERE `key` = ? AND scope = ? LIMIT 1');
    $sel->execute([$key, $scope]);
    $row = $sel->fetch();
    if ($row) {
      $id = (int)$row['id'];
      $upd = $pdo->prepare('UPDATE repair_types SET label=?, sort_order=?, is_active=1 WHERE id=?');
      $upd->execute([$label, $sortOrder, $id]);
      return $id;
    }
    $ins = $pdo->prepare('INSERT INTO repair_types (`key`, label, scope, sort_order, is_active) VALUES (?, ?, ?, ?, 1)');
    $ins->execute([$key, $label, $scope, $sortOrder]);
    return (int)$pdo->lastInsertId();
  };

  // Upsert price (iphone).
  $upsertPrice = function (int $deviceId, int $repairId, ?int $priceEur) use ($pdo): void {
    $stmt = $pdo->prepare('INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
                           VALUES (?, ?, ?, 1)
                           ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=1');
    $stmt->execute([$deviceId, $repairId, $priceEur]);
  };

  // Seed iPhone legacy/recent (devices + repairs + prices).
  foreach (['iphoneLegacy' => 'iphone-legacy', 'iphoneRecent' => 'iphone-recent'] as $k => $category) {
    if (!isset($data[$k]) || !is_array($data[$k])) continue;
    $block = $data[$k];
    $models = $block['models'] ?? [];
    $modelsMap = $block['modelsMap'] ?? [];
    $repairs = $block['repairs'] ?? [];
    if (!is_array($models) || !is_array($repairs)) continue;

    /** @var array<int,int> index => device_id */
    $deviceIdsByIndex = [];
    foreach (array_values($models) as $idx => $label) {
      $labelStr = (string)$label;
      $short = null;
      if (is_array($modelsMap) && array_key_exists($labelStr, $modelsMap)) {
        $short = trim((string)$modelsMap[$labelStr]);
        if ($short === '') $short = null;
      }
      $deviceIdsByIndex[$idx] = $upsertDevice($familyIphone, $category, $labelStr, $short, (int)$idx);
    }

    foreach (array_values($repairs) as $rIdx => $r) {
      if (!is_array($r)) continue;
      $key = trim((string)($r['key'] ?? ''));
      $label = trim((string)($r['label'] ?? ''));
      $prices = $r['prices'] ?? [];
      if ($key === '' || $label === '' || !is_array($prices)) continue;

      $repairId = $upsertRepair($key, $label, 'iphone', (int)$rIdx);

      foreach (array_values($prices) as $pIdx => $p) {
        if (!array_key_exists($pIdx, $deviceIdsByIndex)) continue;
        $deviceId = $deviceIdsByIndex[$pIdx];
        $priceEur = null;
        if ($p !== null && $p !== '') {
          $priceEur = (int)$p;
        }
        $upsertPrice($deviceId, $repairId, $priceEur);
      }
    }
  }

  // Seed contenuti iPad / altri / meta in site_content (usati dall'endpoint pubblico).
  $upsertContentJson = function (string $key, array $value) use ($pdo): void {
    $stmt = $pdo->prepare('INSERT INTO site_content (`key`, json_value, text_value) VALUES (?, ?, NULL)
                           ON DUPLICATE KEY UPDATE json_value=VALUES(json_value), text_value=NULL');
    $stmt->execute([$key, json_encode($value, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES)]);
  };
  $upsertContentText = function (string $key, string $value) use ($pdo): void {
    $stmt = $pdo->prepare('INSERT INTO site_content (`key`, json_value, text_value) VALUES (?, NULL, ?)
                           ON DUPLICATE KEY UPDATE json_value=NULL, text_value=VALUES(text_value)');
    $stmt->execute([$key, $value]);
  };

  if (isset($data['listinoMeta']) && is_array($data['listinoMeta'])) {
    $upsertContentJson('listinoMeta', $data['listinoMeta']);
  }
  if (isset($data['ipadListino']) && is_array($data['ipadListino'])) {
    $upsertContentJson('ipadListino', $data['ipadListino']);
  }
  if (isset($data['altriDispositivi']) && is_array($data['altriDispositivi'])) {
    $body = (string)($data['altriDispositivi']['body'] ?? '');
    if ($body !== '') $upsertContentText('altriDispositiviBody', $body);
  }

  $pdo->commit();
  fwrite(STDOUT, "OK: seed completato (devices, repairs, prices, site_content).\n");
} catch (Throwable $e) {
  $pdo->rollBack();
  fwrite(STDERR, "Errore seed: " . $e->getMessage() . "\n");
  exit(1);
}

