import { devices } from '../data/services.js';

/**
 * @param {import('../data/services.js').RepairService} r
 */
function escapeHtml(s) {
  return String(s)
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;');
}

/**
 * @param {import('../data/services.js').RepairService} repair
 */
function renderCard(repair) {
  const badge = repair.badge
    ? `<span class="badge badge--${repair.badge.variant ?? 'muted'}">${escapeHtml(repair.badge.text)}</span>`
    : repair.urgency
      ? `<span class="service-card__urgency">${escapeHtml(repair.urgency)}</span>`
      : '';

  const bullets = repair.details.bullets.map((b) => `<li>${escapeHtml(b)}</li>`).join('');
  const eta = repair.details.eta
    ? `<p class="service-card__meta"><strong>Tempi indicativi:</strong> ${escapeHtml(repair.details.eta)}</p>`
    : '';

  return `
<article class="service-card" id="repair-${escapeHtml(repair.id)}">
  <header class="service-card__header">
    <div class="service-card__brand">
      <span class="service-card__dot" aria-hidden="true"></span>
      <h3 class="service-card__title">${escapeHtml(repair.title)}</h3>
    </div>
    ${badge}
  </header>
  <div class="service-card__body">
    <div class="service-card__col service-card__col--left">
      <p class="service-card__code">${escapeHtml(repair.leftCode)}</p>
      <p class="service-card__sub">${escapeHtml(repair.leftSub)}</p>
    </div>
    <div class="service-card__track" aria-hidden="true">
      <span class="service-card__dotted"></span>
    </div>
    <div class="service-card__col service-card__col--mid">
      <p class="service-card__code">${escapeHtml(repair.rightCode)}</p>
      <p class="service-card__sub">${escapeHtml(repair.rightSub)}</p>
    </div>
    <div class="service-card__price">
      <p class="service-card__amount">${escapeHtml(repair.price)}</p>
      <p class="service-card__note">${escapeHtml(repair.priceNote)}</p>
    </div>
  </div>
  <details class="service-card__details">
    <summary class="service-card__summary">
      <span>Dettagli</span>
      <svg class="service-card__chev" viewBox="0 0 24 24" width="18" height="18" aria-hidden="true"><path fill="none" stroke="currentColor" stroke-width="2" d="M6 9l6 6 6-6"/></svg>
    </summary>
    <div class="service-card__panel">
      ${eta}
      <ul class="service-card__list">${bullets}</ul>
      <div class="service-card__actions">
        <a class="btn btn--small btn--primary" href="https://wa.me/393332909839?text=${encodeURIComponent(`Ciao, chiedo info su: ${repair.title}`)}" rel="noopener noreferrer" target="_blank">WhatsApp</a>
        <a class="btn btn--small btn--ghost" href="tel:+393332909839">Chiama</a>
      </div>
    </div>
  </details>
</article>`;
}

/**
 * @param {import('../data/services.js').DeviceGroup} device
 */
function renderDeviceSection(device) {
  const cards = device.repairs.map(renderCard).join('');
  return `
<section class="device-block" aria-labelledby="device-${device.id}">
  <h3 class="device-block__title" id="device-${device.id}">${escapeHtml(device.name)}</h3>
  <p class="device-block__sub">${escapeHtml(device.subtitle)}</p>
  <div class="device-block__cards">${cards}</div>
</section>`;
}

export function mountServiceList(root) {
  if (!root) return;
  root.innerHTML = devices.map(renderDeviceSection).join('');
}
