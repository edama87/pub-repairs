<?php
declare(strict_types=1);

require_once __DIR__ . '/_response.php';

// Config: local first, fallback to example (dev).
$configPathLocal = __DIR__ . '/_config.local.php';
$configPathExample = __DIR__ . '/_config.example.php';
$config = file_exists($configPathLocal) ? require $configPathLocal : require $configPathExample;

if (!is_array($config)) {
  json_error(500, 'Config non valida.');
}

// Session (admin/auth).
$isProd = (bool)($config['is_prod'] ?? false);
if (session_status() !== PHP_SESSION_ACTIVE) {
  session_set_cookie_params([
    'lifetime' => 0,
    'path' => '/',
    'httponly' => true,
    'secure' => $isProd,
    'samesite' => $isProd ? 'Strict' : 'Lax',
  ]);
  session_start();
}

/**
 * @return PDO
 */
function db(): PDO {
  static $pdo = null;
  if ($pdo instanceof PDO) return $pdo;

  /** @var array $config */
  $config = $GLOBALS['config'];
  $db = $config['db'] ?? [];

  $host = (string)($db['host'] ?? '127.0.0.1');
  $port = (int)($db['port'] ?? 3306);
  $name = (string)($db['name'] ?? '');
  $user = (string)($db['user'] ?? '');
  $pass = (string)($db['pass'] ?? '');
  $charset = (string)($db['charset'] ?? 'utf8mb4');

  if ($name === '' || $user === '') {
    json_error(500, 'DB non configurato.');
  }

  $dsn = "mysql:host={$host};port={$port};dbname={$name};charset={$charset}";
  $pdo = new PDO($dsn, $user, $pass, [
    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES => false,
  ]);

  return $pdo;
}

/**
 * Legge JSON dal body.
 * @return array
 */
function read_json_body(): array {
  $raw = file_get_contents('php://input');
  if ($raw === false || trim($raw) === '') return [];
  $data = json_decode($raw, true);
  if (!is_array($data)) json_error(400, 'JSON non valido.');
  return $data;
}

/**
 * Metodo HTTP con override (utile su hosting che non supportano PUT/DELETE).
 * @return string
 */
function http_method(): string {
  $m = strtoupper($_SERVER['REQUEST_METHOD'] ?? 'GET');
  $override = $_SERVER['HTTP_X_HTTP_METHOD_OVERRIDE'] ?? ($_GET['_method'] ?? $_POST['_method'] ?? null);
  if (is_string($override) && $override !== '') {
    $m = strtoupper($override);
  }
  return $m;
}

/**
 * Richiede login admin.
 * @return array user
 */
function require_admin(): array {
  $u = $_SESSION['admin_user'] ?? null;
  if (!is_array($u)) json_error(401, 'Non autenticato.');
  return $u;
}

/**
 * CSRF: token in sessione, richiesto per metodi mutanti.
 * @return string token
 */
function csrf_token(): string {
  $t = $_SESSION['csrf_token'] ?? null;
  if (!is_string($t) || $t === '') {
    $secret = (string)($GLOBALS['config']['app_secret'] ?? '');
    $seed = bin2hex(random_bytes(32));
    $t = hash_hmac('sha256', $seed, $secret !== '' ? $secret : $seed);
    $_SESSION['csrf_token'] = $t;
  }
  return $t;
}

function require_csrf_if_mutating(): void {
  $m = http_method();
  if ($m === 'GET' || $m === 'HEAD' || $m === 'OPTIONS') return;

  $sent = $_SERVER['HTTP_X_CSRF_TOKEN'] ?? ($_POST['csrf_token'] ?? ($_GET['csrf_token'] ?? null));
  if (!is_string($sent) || $sent === '') json_error(403, 'CSRF mancante.');
  if (!hash_equals(csrf_token(), $sent)) json_error(403, 'CSRF non valido.');
}

