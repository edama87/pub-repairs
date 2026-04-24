import './styles/base.css';
import './styles/layout.css';
import './styles/components.css';
import './styles/bokeh.css';
import './styles/servizi.css';

import { mountChrome, setYear } from './chrome.js';

mountChrome('servizi');
setYear();

const tbody = document.getElementById('price-tbody');
const listinoNote = document.getElementById('listino-note');
const ipadRoot = document.getElementById('ipad-blocks');
const searchForm = document.getElementById('listino-search-form');
const searchInput = document.getElementById('listino-search-input');
const searchStatus = document.getElementById('listino-search-status');
const deviceListEl = document.getElementById('device-list');
const listinoDialog = /** @type {HTMLDialogElement | null} */ (document.getElementById('listino-dialog'));
const listinoDialogTitle = document.getElementById('listino-modal-title');
const listinoDialogImg = /** @type {HTMLImageElement | null} */ (document.getElementById('listino-modal-img'));
const iphoneSection = document.getElementById('listino-modal-iphone');
const ipadSection = document.getElementById('listino-modal-ipad');
const altriSection = document.getElementById('listino-modal-altri');
const dialogCloseBtn = listinoDialog?.querySelector?.('.listino-modal__close');

/** @type {Record<string, { models: string[], repairs: { label: string, prices: (number|null)[] }[] } | undefined>} */
let matrices = {};

/** Dati iPad completi (per filtri ricerca). */
let ipadListinoFull = null;

/** @typedef {{ id: string, label: string, kind: 'iphone'|'ipad'|'altri', catId?: 'iphone-recent'|'iphone-legacy', modelIndex?: number }} DeviceItem */
/** @type {DeviceItem[]} */
let devices = [];

/** @type {string|null} */
let selectedDeviceId = null;

function setSearchStatus(text) {
  if (searchStatus) searchStatus.textContent = text ?? '';
}

function normalizeQuery(q) {
  return String(q ?? '')
    .trim()
    .toLowerCase();
}

function imageUrlForDevice(d) {
  const base = import.meta.env.BASE_URL;
  if (d.kind === 'ipad') return `${base}images/devices/models/iPad.png`;
  if (d.kind === 'altri') return `${base}images/devices/models/samsung.png`;
  if (d.kind !== 'iphone') return `${base}images/devices/device.svg`;

  const label = String(d.label);
  const m = label.match(/^iPhone\s+(\d+)(?:\s+(Pro Max|Pro|Plus|mini))?/i);
  if (m) {
    const num = m[1];
    const variant = (m[2] || '').toLowerCase();
    const variantSlug =
      variant === 'pro max'
        ? 'pro-max'
        : variant === 'pro'
          ? 'pro'
          : variant === 'plus'
            ? 'plus'
            : variant === 'mini'
              ? 'mini'
              : '';
    if (num === '12' && label.includes('/')) {
      return `${base}images/devices/models/iphone-12.png`;
    }
    return `${base}images/devices/models/iphone-${num}${variantSlug ? `-${variantSlug}` : ''}.png`;
  }

  if (/^iPhone\s+SE\b/i.test(label)) {
    if (/\b2022\b/.test(label)) return `${base}images/devices/models/iphone-se-2022.png`;
    return `${base}images/devices/models/iphone-se-2020.jpg`;
  }

  if (/^iPhone\s+11\b/i.test(label)) return `${base}images/devices/models/iphone-11-1.jpg`;
  if (/^iPhone\s+XS Max\b/i.test(label)) return `${base}images/devices/models/iphone-xs-max.jpg`;
  if (/^iPhone\s+XS\b/i.test(label)) return `${base}images/devices/models/iphone-xs.jpg`;
  if (/^iPhone\s+XR\b/i.test(label)) return `${base}images/devices/models/iphone-xr.jpg`;
  if (/^iPhone\s+X\b/i.test(label)) return `${base}images/devices/models/iphone-x.jpg`;
  if (/^iPhone\s+8 Plus\b/i.test(label)) return `${base}images/devices/models/iphone-8-plus.jpg`;
  if (/^iPhone\s+8\b/i.test(label)) return `${base}images/devices/models/iphone-8.jpg`;
  if (/^iPhone\s+7 Plus\b/i.test(label)) return `${base}images/devices/models/iphone-7-plus.jpg`;
  if (/^iPhone\s+7\b/i.test(label)) return `${base}images/devices/models/iphone-7.jpg`;
  if (/^iPhone\s+6s Plus\b/i.test(label)) return `${base}images/devices/models/iphone-6s-plus.jpg`;
  if (/^iPhone\s+6 Plus\b/i.test(label)) return `${base}images/devices/models/iphone-6-plus.jpg`;
  if (/^iPhone\s+5c\b/i.test(label)) return `${base}images/devices/models/iphone-5C_1.jpg`;
  if (/^iPhone\s+5\b/i.test(label)) return `${base}images/devices/models/iphone-5_2.jpg`;

  return `${base}images/devices/models/iPhone.png`;
}

function syncPanelsForDeviceKind(kind) {
  if (iphoneSection) iphoneSection.hidden = kind !== 'iphone';
  if (ipadSection) ipadSection.hidden = kind !== 'ipad';
  if (altriSection) altriSection.hidden = kind !== 'altri';
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
    tr.innerHTML = '<td colspan="2">Seleziona un dispositivo per vedere i prezzi.</td>';
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

function buildDevices() {
  /** @type {DeviceItem[]} */
  const out = [];

  const recent = matrices['iphone-recent'];
  const legacy = matrices['iphone-legacy'];
  if (recent) {
    recent.models.forEach((m, i) => {
      out.push({
        id: `iphone-recent:${i}`,
        label: m,
        kind: 'iphone',
        catId: 'iphone-recent',
        modelIndex: i,
      });
    });
  }
  if (legacy) {
    legacy.models.forEach((m, i) => {
      out.push({
        id: `iphone-legacy:${i}`,
        label: m,
        kind: 'iphone',
        catId: 'iphone-legacy',
        modelIndex: i,
      });
    });
  }

  out.push({ id: 'ipad', label: 'iPad', kind: 'ipad' });
  out.push({ id: 'altri', label: 'Altri dispositivi', kind: 'altri' });

  return out;
}

function setSelectedDeviceId(id) {
  selectedDeviceId = id;
  if (!deviceListEl) return;
  for (const li of deviceListEl.querySelectorAll('[data-device-id]')) {
    const isActive = li.getAttribute('data-device-id') === id;
    li.classList.toggle('device-list__item--active', isActive);
    if (isActive) li.setAttribute('aria-selected', 'true');
    else li.setAttribute('aria-selected', 'false');
  }
}

function selectDevice(item) {
  if (!item) return;
  setSelectedDeviceId(item.id);
  syncPanelsForDeviceKind(item.kind);

  if (listinoDialogTitle) listinoDialogTitle.textContent = item.label;
  if (listinoDialogImg) {
    const base = import.meta.env.BASE_URL;
    listinoDialogImg.src = imageUrlForDevice(item);
    listinoDialogImg.onerror = () => {
      listinoDialogImg.onerror = null;
      listinoDialogImg.src = `${base}images/devices/device.svg`;
    };
  }

  if (item.kind === 'iphone') {
    renderIphoneTable(item.catId, String(item.modelIndex));
    setSearchStatus('');
  } else if (item.kind === 'ipad') {
    if (ipadListinoFull) renderIpad(ipadListinoFull, '');
    setSearchStatus('');
  } else if (item.kind === 'altri') {
    setSearchStatus('');
  }

  if (listinoDialog && !listinoDialog.open) {
    listinoDialog.showModal();
  }
}

function renderDeviceList(filterQuery = '') {
  if (!deviceListEl) return;
  const needle = normalizeQuery(filterQuery);
  const filtered = needle
    ? devices.filter((d) => d.label.toLowerCase().includes(needle))
    : devices;

  const base = import.meta.env.BASE_URL;

  deviceListEl.innerHTML = filtered
    .map((d) => {
      const active = d.id === selectedDeviceId;
      return `<li class="device-list__item${active ? ' device-list__item--active' : ''}" role="option" aria-selected="${active ? 'true' : 'false'}" tabindex="0" data-device-id="${escapeHtml(d.id)}">
        <img class="device-list__img" src="${imageUrlForDevice(d)}" alt="" aria-hidden="true" loading="lazy" decoding="async" onerror="this.onerror=null;this.src='${base}images/devices/device.svg';" />
        <span class="device-list__label">${escapeHtml(d.label)}</span>
      </li>`;
    })
    .join('');

  const count = filtered.length;
  if (needle) {
    setSearchStatus(count === 0 ? 'Nessun dispositivo trovato.' : `${count} dispositivi trovati.`);
  } else {
    setSearchStatus('');
  }
}

function onDeviceListClick(e) {
  const target = e.target?.closest?.('[data-device-id]');
  const id = target?.getAttribute?.('data-device-id');
  if (!id) return;
  const item = devices.find((d) => d.id === id);
  selectDevice(item);
}

function onDeviceListKeydown(e) {
  const isEnter = e.key === 'Enter';
  const isSpace = e.key === ' ';
  if (!isEnter && !isSpace) return;
  const target = e.target?.closest?.('[data-device-id]');
  const id = target?.getAttribute?.('data-device-id');
  if (!id) return;
  e.preventDefault();
  const item = devices.find((d) => d.id === id);
  selectDevice(item);
}

function onSearchInput() {
  const raw = searchInput?.value ?? '';
  renderDeviceList(raw);
}

function onSearchSubmit(e) {
  e.preventDefault();
}

if (deviceListEl) {
  deviceListEl.addEventListener('click', onDeviceListClick);
  deviceListEl.addEventListener('keydown', onDeviceListKeydown);
}
if (searchInput) {
  searchInput.addEventListener('input', onSearchInput);
}
if (searchForm) {
  searchForm.addEventListener('submit', onSearchSubmit);
}

if (listinoDialog) {
  dialogCloseBtn?.addEventListener('click', () => listinoDialog.close());
  listinoDialog.addEventListener('click', (e) => {
    if (e.target === listinoDialog) listinoDialog.close();
  });
}

function setLoadingUi(loading) {
  if (searchInput) searchInput.disabled = loading;
  if (searchForm) {
    const btn = searchForm.querySelector('button[type="submit"]');
    if (btn) btn.disabled = loading;
  }
  if (tbody && loading) {
    tbody.innerHTML = '<tr><td colspan="2">Caricamento listino…</td></tr>';
  }
  if (deviceListEl) {
    deviceListEl.setAttribute('aria-busy', loading ? 'true' : 'false');
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

    devices = buildDevices();
    selectedDeviceId = null;
    renderDeviceList('');
    if (tbody) {
      tbody.innerHTML = '<tr><td colspan="2">Seleziona un dispositivo per vedere i prezzi.</td></tr>';
    }

    setLoadingUi(false);
  } catch {
    showListinoError(
      'Impossibile caricare il listino. Ricarica la pagina o contattaci in negozio per i prezzi aggiornati.',
    );
    setLoadingUi(false);
  }
}

loadListino();
