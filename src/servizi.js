import './styles/base.css';
import './styles/layout.css';
import './styles/components.css';
import './styles/bokeh.css';
import './styles/servizi.css';

import { mountChrome, setYear } from './chrome.js';
import {
  listinoMeta,
  iphoneLegacy,
  iphoneRecent,
  ipadListino,
  altriDispositivi,
} from './data/listino-aprile-2026.js';

mountChrome('servizi');
setYear();

const catSelect = document.getElementById('device-category');
const modelSelect = document.getElementById('device-model');
const tbody = document.getElementById('price-tbody');
const listinoNote = document.getElementById('listino-note');
const ipadRoot = document.getElementById('ipad-blocks');

if (listinoNote) {
  listinoNote.textContent = listinoMeta.disclaimer;
}

const matrices = {
  'iphone-legacy': iphoneLegacy,
  'iphone-recent': iphoneRecent,
};

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
  for (const row of data.repairs) {
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

function renderIpad() {
  if (!ipadRoot) return;
  ipadRoot.innerHTML = ipadListino.blocks
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

function escapeHtml(s) {
  return String(s)
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;');
}

function onCategoryChange() {
  const v = catSelect?.value;
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

  if (isIphone) {
    fillModels(v);
    modelSelect.value = '';
    renderIphoneTable(v, '');
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

renderIpad();

const altriEl = document.getElementById('altri-body');
if (altriEl) {
  altriEl.innerHTML = `<p>${escapeHtml(altriDispositivi.body)}</p>`;
}

onCategoryChange();
