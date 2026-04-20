import './styles/base.css';
import './styles/layout.css';
import './styles/components.css';
import './styles/bokeh.css';
import './styles/servizi.css';

import { mountChrome, setYear } from './chrome.js';

mountChrome('servizi');
setYear();

const catSelect = document.getElementById('device-category');
const modelSelect = document.getElementById('device-model');
const tbody = document.getElementById('price-tbody');
const listinoNote = document.getElementById('listino-note');
const ipadRoot = document.getElementById('ipad-blocks');
const searchForm = document.getElementById('listino-search-form');
const searchInput = document.getElementById('listino-search-input');
const searchStatus = document.getElementById('listino-search-status');

/** @type {Record<string, { models: string[], repairs: { label: string, prices: (number|null)[] }[] } | undefined>} */
let matrices = {};

/** Dati iPad completi (per filtri ricerca). */
let ipadListinoFull = null;

/** Filtro opzionale sulle righe intervento (iPhone). */
let interventionFilter = '';

function setSearchStatus(text) {
  if (searchStatus) searchStatus.textContent = text ?? '';
}

function normalizeQuery(q) {
  return String(q ?? '')
    .trim()
    .toLowerCase();
}

function syncPanelsForCategory(v) {
  const modelWrap = document.getElementById('iphone-model-wrap');
  const tablePanel = document.getElementById('iphone-table-panel');
  const ipadPanel = document.getElementById('ipad-panel');
  const altriPanel = document.getElementById('altri-panel');
  const foot = document.getElementById('iphone-recent-footnote');
  if (!modelWrap || !tablePanel || !ipadPanel || !altriPanel) return;

  const isIphone = v === 'iphone-legacy' || v === 'iphone-recent';
  modelWrap.hidden = !isIphone;
  tablePanel.hidden = !isIphone;
  ipadPanel.hidden = v !== 'ipad';
  altriPanel.hidden = v !== 'altri';
  if (foot) foot.hidden = v !== 'iphone-recent';
}

function fillModels(catId) {
  if (!modelSelect) return;
  modelSelect.innerHTML = '';
  const data = matrices[catId];
  if (!data) return;
  const ph = document.createElement('option');
  ph.value = '';
  ph.textContent = 'Scegli il modello…';
  modelSelect.appendChild(ph);
  data.models.forEach((m, i) => {
    const o = document.createElement('option');
    o.value = String(i);
    o.textContent = m;
    modelSelect.appendChild(o);
  });
}

function formatPrice(n) {
  if (n === null || n === undefined) return '—';
  return `${n} €`;
}

function renderIphoneTable(catId, modelIndex) {
  if (!tbody) return;
  tbody.innerHTML = '';
  const data = matrices[catId];
  if (!data || modelIndex === '') {
    const tr = document.createElement('tr');
    tr.innerHTML = '<td colspan="2">Seleziona un modello per vedere i prezzi.</td>';
    tbody.appendChild(tr);
    return;
  }
  const idx = Number(modelIndex);
  const needle = normalizeQuery(interventionFilter);
  let rows = data.repairs;
  if (needle) {
    rows = rows.filter((r) => r.label.toLowerCase().includes(needle));
  }
  if (rows.length === 0) {
    const tr = document.createElement('tr');
    tr.innerHTML =
      '<td colspan="2">Nessun intervento corrisponde al filtro. Prova un altro termine o cancella la ricerca.</td>';
    tbody.appendChild(tr);
    return;
  }
  for (const row of rows) {
    const tr = document.createElement('tr');
    const td1 = document.createElement('td');
    td1.textContent = row.label;
    const td2 = document.createElement('td');
    td2.className = 'price-cell';
    td2.textContent = formatPrice(row.prices[idx]);
    tr.appendChild(td1);
    tr.appendChild(td2);
    tbody.appendChild(tr);
  }
}

function escapeHtml(s) {
  return String(s)
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;');
}

function blockMatchesSearch(b, needle) {
  if (!needle) return true;
  const n = needle.toLowerCase();
  if (b.titolo.toLowerCase().includes(n)) return true;
  if (b.nota && b.nota.toLowerCase().includes(n)) return true;
  return b.righe.some(
    (r) => r.voce.toLowerCase().includes(n) || r.prezzo.toLowerCase().includes(n),
  );
}

function renderIpad(ipadListino, filterQuery = '') {
  if (!ipadRoot) return;
  const needle = normalizeQuery(filterQuery);
  const blocks = needle
    ? ipadListino.blocks.filter((b) => blockMatchesSearch(b, needle))
    : ipadListino.blocks;

  ipadRoot.innerHTML = blocks
    .map(
      (b) => `
    <article class="ipad-block">
      <h3 class="ipad-block__title">${escapeHtml(b.titolo)}</h3>
      ${b.nota ? `<p class="ipad-block__nota">${escapeHtml(b.nota)}</p>` : ''}
      <dl class="ipad-block__list">
        ${b.righe.map((r) => `<div class="ipad-block__row"><dt>${escapeHtml(r.voce)}</dt><dd>${escapeHtml(r.prezzo)}</dd></div>`).join('')}
      </dl>
    </article>`,
    )
    .join('');
}

function findFirstModelIndex(models, needle) {
  if (!needle) return -1;
  const n = needle.toLowerCase();
  return models.findIndex((m) => m.toLowerCase().includes(n));
}

function hasInterventionMatch(needle) {
  if (!needle) return false;
  const n = needle.toLowerCase();
  for (const key of ['iphone-recent', 'iphone-legacy']) {
    const m = matrices[key];
    if (!m) continue;
    for (const r of m.repairs) {
      if (r.label.toLowerCase().includes(n)) return true;
    }
  }
  return false;
}

function hasIpadContentMatch(needle) {
  if (!ipadListinoFull || !needle) return false;
  return ipadListinoFull.blocks.some((b) => blockMatchesSearch(b, needle));
}

function applyIphoneModel(catId, modelIndex) {
  if (!catSelect || !modelSelect) return;
  interventionFilter = '';
  catSelect.value = catId;
  syncPanelsForCategory(catId);
  fillModels(catId);
  modelSelect.value = String(modelIndex);
  renderIphoneTable(catId, String(modelIndex));
}

function tryNavigateModel(needle) {
  const recent = matrices['iphone-recent'];
  const legacy = matrices['iphone-legacy'];
  if (!recent || !legacy) return false;

  const idxR = findFirstModelIndex(recent.models, needle);
  if (idxR >= 0) {
    applyIphoneModel('iphone-recent', idxR);
    setSearchStatus(`Trovato: ${recent.models[idxR]} (modelli recenti).`);
    return true;
  }
  const idxL = findFirstModelIndex(legacy.models, needle);
  if (idxL >= 0) {
    applyIphoneModel('iphone-legacy', idxL);
    setSearchStatus(`Trovato: ${legacy.models[idxL]} (modelli precedenti).`);
    return true;
  }
  return false;
}

function applyIpadSearch(needle) {
  if (!catSelect) return;
  interventionFilter = '';
  catSelect.value = 'ipad';
  syncPanelsForCategory('ipad');
  renderIpad(ipadListinoFull, needle);
  const n = ipadRoot?.querySelectorAll('.ipad-block').length ?? 0;
  setSearchStatus(
    n === 0
      ? `Nessun risultato iPad per «${needle}».`
      : n === 1
        ? '1 risultato nella sezione iPad.'
        : `${n} risultati nella sezione iPad.`,
  );
}

function applyInterventionSearch(needle) {
  const recent = matrices['iphone-recent'];
  if (!recent || !catSelect || !modelSelect) return;
  interventionFilter = needle;
  catSelect.value = 'iphone-recent';
  syncPanelsForCategory('iphone-recent');
  fillModels('iphone-recent');
  modelSelect.value = '0';
  renderIphoneTable('iphone-recent', '0');
  setSearchStatus('Filtro interventi su iPhone modelli recenti (primo modello in elenco). Cambia il modello qui sotto se serve.');
}

function clearSearchFilters() {
  interventionFilter = '';
  setSearchStatus('');
  if (ipadListinoFull) renderIpad(ipadListinoFull, '');
  const cat = catSelect?.value;
  if (cat === 'iphone-legacy' || cat === 'iphone-recent') {
    renderIphoneTable(cat, modelSelect?.value ?? '');
  }
}

function onSearchSubmit(e) {
  e.preventDefault();
  const raw = searchInput?.value ?? '';
  const needle = normalizeQuery(raw);

  if (!needle) {
    clearSearchFilters();
    return;
  }

  if (tryNavigateModel(needle)) return;

  if (hasIpadContentMatch(needle)) {
    applyIpadSearch(needle);
    return;
  }

  if (hasInterventionMatch(needle)) {
    applyInterventionSearch(needle);
    return;
  }

  setSearchStatus(`Nessun risultato per «${raw.trim()}». Prova un modello, un termine iPad o un tipo di intervento.`);
}

function onCategoryChange() {
  const v = catSelect?.value;
  if (!v) return;
  syncPanelsForCategory(v);

  if (v !== 'iphone-legacy' && v !== 'iphone-recent') {
    interventionFilter = '';
  }

  if (v === 'iphone-legacy' || v === 'iphone-recent') {
    fillModels(v);
    modelSelect.value = '';
    renderIphoneTable(v, '');
  }
  if (v === 'ipad' && ipadListinoFull) {
    renderIpad(ipadListinoFull, '');
  }
}

function onModelChange() {
  const cat = catSelect?.value;
  if (cat !== 'iphone-legacy' && cat !== 'iphone-recent') return;
  renderIphoneTable(cat, modelSelect?.value ?? '');
}

if (catSelect) {
  catSelect.addEventListener('change', onCategoryChange);
}
if (modelSelect) {
  modelSelect.addEventListener('change', onModelChange);
}
if (searchForm) {
  searchForm.addEventListener('submit', onSearchSubmit);
}

function setLoadingUi(loading) {
  if (catSelect) catSelect.disabled = loading;
  if (modelSelect) modelSelect.disabled = loading;
  if (searchInput) searchInput.disabled = loading;
  if (searchForm) {
    const btn = searchForm.querySelector('button[type="submit"]');
    if (btn) btn.disabled = loading;
  }
  if (tbody && loading) {
    tbody.innerHTML = '<tr><td colspan="2">Caricamento listino…</td></tr>';
  }
}

function showListinoError(msg) {
  if (listinoNote) listinoNote.textContent = msg;
  if (tbody) tbody.innerHTML = '<tr><td colspan="2">Listino non disponibile al momento.</td></tr>';
}

async function loadListino() {
  setLoadingUi(true);
  const url = `${import.meta.env.BASE_URL}data/listino.json`;
  try {
    const res = await fetch(url, { cache: 'no-store' });
    if (!res.ok) throw new Error(`${res.status}`);
    const data = await res.json();
    const { listinoMeta, iphoneLegacy, iphoneRecent, ipadListino, altriDispositivi } = data;

    if (listinoNote) listinoNote.textContent = listinoMeta.disclaimer;
    matrices = {
      'iphone-legacy': iphoneLegacy,
      'iphone-recent': iphoneRecent,
    };
    ipadListinoFull = ipadListino;
    renderIpad(ipadListino);

    const altriEl = document.getElementById('altri-body');
    if (altriEl) {
      altriEl.innerHTML = `<p>${escapeHtml(altriDispositivi.body)}</p>`;
    }

    setLoadingUi(false);
    onCategoryChange();
  } catch {
    showListinoError(
      'Impossibile caricare il listino. Ricarica la pagina o contattaci in negozio per i prezzi aggiornati.',
    );
    setLoadingUi(false);
  }
}

loadListino();
