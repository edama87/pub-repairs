<?php
declare(strict_types=1);

require_once __DIR__ . '/../_bootstrap.php';

$user = require_admin();
require_csrf_if_mutating();

$m = http_method();

try {
  $pdo = db();

  if ($m === 'GET') {
    $deviceId = isset($_GET['device_id']) ? (int)$_GET['device_id'] : 0;
    $scope = isset($_GET['scope']) ? (string)$_GET['scope'] : null;

    $where = [];
    $args = [];
    if ($deviceId > 0) {
      $where[] = 'p.device_id = ?';
      $args[] = $deviceId;
    }
    if ($scope) {
      $where[] = 'rt.scope = ?';
      $args[] = $scope;
    }

    $sql = 'SELECT p.id, p.device_id, p.repair_type_id, p.price_eur, p.notes, p.is_active, p.valid_from, p.valid_to,
                   d.label AS device_label, d.category AS device_category,
                   rt.`key` AS repair_key, rt.label AS repair_label, rt.scope AS repair_scope
            FROM prices p
            JOIN devices d ON d.id = p.device_id
            JOIN repair_types rt ON rt.id = p.repair_type_id';
    if ($where) $sql .= ' WHERE ' . implode(' AND ', $where);
    $sql .= ' ORDER BY d.category ASC, d.sort_order ASC, rt.scope ASC, rt.sort_order ASC';

    $stmt = $pdo->prepare($sql);
    $stmt->execute($args);
    json_ok(['items' => $stmt->fetchAll(), 'user' => $user]);
  }

  if ($m === 'POST') {
    $body = read_json_body();
    $deviceId = (int)($body['device_id'] ?? 0);
    $repairTypeId = (int)($body['repair_type_id'] ?? 0);
    $price = $body['price_eur'] ?? null;
    $notes = isset($body['notes']) ? trim((string)$body['notes']) : null;
    $isActive = isset($body['is_active']) ? (int)((bool)$body['is_active']) : 1;
    $validFrom = isset($body['valid_from']) ? (string)$body['valid_from'] : null;
    $validTo = isset($body['valid_to']) ? (string)$body['valid_to'] : null;

    if ($deviceId <= 0 || $repairTypeId <= 0) json_error(400, 'Dati mancanti.');
    $priceEur = null;
    if ($price !== null && $price !== '') {
      $priceEur = (int)$price;
      if ($priceEur < 0) json_error(400, 'Prezzo non valido.');
    }

    $stmt = $pdo->prepare('INSERT INTO prices (device_id, repair_type_id, price_eur, notes, is_active, valid_from, valid_to)
                           VALUES (?, ?, ?, ?, ?, ?, ?)
                           ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), notes=VALUES(notes), is_active=VALUES(is_active),
                           valid_from=VALUES(valid_from), valid_to=VALUES(valid_to)');
    $stmt->execute([$deviceId, $repairTypeId, $priceEur, $notes !== '' ? $notes : null, $isActive, $validFrom ?: null, $validTo ?: null]);

    json_ok(['upserted' => true]);
  }

  if ($m === 'PUT') {
    $body = read_json_body();
    $id = (int)($body['id'] ?? 0);
    if ($id <= 0) json_error(400, 'ID mancante.');

    $fields = [];
    $args = [];

    if (array_key_exists('price_eur', $body)) {
      $price = $body['price_eur'];
      $priceEur = null;
      if ($price !== null && $price !== '') {
        $priceEur = (int)$price;
        if ($priceEur < 0) json_error(400, 'Prezzo non valido.');
      }
      $fields[] = 'price_eur = ?';
      $args[] = $priceEur;
    }
    if (array_key_exists('notes', $body)) {
      $v = trim((string)($body['notes'] ?? ''));
      $fields[] = 'notes = ?';
      $args[] = $v !== '' ? $v : null;
    }
    if (array_key_exists('is_active', $body)) {
      $fields[] = 'is_active = ?';
      $args[] = (int)((bool)$body['is_active']);
    }
    if (array_key_exists('valid_from', $body)) {
      $fields[] = 'valid_from = ?';
      $args[] = $body['valid_from'] ? (string)$body['valid_from'] : null;
    }
    if (array_key_exists('valid_to', $body)) {
      $fields[] = 'valid_to = ?';
      $args[] = $body['valid_to'] ? (string)$body['valid_to'] : null;
    }

    if (!$fields) json_error(400, 'Nessun campo da aggiornare.');
    $args[] = $id;

    $sql = 'UPDATE prices SET ' . implode(', ', $fields) . ' WHERE id = ?';
    $stmt = $pdo->prepare($sql);
    $stmt->execute($args);
    json_ok(['updated' => $stmt->rowCount()]);
  }

  if ($m === 'DELETE') {
    $id = (int)($_GET['id'] ?? 0);
    if ($id <= 0) json_error(400, 'ID mancante.');
    $stmt = $pdo->prepare('DELETE FROM prices WHERE id = ?');
    $stmt->execute([$id]);
    json_ok(['deleted' => $stmt->rowCount()]);
  }

  json_error(405, 'Metodo non consentito.');
} catch (Throwable $e) {
  json_error(500, 'Errore server.');
}

