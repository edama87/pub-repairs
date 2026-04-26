<?php
declare(strict_types=1);

require_once __DIR__ . '/../_bootstrap.php';

$user = require_admin();
require_csrf_if_mutating();

$m = http_method();

function family_id_for_slug(PDO $pdo, string $slug): int {
  $stmt = $pdo->prepare('SELECT id FROM device_families WHERE slug = ? LIMIT 1');
  $stmt->execute([$slug]);
  $row = $stmt->fetch();
  if ($row) return (int)$row['id'];
  $ins = $pdo->prepare('INSERT INTO device_families (slug, label) VALUES (?, ?)');
  $ins->execute([$slug, $slug]);
  return (int)$pdo->lastInsertId();
}

try {
  $pdo = db();

  if ($m === 'GET') {
    $category = isset($_GET['category']) ? (string)$_GET['category'] : null;
    $activeOnly = isset($_GET['activeOnly']) ? (string)$_GET['activeOnly'] : null;

    $where = [];
    $args = [];
    if ($category) {
      $where[] = 'd.category = ?';
      $args[] = $category;
    }
    if ($activeOnly === '1') {
      $where[] = 'd.is_active = 1';
    }
    $sql = 'SELECT d.id, d.category, d.label, d.short_label, d.image_path, d.thumb_path, d.sort_order, d.is_active, f.slug AS family_slug
            FROM devices d
            JOIN device_families f ON f.id = d.family_id';
    if ($where) $sql .= ' WHERE ' . implode(' AND ', $where);
    $sql .= ' ORDER BY d.category ASC, d.sort_order ASC, d.label ASC';

    $stmt = $pdo->prepare($sql);
    $stmt->execute($args);
    json_ok(['items' => $stmt->fetchAll(), 'user' => $user]);
  }

  if ($m === 'POST') {
    $body = read_json_body();
    $category = (string)($body['category'] ?? '');
    $label = trim((string)($body['label'] ?? ''));
    $short = isset($body['short_label']) ? trim((string)$body['short_label']) : null;
    $sort = (int)($body['sort_order'] ?? 0);
    $isActive = isset($body['is_active']) ? (int)((bool)$body['is_active']) : 1;

    if ($category === '' || $label === '') json_error(400, 'Dati mancanti.');
    if (!in_array($category, ['iphone-legacy', 'iphone-recent', 'ipad', 'other'], true)) {
      json_error(400, 'Categoria non valida.');
    }

    $familySlug = $category === 'ipad' ? 'ipad' : ($category === 'other' ? 'other' : 'iphone');
    $familyId = family_id_for_slug($pdo, $familySlug);

    $stmt = $pdo->prepare('INSERT INTO devices (family_id, category, label, short_label, sort_order, is_active) VALUES (?, ?, ?, ?, ?, ?)');
    $stmt->execute([$familyId, $category, $label, $short !== '' ? $short : null, $sort, $isActive]);
    json_ok(['id' => (int)$pdo->lastInsertId()]);
  }

  if ($m === 'PUT') {
    $body = read_json_body();
    $id = (int)($body['id'] ?? 0);
    if ($id <= 0) json_error(400, 'ID mancante.');

    $fields = [];
    $args = [];

    if (array_key_exists('label', $body)) {
      $fields[] = 'label = ?';
      $args[] = trim((string)$body['label']);
    }
    if (array_key_exists('short_label', $body)) {
      $v = trim((string)($body['short_label'] ?? ''));
      $fields[] = 'short_label = ?';
      $args[] = $v !== '' ? $v : null;
    }
    if (array_key_exists('sort_order', $body)) {
      $fields[] = 'sort_order = ?';
      $args[] = (int)$body['sort_order'];
    }
    if (array_key_exists('is_active', $body)) {
      $fields[] = 'is_active = ?';
      $args[] = (int)((bool)$body['is_active']);
    }
    if (array_key_exists('category', $body)) {
      $category = (string)$body['category'];
      if (!in_array($category, ['iphone-legacy', 'iphone-recent', 'ipad', 'other'], true)) {
        json_error(400, 'Categoria non valida.');
      }
      $familySlug = $category === 'ipad' ? 'ipad' : ($category === 'other' ? 'other' : 'iphone');
      $familyId = family_id_for_slug($pdo, $familySlug);
      $fields[] = 'category = ?';
      $args[] = $category;
      $fields[] = 'family_id = ?';
      $args[] = $familyId;
    }

    if (!$fields) json_error(400, 'Nessun campo da aggiornare.');
    $args[] = $id;

    $sql = 'UPDATE devices SET ' . implode(', ', $fields) . ' WHERE id = ?';
    $stmt = $pdo->prepare($sql);
    $stmt->execute($args);
    json_ok(['updated' => $stmt->rowCount()]);
  }

  if ($m === 'DELETE') {
    $id = (int)($_GET['id'] ?? 0);
    if ($id <= 0) json_error(400, 'ID mancante.');
    $stmt = $pdo->prepare('DELETE FROM devices WHERE id = ?');
    $stmt->execute([$id]);
    json_ok(['deleted' => $stmt->rowCount()]);
  }

  json_error(405, 'Metodo non consentito.');
} catch (Throwable $e) {
  json_error(500, 'Errore server.');
}

