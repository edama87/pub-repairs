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

SFTP_PORT="${SFTP_PORT:-22}"

# Aruba spesso fornisce username del tipo "12345@aruba.it".
# Per sftp serve solo la parte prima della @.
if [[ "$SFTP_USER" == *@* ]]; then
  echo "Nota: SFTP_USER contiene '@' (${SFTP_USER}). Uso solo la parte prima di '@'." >&2
  SFTP_USER="${SFTP_USER%%@*}"
fi

USE_SSHPASS="0"
if command -v sshpass >/dev/null 2>&1; then
  USE_SSHPASS="1"
else
  echo "Nota: sshpass non trovato. Userò sftp interattivo (ti chiederà la password)." >&2
fi

SFTP_OPTS=(-P "$SFTP_PORT" -oBatchMode=no -oStrictHostKeyChecking=accept-new -oConnectTimeout=10)
TARGET="${SFTP_USER}@${SFTP_HOST}"

LOCAL_FILE="scripts/officinaephone_sftp_probe.html"
REMOTE_NAME="officinaephone_sftp_probe.html"

echo "==> Upload probe verso ${TARGET}:${REMOTE_DIR}/${REMOTE_NAME}"
if [[ "$USE_SSHPASS" == "1" ]]; then
  sshpass -p "$SFTP_PASS" sftp "${SFTP_OPTS[@]}" "$TARGET" <<EOF
mkdir ${REMOTE_DIR}
cd ${REMOTE_DIR}
put ${LOCAL_FILE} ${REMOTE_NAME}
EOF
else
  sftp "${SFTP_OPTS[@]}" "$TARGET" <<EOF
mkdir ${REMOTE_DIR}
cd ${REMOTE_DIR}
put ${LOCAL_FILE} ${REMOTE_NAME}
EOF
fi

echo "OK: probe caricato."

