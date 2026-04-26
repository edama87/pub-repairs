<?php
declare(strict_types=1);

require_once __DIR__ . '/../_bootstrap.php';

require_admin();
require_csrf_if_mutating();

$m = http_method();

const MAX_BYTES = 3145728; // 3MB
const MAX_MAIN = 1200;
const MAX_THUMB = 320;

function web_root_base(): string {
  // /officinaephone/api/admin/device_image.php -> /officinaephone/
  $uri = (string)($_SERVER['REQUEST_URI'] ?? '/');
  $path = parse_url($uri, PHP_URL_PATH) ?: '/';
  $base = preg_replace('#/api/.*$#', '/', $path);
  return $base ?: '/';
}

function upload_dirs(): array {
  $publicDir = realpath(__DIR__ . '/../../public');
  if ($publicDir === false) {
    json_error(500, 'Public dir non trovato.');
  }
  $abs = $publicDir . '/images/devices/uploads';
  $rel = 'images/devices/uploads';
  return [$abs, $rel];
}

function ensure_dir(string $absDir): void {
  if (is_dir($absDir)) return;
  if (!@mkdir($absDir, 0775, true) && !is_dir($absDir)) {
    json_error(500, 'Cartella upload non scrivibile.');
  }
}

function detect_ext(string $mime): ?string {
  return match ($mime) {
    'image/jpeg' => 'jpg',
    'image/png' => 'png',
    'image/webp' => 'webp',
    default => null,
  };
}

function gd_available(): bool {
  return function_exists('imagecreatetruecolor') && function_exists('imagecreatefromstring');
}

function resize_to_max($srcIm, int $maxSide) {
  $w = imagesx($srcIm);
  $h = imagesy($srcIm);
  if ($w <= 0 || $h <= 0) return null;
  $max = max($w, $h);
  if ($max <= $maxSide) return $srcIm;
  $scale = $maxSide / $max;
  $nw = (int)max(1, round($w * $scale));
  $nh = (int)max(1, round($h * $scale));
  $dst = imagecreatetruecolor($nw, $nh);
  imagealphablending($dst, false);
  imagesavealpha($dst, true);
  imagecopyresampled($dst, $srcIm, 0, 0, 0, 0, $nw, $nh, $w, $h);
  return $dst;
}

function save_image($im, string $ext, string $absPath): void {
  if ($ext === 'jpg') {
    imagejpeg($im, $absPath, 85);
    return;
  }
  if ($ext === 'png') {
    imagepng($im, $absPath, 6);
    return;
  }
  if ($ext === 'webp' && function_exists('imagewebp')) {
    imagewebp($im, $absPath, 82);
    return;
  }
  // fallback
  imagejpeg($im, $absPath, 85);
}

try {
  $pdo = db();

  if ($m === 'POST') {
    $deviceId = (int)($_POST['device_id'] ?? 0);
    if ($deviceId <= 0) json_error(400, 'device_id mancante.');

    if (!isset($_FILES['image'])) json_error(400, 'File mancante.');
    $f = $_FILES['image'];
    if (!is_array($f) || ($f['error'] ?? UPLOAD_ERR_NO_FILE) !== UPLOAD_ERR_OK) {
      json_error(400, 'Upload fallito.');
    }
    $size = (int)($f['size'] ?? 0);
    if ($size <= 0 || $size > MAX_BYTES) json_error(400, 'File troppo grande (max 3MB).');

    $tmp = (string)($f['tmp_name'] ?? '');
    if ($tmp === '' || !is_uploaded_file($tmp)) json_error(400, 'File non valido.');

    $mime = mime_content_type($tmp) ?: '';
    $ext = detect_ext($mime);
    if ($ext === null) json_error(400, 'Formato non supportato (jpg/png/webp).');

    [$absDir, $relDir] = upload_dirs();
    ensure_dir($absDir);

    $stamp = (string)time();
    $baseName = "device_{$deviceId}_{$stamp}";
    $mainName = "{$baseName}.{$ext}";
    $thumbName = "{$baseName}_thumb.{$ext}";

    $absMain = $absDir . '/' . $mainName;
    $absThumb = $absDir . '/' . $thumbName;

    $webBase = web_root_base();
    $relMain = "{$relDir}/{$mainName}";
    $relThumb = "{$relDir}/{$thumbName}";
    $webMain = rtrim($webBase, '/') . '/' . $relMain;
    $webThumb = rtrim($webBase, '/') . '/' . $relThumb;

    // Se GD c'è: resize+thumb. Altrimenti salva com'è (solo main).
    if (gd_available()) {
      $bytes = file_get_contents($tmp);
      if ($bytes === false) json_error(400, 'Impossibile leggere immagine.');
      $src = @imagecreatefromstring($bytes);
      if (!$src) json_error(400, 'Immagine non valida.');

      $mainIm = resize_to_max($src, MAX_MAIN);
      $thumbIm = resize_to_max($src, MAX_THUMB);

      if (!$mainIm || !$thumbIm) json_error(400, 'Immagine non valida.');

      save_image($mainIm, $ext, $absMain);
      save_image($thumbIm, $ext, $absThumb);

      if ($mainIm !== $src) imagedestroy($mainIm);
      if ($thumbIm !== $src) imagedestroy($thumbIm);
      imagedestroy($src);
    } else {
      if (!move_uploaded_file($tmp, $absMain)) json_error(500, 'Impossibile salvare file.');
      // thumb = main se non possiamo generarla
      $webThumb = $webMain;
    }

    // Rimuovi vecchi file (best-effort)
    $old = $pdo->prepare('SELECT image_path, thumb_path FROM devices WHERE id = ? LIMIT 1');
    $old->execute([$deviceId]);
    $row = $old->fetch();
    if ($row) {
      foreach (['image_path', 'thumb_path'] as $k) {
        $p = $row[$k] ?? null;
        if (is_string($p) && $p !== '') {
          // convert web path to abs if within uploads
          $pos = strpos($p, '/' . $relDir . '/');
          if ($pos !== false) {
            $file = substr($p, $pos + 1);
            $abs = $publicDir = realpath(__DIR__ . '/../../public');
            if ($abs !== false) {
              $candidate = $abs . '/' . $file;
              @unlink($candidate);
            }
          }
        }
      }
    }

    $upd = $pdo->prepare('UPDATE devices SET image_path=?, thumb_path=?, image_updated_at=NOW() WHERE id=?');
    $upd->execute([$webMain, $webThumb, $deviceId]);

    json_ok(['deviceId' => $deviceId, 'imagePath' => $webMain, 'thumbPath' => $webThumb]);
  }

  if ($m === 'DELETE') {
    $deviceId = (int)($_GET['device_id'] ?? 0);
    if ($deviceId <= 0) json_error(400, 'device_id mancante.');

    $stmt = $pdo->prepare('SELECT image_path, thumb_path FROM devices WHERE id = ? LIMIT 1');
    $stmt->execute([$deviceId]);
    $row = $stmt->fetch();
    if ($row) {
      [$absDir, $relDir] = upload_dirs();
      $publicDir = realpath(__DIR__ . '/../../public');
      foreach (['image_path', 'thumb_path'] as $k) {
        $p = $row[$k] ?? null;
        if (is_string($p) && $p !== '') {
          $pos = strpos($p, '/' . $relDir . '/');
          if ($pos !== false && $publicDir !== false) {
            $file = substr($p, $pos + 1); // images/devices/uploads/...
            @unlink($publicDir . '/' . $file);
          }
        }
      }
    }
    $upd = $pdo->prepare('UPDATE devices SET image_path=NULL, thumb_path=NULL, image_updated_at=NOW() WHERE id=?');
    $upd->execute([$deviceId]);
    json_ok(['deviceId' => $deviceId, 'removed' => true]);
  }

  json_error(405, 'Metodo non consentito.');
} catch (Throwable $e) {
  json_error(500, 'Errore server.');
}

