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

FTPS_PORT="${SFTP_PORT:-21}"

if ! command -v lftp >/dev/null 2>&1; then
  echo "Errore: lftp non installato." >&2
  echo "Su macOS: brew install lftp" >&2
  exit 1
fi

LOCAL_FILE="scripts/officinaephone_sftp_probe.html"
REMOTE_NAME="officinaephone_sftp_probe.html"

echo "==> Upload probe via FTPS verso ${SFTP_HOST}:${FTPS_PORT}${REMOTE_DIR}/${REMOTE_NAME}"

# Aruba: FTPS esplicito (porta 21). Disabilito la verifica certificato perché spesso su hosting shared è un wildcard/non perfetto.
lftp -u "${SFTP_USER},${SFTP_PASS}" "ftp://${SFTP_HOST}:${FTPS_PORT}" <<EOF
set ftp:ssl-force true
set ftp:ssl-protect-data true
set ftp:ssl-auth TLS
set ssl:verify-certificate no
set net:timeout 10
set net:max-retries 2

mkdir -p ${REMOTE_DIR}
cd ${REMOTE_DIR}
put ${LOCAL_FILE} -o ${REMOTE_NAME}
bye
EOF

echo "OK: probe caricato."

