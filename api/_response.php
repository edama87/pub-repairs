<?php
declare(strict_types=1);

function json_response(int $status, $payload): void {
  http_response_code($status);
  header('Content-Type: application/json; charset=utf-8');
  header('Cache-Control: no-store');
  echo json_encode($payload, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
  exit;
}

function json_ok($data = null): void {
  json_response(200, ['ok' => true, 'data' => $data]);
}

function json_error(int $status, string $message, $details = null): void {
  json_response($status, ['ok' => false, 'error' => ['message' => $message, 'details' => $details]]);
}

