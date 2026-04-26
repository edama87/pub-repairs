<?php
declare(strict_types=1);

require_once __DIR__ . '/../_bootstrap.php';

$user = require_admin();
require_csrf_if_mutating();

$m = http_method();

try {
  $pdo = db();

  if ($m === 'GET') {
    $scope = isset($_GET['scope']) ? (string)$_GET['scope'] : null;
    $activeOnly = isset($_GET['activeOnly']) ? (string)$_GET['activeOnly'] : null;

    $where = [];
    $args = [];
    if ($scope) {
      $where[] = 'scope = ?';
      $args[] = $scope;
    }
    if ($activeOnly === '1') $where[] = 'is_active = 1';

    $sql = 'SELECT id, `key`, label, scope, sort_order, is_active FROM repair_types';
    if ($where) $sql .= ' WHERE ' . implode(' AND ', $where);
    $sql .= ' ORDER BY scope ASC, sort_order ASC, label ASC';
    $stmt = $pdo->prepare($sql);
    $stmt->execute($args);
    json_ok(['items' => $stmt->fetchAll(), 'user' => $user]);
  }

  if ($m === 'POST') {
    $body = read_json_body();
    $key = trim((string)($body['key'] ?? ''));
    $label = trim((string)($body['label'] ?? ''));
    $scope = (string)($body['scope'] ?? 'iphone');
    $sort = (int)($body['sort_order'] ?? 0);
    $isActive = isset($body['is_active']) ? (int)((bool)$body['is_active']) : 1;

    if ($key === '' || $label === '') json_error(400, 'Dati mancanti.');
    if (!preg_match('/^[a-zA-Z0-9_]+$/', $key)) json_error(400, 'Key non valida (usa a-z, 0-9, _).');
    if (!in_array($scope, ['iphone', 'ipad', 'other'], true)) json_error(400, 'Scope non valido.');

    $stmt = $pdo->prepare('INSERT INTO repair_types (`key`, label, scope, sort_order, is_active) VALUES (?, ?, ?, ?, ?)');
    $stmt->execute([$key, $label, $scope, $sort, $isActive]);
    json_ok(['id' => (int)$pdo->lastInsertId()]);
  }

  if ($m === 'PUT') {
    $body = read_json_body();
    $id = (int)($body['id'] ?? 0);
    if ($id <= 0) json_error(400, 'ID mancante.');

    $fields = [];
    $args = [];

    if (array_key_exists('key', $body)) {
      $key = trim((string)$body['key']);
      if ($key === '' || !preg_match('/^[a-zA-Z0-9_]+$/', $key)) json_error(400, 'Key non valida.');
      $fields[] = '`key` = ?';
      $args[] = $key;
    }
    if (array_key_exists('label', $body)) {
      $fields[] = 'label = ?';
      $args[] = trim((string)$body['label']);
    }
    if (array_key_exists('scope', $body)) {
      $scope = (string)$body['scope'];
      if (!in_array($scope, ['iphone', 'ipad', 'other'], true)) json_error(400, 'Scope non valido.');
      $fields[] = 'scope = ?';
      $args[] = $scope;
    }
    if (array_key_exists('sort_order', $body)) {
      $fields[] = 'sort_order = ?';
      $args[] = (int)$body['sort_order'];
    }
    if (array_key_exists('is_active', $body)) {
      $fields[] = 'is_active = ?';
      $args[] = (int)((bool)$body['is_active']);
    }

    if (!$fields) json_error(400, 'Nessun campo da aggiornare.');
    $args[] = $id;

    $sql = 'UPDATE repair_types SET ' . implode(', ', $fields) . ' WHERE id = ?';
    $stmt = $pdo->prepare($sql);
    $stmt->execute($args);
    json_ok(['updated' => $stmt->rowCount()]);
  }

  if ($m === 'DELETE') {
    $id = (int)($_GET['id'] ?? 0);
    if ($id <= 0) json_error(400, 'ID mancante.');
    $stmt = $pdo->prepare('DELETE FROM repair_types WHERE id = ?');
    $stmt->execute([$id]);
    json_ok(['deleted' => $stmt->rowCount()]);
  }

  json_error(405, 'Metodo non consentito.');
} catch (Throwable $e) {
  json_error(500, 'Errore server.');
}

