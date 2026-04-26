<?php
declare(strict_types=1);

require_once __DIR__ . '/../_bootstrap.php';

if (http_method() !== 'POST') json_error(405, 'Metodo non consentito.');

// Se l'utente è loggato, richiediamo CSRF per evitare logout cross-site.
if (isset($_SESSION['admin_user'])) {
  require_csrf_if_mutating();
}

$_SESSION = [];
if (ini_get('session.use_cookies')) {
  $params = session_get_cookie_params();
  setcookie(session_name(), '', time() - 42000, $params['path'], $params['domain'], $params['secure'], $params['httponly']);
}
session_destroy();

json_ok(['loggedOut' => true]);

