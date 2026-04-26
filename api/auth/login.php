<?php
declare(strict_types=1);

require_once __DIR__ . '/../_bootstrap.php';

if (http_method() !== 'POST') json_error(405, 'Metodo non consentito.');

$body = read_json_body();
$username = trim((string)($body['username'] ?? ''));
$password = (string)($body['password'] ?? '');

if ($username === '' || $password === '') {
  json_error(400, 'Credenziali mancanti.');
}

try {
  $stmt = db()->prepare('SELECT id, username, password_hash, role, is_active FROM admin_users WHERE username = ? LIMIT 1');
  $stmt->execute([$username]);
  $row = $stmt->fetch();
  if (!$row || !(int)$row['is_active']) {
    json_error(401, 'Credenziali non valide.');
  }
  if (!password_verify($password, (string)$row['password_hash'])) {
    json_error(401, 'Credenziali non valide.');
  }

  $_SESSION['admin_user'] = [
    'id' => (int)$row['id'],
    'username' => (string)$row['username'],
    'role' => (string)$row['role'],
  ];
  $csrf = csrf_token();
  json_ok(['user' => $_SESSION['admin_user'], 'csrfToken' => $csrf]);
} catch (Throwable $e) {
  json_error(500, 'Errore login.');
}

