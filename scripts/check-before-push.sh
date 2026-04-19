#!/usr/bin/env bash
# Controlli opzionali prima di git push (non sono obbligatori per GitHub Pages).
#
# Cosa succede su GitHub:
#   - NON serve committare la cartella dist/ (è in .gitignore).
#   - Il workflow Actions esegue npm ci + build lì e pubblica dist.
#
# A cosa serve questo script:
#   - Verificare in locale che la build vada a buon fine (eviti un push che fallisce in CI).
#   - Verificare anche la build con base /pub-repairs/ come su GitHub Pages.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

echo "==> OfficinaePhone — verifica pre-push"
echo "    Directory: $ROOT"
echo ""

if [[ ! -f package-lock.json ]]; then
  echo "Errore: manca package-lock.json (esegui prima npm install)." >&2
  exit 1
fi

echo "==> npm ci (dipendenze pulite, come su GitHub Actions)"
npm ci

echo ""
echo "==> Build locale (base / — sviluppo)"
npm run build

echo ""
echo "==> Build GitHub Pages (base /pub-repairs/)"
npm run build:gh-pages

echo ""
echo "OK: puoi fare commit e push. La pubblicazione su Pages la fa il workflow, non i file in dist/."
