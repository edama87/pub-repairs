<?php
declare(strict_types=1);

// Pagina TEMPORANEA: genera password_hash e snippet SQL.
// Protezione: richiede token `k` uguale a `app_secret` del config API.

require_once __DIR__ . '/../api/_bootstrap.php';

$secret = (string)($GLOBALS['config']['app_secret'] ?? '');
$k = (string)($_GET['k'] ?? '');

if ($secret === '' || $k === '' || !hash_equals($secret, $k)) {
  http_response_code(404);
  header('Content-Type: text/plain; charset=utf-8');
  echo "Not found";
  exit;
}

$username = '';
$password = '';
$hash = '';

if (($_SERVER['REQUEST_METHOD'] ?? 'GET') === 'POST') {
  $username = trim((string)($_POST['username'] ?? 'admin'));
  $password = (string)($_POST['password'] ?? '');
  if ($username !== '' && $password !== '') {
    $hash = password_hash($password, PASSWORD_DEFAULT);
  }
}
?><!doctype html>
<html lang="it">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <title>Admin — Genera password hash</title>
    <style>
      body { font-family: system-ui, -apple-system, Segoe UI, Roboto, sans-serif; padding: 20px; max-width: 900px; margin: 0 auto; }
      input { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 10px; }
      label { display: block; margin: 12px 0 6px; font-weight: 600; }
      button { margin-top: 14px; padding: 10px 14px; border-radius: 10px; border: 1px solid #333; background: #111; color: #fff; cursor: pointer; }
      pre { background: #f6f7f9; padding: 12px; border-radius: 12px; overflow: auto; }
      .warn { background: #fff4e5; border: 1px solid #ffd8a8; padding: 10px 12px; border-radius: 12px; }
      code { background: #f1f3f5; padding: 2px 6px; border-radius: 8px; }
    </style>
  </head>
  <body>
    <h1>Generatore hash password (temporaneo)</h1>
    <p class="warn">
      Questa pagina è pensata solo per bootstrap iniziale. Dopo aver creato l’utente admin, elimina <code>admin/hash.php</code> dal server.
    </p>

    <form method="post">
      <label>Username</label>
      <input name="username" autocomplete="off" value="<?= htmlspecialchars($username !== '' ? $username : 'admin', ENT_QUOTES) ?>" />

      <label>Password (in chiaro)</label>
      <input name="password" type="password" autocomplete="new-password" />

      <button type="submit">Genera</button>
    </form>

    <?php if ($hash !== ''): ?>
      <h2>Hash</h2>
      <pre><?= htmlspecialchars($hash, ENT_QUOTES) ?></pre>

      <h2>SQL (copia/incolla in phpMyAdmin)</h2>
      <pre>INSERT INTO admin_users (username, password_hash, role, is_active)
VALUES ('<?= htmlspecialchars($username, ENT_QUOTES) ?>', '<?= htmlspecialchars($hash, ENT_QUOTES) ?>', 'admin', 1);</pre>
    <?php elseif (($_SERVER['REQUEST_METHOD'] ?? 'GET') === 'POST'): ?>
      <p>Inserisci username e password.</p>
    <?php endif; ?>
  </body>
</html>

