import { pageHref } from './paths.js';

/** Dati comuni — aggiorna qui orari e testi se cambiano in negozio. */
const siteInfo = {
  addressLine: 'Via Piazzano, 66 — 66041 Atessa (CH), Abruzzo',
  mobile: '+39 333 290 9839',
  mobileHref: 'tel:+393332909839',
  whatsappHref: 'https://wa.me/393332909839',
  mapsHref: 'https://www.google.com/maps?q=Via+Piazzano,+66+Atessa+CH',
  hoursIntro: 'Orari di apertura al pubblico (indicativi — confermare per festività).',
  hours: [
    { label: 'Lunedì – venerdì', value: '9:00 – 19:00' },
    { label: 'Sabato', value: '9:00 – 13:00' },
    { label: 'Domenica e festivi', value: 'Chiuso' },
  ],
};

function applyFavicon() {
  const link = document.querySelector('link[rel="icon"]');
  if (link) link.href = `${import.meta.env.BASE_URL}favicon.svg`;
}

const ICONS = {
  home: '<svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M3 10.5L12 3l9 7.5V21a1 1 0 0 1-1 1h-5v-7H9v7H4a1 1 0 0 1-1-1v-10.5z"/></svg>',
  search:
    '<svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"><circle cx="11" cy="11" r="7"/><path d="M21 21l-4.3-4.3"/></svg>',
  shop: '<svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M6 6h15l-1.5 9h-12z"/><path d="M6 6 5 3H2"/><circle cx="9" cy="20" r="1"/><circle cx="18" cy="20" r="1"/></svg>',
  user:
    '<svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"><circle cx="12" cy="8" r="3.5"/><path d="M5.5 20.5v-1a6.5 6.5 0 0 1 13 0v1"/></svg>',
};

function footerHtml() {
  const hoursRows = siteInfo.hours.map((h) => `<dt>${h.label}</dt><dd>${h.value}</dd>`).join('');
  return `
    <div class="section__inner site-footer__main">
      <div class="site-footer__grid">
        <div class="site-footer__block">
          <p class="site-footer__kicker">Contatti</p>
          <p class="site-footer__brand">OfficinaePhone</p>
          <p class="site-footer__addr">${siteInfo.addressLine}</p>
          <ul class="site-footer__contacts">
            <li><a href="${siteInfo.mobileHref}">Mobile ${siteInfo.mobile}</a></li>
            <li><a href="${siteInfo.whatsappHref}" rel="noopener noreferrer" target="_blank">WhatsApp</a></li>
            <li><a href="${pageHref('contatti.html')}">Pagina contatti e mappa</a></li>
            <li><a href="${siteInfo.mapsHref}" rel="noopener noreferrer" target="_blank">Google Maps</a></li>
          </ul>
        </div>
        <div class="site-footer__block">
          <p class="site-footer__kicker">Orari</p>
          <p class="site-footer__hours-intro">${siteInfo.hoursIntro}</p>
          <dl class="site-footer__hours">${hoursRows}</dl>
        </div>
      </div>
      <div class="site-footer__legal">
        <p>© <span id="year"></span> OfficinaePhone. Tutti i diritti riservati.</p>
      </div>
    </div>`;
}

/**
 * @param {'home' | 'servizi' | 'usati' | 'contatti'} active
 */
export function mountChrome(active) {
  applyFavicon();
  const header = document.getElementById('site-header');
  const bottom = document.getElementById('bottom-nav');
  const footer = document.getElementById('site-footer');
  if (!header || !bottom) return;

  const navLink = (id, label, href, iconKey) => {
    const isActive = active === id;
    return `<a href="${href}" class="bottom-nav__item${isActive ? ' bottom-nav__item--active' : ''}" data-section="${id}"${isActive ? ' aria-current="page"' : ''}>
      <span class="bottom-nav__icon" aria-hidden="true">${ICONS[iconKey]}</span>
      <span class="bottom-nav__label">${label}</span>
    </a>`;
  };

  header.innerHTML = `
    <div class="site-header__inner">
      <a class="site-logo" href="${pageHref('index.html')}">Officinae<span>Phone</span></a>
      <nav class="site-header__nav" aria-label="Navigazione principale">
        <a href="${pageHref('index.html')}"${active === 'home' ? ' aria-current="page"' : ''}>Home</a>
        <a href="${pageHref('servizi.html')}"${active === 'servizi' ? ' aria-current="page"' : ''}>Servizi</a>
        <a href="${pageHref('usati.html')}"${active === 'usati' ? ' aria-current="page"' : ''}>Usati</a>
        <a href="${pageHref('contatti.html')}"${active === 'contatti' ? ' aria-current="page"' : ''}>Contatti</a>
      </nav>
    </div>`;

  bottom.innerHTML = `
    <div class="bottom-nav__row">
      <div class="bottom-nav__pill">
        ${navLink('home', 'Home', pageHref('index.html'), 'home')}
        ${navLink('servizi', 'Servizi', pageHref('servizi.html'), 'search')}
        ${navLink('usati', 'Usati', pageHref('usati.html'), 'shop')}
        ${navLink('contatti', 'Contatti', pageHref('contatti.html'), 'user')}
      </div>
      <a class="bottom-nav__whatsapp" href="https://wa.me/393332909839" rel="noopener noreferrer" target="_blank" aria-label="Contattaci su WhatsApp">
        <svg viewBox="0 0 24 24" width="26" height="26" aria-hidden="true">
          <path fill="currentColor" d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 01-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 01-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 012.893 6.994c-.003 5.45-4.435 9.884-9.881 9.884m8.413-18.297A11.815 11.815 0 0012.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 005.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 00-3.48-8.413z"/>
        </svg>
      </a>
    </div>`;

  if (footer) footer.innerHTML = footerHtml();
}

export function setYear() {
  const el = document.getElementById('year');
  if (el) el.textContent = String(new Date().getFullYear());
}

