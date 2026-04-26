#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

ENV_FILE="${1:-scripts/deploy-aruba.env}"
if [[ ! -f "$ENV_FILE" ]]; then
  echo "Errore: manca $ENV_FILE" >&2
  echo "Copia scripts/deploy-aruba.env.example -> scripts/deploy-aruba.env e compila i campi." >&2
  exit 1
fi

# shellcheck disable=SC1090
source "$ENV_FILE"

require_var() {
  local name="$1"
  if [[ -z "${!name:-}" ]]; then
    echo "Errore: variabile $name mancante in $ENV_FILE" >&2
    exit 1
  fi
}

require_var SFTP_HOST
require_var SFTP_USER
require_var SFTP_PASS
require_var REMOTE_DIR
require_var VITE_BASE

SFTP_PORT="${SFTP_PORT:-22}"

echo "==> Build (VITE_BASE=${VITE_BASE})"
if [[ -f package-lock.json ]]; then
  npm ci
else
  npm install
fi
VITE_BASE="$VITE_BASE" npm run build

if [[ ! -d dist ]]; then
  echo "Errore: dist/ non trovata dopo build." >&2
  exit 1
fi

upload_via_ftps() {
  if ! command -v lftp >/dev/null 2>&1; then
    echo "Errore: lftp non installato (necessario per FTPS)." >&2
    echo "Su macOS: brew install lftp" >&2
    exit 1
  fi

  local host="$SFTP_HOST"
  local port="$SFTP_PORT"
  local user="$SFTP_USER"
  local pass="$SFTP_PASS"
  local remote="$REMOTE_DIR"

  echo "==> Upload FTPS verso ${host}:${port}${remote}"

  # Mirror: carica dist/ nel remote root, poi api/ e admin/ nelle loro cartelle.
  # Aruba/hosting shared: spesso serve FTPS esplicito (porta 21).
  lftp -u "${user},${pass}" "ftp://${host}:${port}" <<EOF
set ftp:ssl-force true
set ftp:ssl-protect-data true
set ftp:ssl-auth TLS
set ssl:verify-certificate no
set ftp:transfer-type binary
set xfer:clobber on
set net:timeout 20
set net:max-retries 2
set cmd:fail-exit yes

# Le mkdir falliscono se la cartella esiste: non blocchiamo il deploy.
set cmd:fail-exit no
mkdir -p ${remote}
cd ${remote}
mkdir -p api
mkdir -p admin
set cmd:fail-exit yes

# Forza sovrascrittura (utile quando il server preserva timestamp/ETag).
mirror -R --overwrite --parallel=2 --verbose=3 dist .
mirror -R --overwrite --parallel=2 --verbose=3 api api
mirror -R --overwrite --parallel=2 --verbose=3 admin admin
bye
EOF

  if [[ -n "${LOCAL_API_CONFIG:-}" && -f "${LOCAL_API_CONFIG:-}" ]]; then
    echo "==> Upload config locale API come api/_config.local.php (FTPS)"
    lftp -u "${user},${pass}" "ftp://${host}:${port}" <<EOF
set ftp:ssl-force true
set ftp:ssl-protect-data true
set ftp:ssl-auth TLS
set ssl:verify-certificate no
set net:timeout 20
set net:max-retries 2
cd ${remote}/api
put ${LOCAL_API_CONFIG} -o _config.local.php
bye
EOF
  fi
}

USE_SSHPASS="0"
if [[ "$SFTP_PORT" == "21" ]]; then
  # FTPS (porta 21): NON modifichiamo lo username, Aruba spesso richiede "12345@aruba.it".
  upload_via_ftps
  echo "OK: deploy completato."
  exit 0
fi

if ! command -v sftp >/dev/null 2>&1; then
  echo "Errore: sftp non disponibile sul sistema." >&2
  exit 1
fi

# SFTP (porta 22): Aruba spesso fornisce username del tipo "12345@aruba.it".
# Per sftp serve solo la parte prima della @.
if [[ "$SFTP_USER" == *@* ]]; then
  echo "Nota: SFTP_USER contiene '@' (${SFTP_USER}). Uso solo la parte prima di '@' (solo SFTP)." >&2
  SFTP_USER="${SFTP_USER%%@*}"
fi

if command -v sshpass >/dev/null 2>&1; then USE_SSHPASS="1"; fi

SFTP_OPTS=(-P "$SFTP_PORT" -oBatchMode=no -oStrictHostKeyChecking=accept-new -oConnectTimeout=10)
TARGET="${SFTP_USER}@${SFTP_HOST}"

upload_batch() {
  # Creiamo cartelle principali, poi carichiamo: dist/* + api/ + admin/
  # NB: sftp non fa delete remoto: se vuoi pulire, fallo dal pannello Aruba o aggiungiamo una fase ad hoc.
  cat <<EOF
mkdir ${REMOTE_DIR}
cd ${REMOTE_DIR}
mkdir api
mkdir admin
put -r dist/* .
put -r api/* api
put -r admin/* admin
EOF
}

echo "==> Upload SFTP verso ${TARGET}:${REMOTE_DIR}"
if [[ "$USE_SSHPASS" == "1" ]]; then
  upload_batch | sshpass -p "$SFTP_PASS" sftp "${SFTP_OPTS[@]}" -b - "$TARGET"
else
  # modalità interattiva: password richiesta da sftp
  echo "Nota: sshpass non trovato. Userò sftp interattivo (ti chiederà la password)." >&2
  echo "Su macOS: brew install hudochenkov/sshpass/sshpass" >&2
  upload_batch > /tmp/officinaephone_sftp_batch.txt
  sftp "${SFTP_OPTS[@]}" -b /tmp/officinaephone_sftp_batch.txt "$TARGET"
  rm -f /tmp/officinaephone_sftp_batch.txt
fi

if [[ -n "${LOCAL_API_CONFIG:-}" ]]; then
  if [[ -f "$LOCAL_API_CONFIG" ]]; then
    echo "==> Upload config locale API come api/_config.local.php"
    if [[ "$USE_SSHPASS" == "1" ]]; then
      sshpass -p "$SFTP_PASS" sftp "${SFTP_OPTS[@]}" "$TARGET" <<EOF
cd ${REMOTE_DIR}/api
put ${LOCAL_API_CONFIG} _config.local.php
EOF
    else
      sftp "${SFTP_OPTS[@]}" "$TARGET" <<EOF
cd ${REMOTE_DIR}/api
put ${LOCAL_API_CONFIG} _config.local.php
EOF
    fi
  else
    echo "Attenzione: LOCAL_API_CONFIG impostato ma file non trovato: $LOCAL_API_CONFIG" >&2
  fi
fi

echo "OK: deploy completato."

