<?php
declare(strict_types=1);

require_once __DIR__ . '/../_bootstrap.php';

if (http_method() !== 'GET') json_error(405, 'Metodo non consentito.');

function content_json(PDO $pdo, string $key): ?array {
  $stmt = $pdo->prepare('SELECT json_value FROM site_content WHERE `key` = ? LIMIT 1');
  $stmt->execute([$key]);
  $row = $stmt->fetch();
  if (!$row) return null;
  $v = $row['json_value'];
  if (is_string($v)) {
    $decoded = json_decode($v, true);
    return is_array($decoded) ? $decoded : null;
  }
  return is_array($v) ? $v : null;
}

function content_text(PDO $pdo, string $key): ?string {
  $stmt = $pdo->prepare('SELECT text_value FROM site_content WHERE `key` = ? LIMIT 1');
  $stmt->execute([$key]);
  $row = $stmt->fetch();
  if (!$row) return null;
  return $row['text_value'] !== null ? (string)$row['text_value'] : null;
}

try {
  $pdo = db();

  // Meta + contenuti (fallback a valori sensati).
  $meta = content_json($pdo, 'listinoMeta') ?? [
    'titolo' => 'Listino',
    'disclaimer' => 'Importi indicativi; conferma sempre in negozio dopo la diagnosi gratuita.',
  ];

  $ipad = content_json($pdo, 'ipadListino') ?? [
    'id' => 'ipad',
    'title' => 'iPad',
    'blocks' => [],
  ];

  $altriBody = content_text($pdo, 'altriDispositiviBody') ?? 'Tablet Android, smartphone non Apple, Mac e PC: diagnosi gratuita in negozio e preventivo dedicato.';
  $altri = [
    'title' => 'Altri dispositivi',
    'body' => $altriBody,
  ];

  // iPhone: devices + repairs + prices, generati in forma matrice compatibile col frontend.
  $repStmt = $pdo->prepare('SELECT id, `key`, label FROM repair_types WHERE scope = ? AND is_active = 1 ORDER BY sort_order ASC, label ASC');

  $buildIphoneMatrix = function (string $category) use ($pdo, $repStmt): array {
    $devStmt = $pdo->prepare('SELECT id, label, short_label, thumb_path, image_path FROM devices WHERE category = ? AND is_active = 1 ORDER BY sort_order ASC, label ASC');
    $devStmt->execute([$category]);
    $devices = $devStmt->fetchAll();

    $models = [];
    $modelsMap = [];
    $deviceIds = [];
    $deviceImages = [];
    foreach ($devices as $d) {
      $label = (string)$d['label'];
      $models[] = $label;
      $modelsMap[$label] = $d['short_label'] !== null && (string)$d['short_label'] !== '' ? (string)$d['short_label'] : $label;
      $deviceIds[] = (int)$d['id'];
      $thumb = $d['thumb_path'] ?? null;
      $img = $d['image_path'] ?? null;
      if (is_string($thumb) && $thumb !== '') $deviceImages[$label] = $thumb;
      else if (is_string($img) && $img !== '') $deviceImages[$label] = $img;
    }

    $repStmt->execute(['iphone']);
    $repairs = $repStmt->fetchAll();

    // Pre-carica prezzi in mappa [repair_id][device_id] => price_eur|null.
    $priceMap = [];
    if ($deviceIds && $repairs) {
      $inDev = implode(',', array_fill(0, count($deviceIds), '?'));
      $repIds = array_map(fn ($r) => (int)$r['id'], $repairs);
      $inRep = implode(',', array_fill(0, count($repIds), '?'));
      $sql = "SELECT device_id, repair_type_id, price_eur
              FROM prices
              WHERE is_active = 1
                AND device_id IN ($inDev)
                AND repair_type_id IN ($inRep)";
      $stmt = $pdo->prepare($sql);
      $stmt->execute(array_merge($deviceIds, $repIds));
      foreach ($stmt->fetchAll() as $p) {
        $rid = (int)$p['repair_type_id'];
        $did = (int)$p['device_id'];
        $priceMap[$rid][$did] = $p['price_eur'] !== null ? (int)$p['price_eur'] : null;
      }
    }

    $rows = [];
    foreach ($repairs as $r) {
      $rid = (int)$r['id'];
      $prices = [];
      foreach ($deviceIds as $did) {
        $prices[] = $priceMap[$rid][$did] ?? null;
      }
      $rows[] = [
        'key' => (string)$r['key'],
        'label' => (string)$r['label'],
        'prices' => $prices,
      ];
    }

    return [
      'id' => $category,
      'title' => $category === 'iphone-recent' ? 'iPhone — modelli recenti' : 'iPhone — modelli precedenti',
      'models' => $models,
      'modelsMap' => (object)$modelsMap,
      'repairs' => $rows,
      'deviceImages' => (object)$deviceImages,
    ];
  };

  $iphoneLegacy = $buildIphoneMatrix('iphone-legacy');
  $iphoneRecent = $buildIphoneMatrix('iphone-recent');

  // Output compatibile con `src/servizi.js` (loadListino).
  json_response(200, [
    'listinoMeta' => $meta,
    'iphoneLegacy' => $iphoneLegacy,
    'iphoneRecent' => $iphoneRecent,
    'ipadListino' => $ipad,
    'altriDispositivi' => $altri,
  ]);
} catch (Throwable $e) {
  json_error(500, 'Errore server.');
}

