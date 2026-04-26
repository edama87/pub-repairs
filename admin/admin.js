const loginPanel = document.getElementById('loginPanel');
const appPanel = document.getElementById('appPanel');
const loginForm = document.getElementById('loginForm');
const loginError = document.getElementById('loginError');
const logoutBtn = document.getElementById('logoutBtn');

const editDialog = /** @type {HTMLDialogElement} */ (document.getElementById('editDialog'));
const editForm = document.getElementById('editForm');
const dialogTitle = document.getElementById('dialogTitle');
const dialogBody = document.getElementById('dialogBody');
const dialogError = document.getElementById('dialogError');

const devicesTbody = document.getElementById('devicesTbody');
const repairsTbody = document.getElementById('repairsTbody');
const pricesTbody = document.getElementById('pricesTbody');

const deviceCategoryFilter = document.getElementById('deviceCategoryFilter');
const repairScopeFilter = document.getElementById('repairScopeFilter');

const addDeviceBtn = document.getElementById('addDeviceBtn');
const addRepairBtn = document.getElementById('addRepairBtn');
const addPriceBtn = document.getElementById('addPriceBtn');

const refreshDevicesBtn = document.getElementById('refreshDevicesBtn');
const refreshRepairsBtn = document.getElementById('refreshRepairsBtn');
const refreshPricesBtn = document.getElementById('refreshPricesBtn');

/** @type {{csrfToken: string|null}} */
const session = { csrfToken: null };

function apiUrl(path) {
  const base = `${location.origin}${location.pathname.replace(/\/admin\/.*$/, '/')}`;
  return `${base}api/${path}`.replace(/\/+/g, '/').replace(':/', '://');
}

async function apiFetch(path, options = {}) {
  const headers = { ...(options.headers || {}) };
  if (options.body && !headers['Content-Type']) headers['Content-Type'] = 'application/json';
  if (session.csrfToken) headers['X-CSRF-Token'] = session.csrfToken;
  const res = await fetch(apiUrl(path), { ...options, headers, credentials: 'include' });
  const json = await res.json().catch(() => null);
  if (!res.ok || !json || json.ok !== true) {
    const msg = json?.error?.message || `Errore (${res.status})`;
    throw new Error(msg);
  }
  return json.data;
}

function setLoggedIn(isIn) {
  if (loginPanel) loginPanel.hidden = isIn;
  if (appPanel) appPanel.hidden = !isIn;
  if (logoutBtn) logoutBtn.hidden = !isIn;
}

function escapeHtml(s) {
  return String(s ?? '')
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;');
}

function pill(active) {
  return active
    ? '<span class="pill pill--ok">attivo</span>'
    : '<span class="pill pill--no">off</span>';
}

function mountTabs() {
  const tabs = Array.from(document.querySelectorAll('[data-tab]'));
  const panels = {
    devices: document.getElementById('panel-devices'),
    repairs: document.getElementById('panel-repairs'),
    prices: document.getElementById('panel-prices'),
  };
  function select(name) {
    for (const t of tabs) t.setAttribute('aria-selected', t.getAttribute('data-tab') === name ? 'true' : 'false');
    Object.entries(panels).forEach(([k, el]) => {
      if (!el) return;
      el.hidden = k !== name;
    });
  }
  tabs.forEach((t) =>
    t.addEventListener('click', () => {
      const name = t.getAttribute('data-tab');
      if (name) select(name);
    }),
  );
}

async function ensureSession() {
  const data = await apiFetch('auth/me.php', { method: 'GET' });
  if (data?.user) {
    session.csrfToken = data.csrfToken;
    setLoggedIn(true);
    return true;
  }
  setLoggedIn(false);
  return false;
}

async function doLogin(username, password) {
  const data = await apiFetch('auth/login.php', {
    method: 'POST',
    body: JSON.stringify({ username, password }),
  });
  session.csrfToken = data.csrfToken;
  setLoggedIn(true);
}

async function doLogout() {
  await apiFetch('auth/logout.php', { method: 'POST', body: JSON.stringify({}) });
  session.csrfToken = null;
  setLoggedIn(false);
}

function openDialog(title, bodyHtml, onSubmit) {
  if (!dialogTitle || !dialogBody || !dialogError || !editDialog) return;
  dialogTitle.textContent = title;
  dialogBody.innerHTML = bodyHtml;
  dialogError.textContent = '';
  editDialog.showModal();

  const handler = async (e) => {
    e.preventDefault();
    const fd = new FormData(editForm);
    try {
      await onSubmit(fd);
      editDialog.close();
    } catch (err) {
      dialogError.textContent = err?.message || 'Errore.';
    }
  };
  editForm.addEventListener('submit', handler, { once: true });
}

async function loadDevices() {
  if (!devicesTbody) return;
  const cat = deviceCategoryFilter?.value || '';
  const qs = new URLSearchParams();
  if (cat) qs.set('category', cat);
  const data = await apiFetch(`admin/devices.php?${qs.toString()}`, { method: 'GET' });
  const items = data.items || [];
  devicesTbody.innerHTML = items
    .map(
      (d) => `<tr>
        <td>${d.id}</td>
        <td>${escapeHtml(d.category)}</td>
        <td>${escapeHtml(d.label)}</td>
        <td>${escapeHtml(d.short_label ?? '')}</td>
        <td>${escapeHtml(d.sort_order)}</td>
        <td>${pill(!!d.is_active)}</td>
        <td>
          <button class="btn btn--ghost" data-action="editDevice" data-id="${d.id}">Modifica</button>
          <button class="btn btn--ghost" data-action="delDevice" data-id="${d.id}">Elimina</button>
        </td>
      </tr>`,
    )
    .join('');
}

async function loadRepairs() {
  if (!repairsTbody) return;
  const scope = repairScopeFilter?.value || '';
  const qs = new URLSearchParams();
  if (scope) qs.set('scope', scope);
  const data = await apiFetch(`admin/repairs.php?${qs.toString()}`, { method: 'GET' });
  const items = data.items || [];
  repairsTbody.innerHTML = items
    .map(
      (r) => `<tr>
        <td>${r.id}</td>
        <td>${escapeHtml(r.scope)}</td>
        <td><code>${escapeHtml(r.key)}</code></td>
        <td>${escapeHtml(r.label)}</td>
        <td>${escapeHtml(r.sort_order)}</td>
        <td>${pill(!!r.is_active)}</td>
        <td>
          <button class="btn btn--ghost" data-action="editRepair" data-id="${r.id}">Modifica</button>
          <button class="btn btn--ghost" data-action="delRepair" data-id="${r.id}">Elimina</button>
        </td>
      </tr>`,
    )
    .join('');
}

async function loadPrices() {
  if (!pricesTbody) return;
  const data = await apiFetch('admin/prices.php', { method: 'GET' });
  const items = data.items || [];
  pricesTbody.innerHTML = items
    .map(
      (p) => `<tr>
        <td>${p.id}</td>
        <td>${escapeHtml(p.device_label)} <span class="pill">${escapeHtml(p.device_category)}</span></td>
        <td>${escapeHtml(p.repair_label)} <span class="pill">${escapeHtml(p.repair_scope)}</span></td>
        <td>${p.price_eur === null ? '—' : `${escapeHtml(p.price_eur)} €`}</td>
        <td>${escapeHtml(p.notes ?? '')}</td>
        <td>${pill(!!p.is_active)}</td>
        <td>
          <button class="btn btn--ghost" data-action="editPrice" data-id="${p.id}">Modifica</button>
          <button class="btn btn--ghost" data-action="delPrice" data-id="${p.id}">Elimina</button>
        </td>
      </tr>`,
    )
    .join('');
}

function bindTableActions() {
  document.addEventListener('click', async (e) => {
    const btn = e.target?.closest?.('button[data-action]');
    if (!btn) return;
    const action = btn.getAttribute('data-action');
    const id = Number(btn.getAttribute('data-id') || 0);
    try {
      if (action === 'delDevice') {
        if (!confirm('Eliminare dispositivo?')) return;
        await apiFetch(`admin/devices.php?id=${id}`, { method: 'DELETE', body: JSON.stringify({}) });
        await loadDevices();
      }
      if (action === 'delRepair') {
        if (!confirm('Eliminare riparazione?')) return;
        await apiFetch(`admin/repairs.php?id=${id}`, { method: 'DELETE', body: JSON.stringify({}) });
        await loadRepairs();
      }
      if (action === 'delPrice') {
        if (!confirm('Eliminare prezzo?')) return;
        await apiFetch(`admin/prices.php?id=${id}`, { method: 'DELETE', body: JSON.stringify({}) });
        await loadPrices();
      }

      if (action === 'editDevice') {
        openDialog(
          `Modifica dispositivo #${id}`,
          `<div class="grid2">
            <label class="field"><span>Label</span><input name="label" required /></label>
            <label class="field"><span>Short label</span><input name="short_label" /></label>
            <label class="field"><span>Ordine</span><input name="sort_order" type="number" value="0" /></label>
            <label class="field"><span>Attivo (1/0)</span><input name="is_active" type="number" min="0" max="1" value="1" /></label>
          </div>`,
          async (fd) => {
            await apiFetch('admin/devices.php', {
              method: 'PUT',
              body: JSON.stringify({
                id,
                label: fd.get('label'),
                short_label: fd.get('short_label'),
                sort_order: Number(fd.get('sort_order') || 0),
                is_active: Number(fd.get('is_active') || 0) === 1,
              }),
            });
            await loadDevices();
          },
        );
      }

      if (action === 'editRepair') {
        openDialog(
          `Modifica riparazione #${id}`,
          `<div class="grid2">
            <label class="field"><span>Scope</span>
              <select name="scope">
                <option value="iphone">iphone</option>
                <option value="ipad">ipad</option>
                <option value="other">other</option>
              </select>
            </label>
            <label class="field"><span>Key</span><input name="key" required /></label>
            <label class="field"><span>Label</span><input name="label" required /></label>
            <label class="field"><span>Ordine</span><input name="sort_order" type="number" value="0" /></label>
            <label class="field"><span>Attivo (1/0)</span><input name="is_active" type="number" min="0" max="1" value="1" /></label>
          </div>`,
          async (fd) => {
            await apiFetch('admin/repairs.php', {
              method: 'PUT',
              body: JSON.stringify({
                id,
                scope: fd.get('scope'),
                key: fd.get('key'),
                label: fd.get('label'),
                sort_order: Number(fd.get('sort_order') || 0),
                is_active: Number(fd.get('is_active') || 0) === 1,
              }),
            });
            await loadRepairs();
          },
        );
      }

      if (action === 'editPrice') {
        openDialog(
          `Modifica prezzo #${id}`,
          `<div class="grid2">
            <label class="field"><span>Prezzo (EUR)</span><input name="price_eur" type="number" /></label>
            <label class="field"><span>Attivo (1/0)</span><input name="is_active" type="number" min="0" max="1" value="1" /></label>
            <label class="field" style="grid-column:1/-1"><span>Note</span><input name="notes" /></label>
          </div>`,
          async (fd) => {
            await apiFetch('admin/prices.php', {
              method: 'PUT',
              body: JSON.stringify({
                id,
                price_eur: fd.get('price_eur') === '' ? null : Number(fd.get('price_eur')),
                notes: fd.get('notes'),
                is_active: Number(fd.get('is_active') || 0) === 1,
              }),
            });
            await loadPrices();
          },
        );
      }
    } catch (err) {
      alert(err?.message || 'Errore.');
    }
  });
}

function bindButtons() {
  loginForm?.addEventListener('submit', async (e) => {
    e.preventDefault();
    if (loginError) loginError.textContent = '';
    const fd = new FormData(loginForm);
    try {
      await doLogin(String(fd.get('username') || ''), String(fd.get('password') || ''));
      await loadDevices();
      await loadRepairs();
      await loadPrices();
    } catch (err) {
      if (loginError) loginError.textContent = err?.message || 'Errore login.';
    }
  });

  logoutBtn?.addEventListener('click', async () => {
    try {
      await doLogout();
    } catch {
      // ignore
    }
  });

  refreshDevicesBtn?.addEventListener('click', () => loadDevices().catch((e) => alert(e.message)));
  refreshRepairsBtn?.addEventListener('click', () => loadRepairs().catch((e) => alert(e.message)));
  refreshPricesBtn?.addEventListener('click', () => loadPrices().catch((e) => alert(e.message)));
  deviceCategoryFilter?.addEventListener('change', () => loadDevices().catch((e) => alert(e.message)));
  repairScopeFilter?.addEventListener('change', () => loadRepairs().catch((e) => alert(e.message)));

  addDeviceBtn?.addEventListener('click', () => {
    openDialog(
      'Aggiungi dispositivo',
      `<div class="grid2">
        <label class="field"><span>Categoria</span>
          <select name="category">
            <option value="iphone-recent">iphone-recent</option>
            <option value="iphone-legacy">iphone-legacy</option>
            <option value="ipad">ipad</option>
            <option value="other">other</option>
          </select>
        </label>
        <label class="field"><span>Label</span><input name="label" required /></label>
        <label class="field"><span>Short label</span><input name="short_label" /></label>
        <label class="field"><span>Ordine</span><input name="sort_order" type="number" value="0" /></label>
        <label class="field"><span>Attivo (1/0)</span><input name="is_active" type="number" min="0" max="1" value="1" /></label>
      </div>`,
      async (fd) => {
        await apiFetch('admin/devices.php', {
          method: 'POST',
          body: JSON.stringify({
            category: fd.get('category'),
            label: fd.get('label'),
            short_label: fd.get('short_label'),
            sort_order: Number(fd.get('sort_order') || 0),
            is_active: Number(fd.get('is_active') || 0) === 1,
          }),
        });
        await loadDevices();
      },
    );
  });

  addRepairBtn?.addEventListener('click', () => {
    openDialog(
      'Aggiungi riparazione',
      `<div class="grid2">
        <label class="field"><span>Scope</span>
          <select name="scope">
            <option value="iphone">iphone</option>
            <option value="ipad">ipad</option>
            <option value="other">other</option>
          </select>
        </label>
        <label class="field"><span>Key</span><input name="key" placeholder="lcd" required /></label>
        <label class="field"><span>Label</span><input name="label" placeholder="LCD + vetro" required /></label>
        <label class="field"><span>Ordine</span><input name="sort_order" type="number" value="0" /></label>
        <label class="field"><span>Attivo (1/0)</span><input name="is_active" type="number" min="0" max="1" value="1" /></label>
      </div>`,
      async (fd) => {
        await apiFetch('admin/repairs.php', {
          method: 'POST',
          body: JSON.stringify({
            scope: fd.get('scope'),
            key: fd.get('key'),
            label: fd.get('label'),
            sort_order: Number(fd.get('sort_order') || 0),
            is_active: Number(fd.get('is_active') || 0) === 1,
          }),
        });
        await loadRepairs();
      },
    );
  });

  addPriceBtn?.addEventListener('click', async () => {
    // Per semplicità: chiediamo ID device e ID repair type (copiabili dalle tabelle).
    openDialog(
      'Aggiungi / aggiorna prezzo',
      `<div class="grid2">
        <label class="field"><span>Device ID</span><input name="device_id" type="number" required /></label>
        <label class="field"><span>Repair ID</span><input name="repair_type_id" type="number" required /></label>
        <label class="field"><span>Prezzo (EUR)</span><input name="price_eur" type="number" /></label>
        <label class="field"><span>Attivo (1/0)</span><input name="is_active" type="number" min="0" max="1" value="1" /></label>
        <label class="field" style="grid-column:1/-1"><span>Note</span><input name="notes" /></label>
      </div>`,
      async (fd) => {
        await apiFetch('admin/prices.php', {
          method: 'POST',
          body: JSON.stringify({
            device_id: Number(fd.get('device_id')),
            repair_type_id: Number(fd.get('repair_type_id')),
            price_eur: fd.get('price_eur') === '' ? null : Number(fd.get('price_eur')),
            notes: fd.get('notes'),
            is_active: Number(fd.get('is_active') || 0) === 1,
          }),
        });
        await loadPrices();
      },
    );
  });
}

async function boot() {
  mountTabs();
  bindButtons();
  bindTableActions();

  const ok = await ensureSession();
  if (ok) {
    await loadDevices();
    await loadRepairs();
    await loadPrices();
  }
}

boot().catch((e) => {
  setLoggedIn(false);
  if (loginError) loginError.textContent = e?.message || 'Errore.';
});

