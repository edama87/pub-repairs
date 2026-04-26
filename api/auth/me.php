<?php
declare(strict_types=1);

require_once __DIR__ . '/../_bootstrap.php';

if (http_method() !== 'GET') json_error(405, 'Metodo non consentito.');

$user = $_SESSION['admin_user'] ?? null;
if (!is_array($user)) {
  json_ok(['user' => null]);
}

json_ok(['user' => $user, 'csrfToken' => csrf_token()]);

