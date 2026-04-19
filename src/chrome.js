import { baseUrl, pageHref } from './paths.js';

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
  /** Link social (stesso schema del sito temporaneo tooltestai.it). */
  social: [
    { label: 'Facebook', href: 'https://www.facebook.com/officinaephone' },
    { label: 'Instagram', href: 'https://www.instagram.com/officinaephone' },
    { label: 'TikTok', href: 'https://www.tiktok.com/@officinaephone' },
  ],
};

function applyFavicon() {
  const link = document.querySelector('link[rel="icon"]');
  if (!link) return;
  link.href = `${baseUrl}cropped-favbicon-192x192.png`;
  link.type = 'image/png';
}

const ICONS = {
  home: '<svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M3 10.5L12 3l9 7.5V21a1 1 0 0 1-1 1h-5v-7H9v7H4a1 1 0 0 1-1-1v-10.5z"/></svg>',
  search:
    '<svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"><circle cx="11" cy="11" r="7"/><path d="M21 21l-4.3-4.3"/></svg>',
  shop: '<svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M6 6h15l-1.5 9h-12z"/><path d="M6 6 5 3H2"/><circle cx="9" cy="20" r="1"/><circle cx="18" cy="20" r="1"/></svg>',
  user:
    '<svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"><circle cx="12" cy="8" r="3.5"/><path d="M5.5 20.5v-1a6.5 6.5 0 0 1 13 0v1"/></svg>',
};

const SOCIAL_ICONS = {
  Facebook:
    '<svg viewBox="0 0 24 24" width="22" height="22" aria-hidden="true"><path fill="currentColor" d="M22 12c0-5.523-4.477-10-10-10S2 6.477 2 12c0 4.991 3.657 9.128 8.438 9.878v-6.988h-2.54V12h2.54V9.797c0-2.506 1.492-3.89 3.777-3.89 1.094 0 2.238.195 2.238.195v2.46h-1.26c-1.243 0-1.63.771-1.63 1.562V12h2.773l-.443 2.89h-2.33v6.988C18.343 21.128 22 16.991 22 12z"/></svg>',
  Instagram:
    '<svg viewBox="0 0 24 24" width="22" height="22" aria-hidden="true"><path fill="currentColor" d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069zM12 0C8.741 0 8.333.014 7.053.072 2.695.272.273 2.69.073 7.052.014 8.333 0 8.741 0 12c0 3.259.014 3.668.072 4.948.2 4.358 2.618 6.78 6.98 6.98C8.333 23.986 8.741 24 12 24c3.259 0 3.668-.014 4.948-.072 4.354-.2 6.782-2.618 6.979-6.98.059-1.28.073-1.689.073-4.948 0-3.259-.014-3.667-.072-4.947-.196-4.354-2.617-6.78-6.979-6.98C15.668.014 15.259 0 12 0zm0 5.838a6.162 6.162 0 100 12.324 6.162 6.162 0 000-12.324zM12 16a4 4 0 110-8 4 4 0 010 8zm6.406-11.845a1.44 1.44 0 100 2.881 1.44 1.44 0 000-2.881z"/></svg>',
  TikTok:
    '<svg viewBox="0 0 24 24" width="22" height="22" aria-hidden="true"><path fill="currentColor" d="M19.59 6.69a4.83 4.83 0 01-3.77-4.25V2h-3.45v13.67a2.89 2.89 0 01-5.2 1.74 2.89 2.89 0 012.31-4.64 2.93 2.93 0 01.88.13V9.4a6.84 6.84 0 00-1-.05A6.33 6.33 0 005 20.1a6.34 6.34 0 0010.86-4.43v-7a8.16 8.16 0 004.77 1.52v-3.4a4.85 4.85 0 01-1-.1z"/></svg>',
};

function footerHtml() {
  const hoursRows = siteInfo.hours.map((h) => `<dt>${h.label}</dt><dd>${h.value}</dd>`).join('');
  const socialItems = siteInfo.social
    .filter((s) => s.href)
    .map(
      (s) => `<li>
      <a class="site-footer__social-link" href="${s.href}" rel="noopener noreferrer" target="_blank" aria-label="${s.label}">
        <span class="site-footer__social-icon" aria-hidden="true">${SOCIAL_ICONS[s.label] ?? ''}</span>
      </a>
    </li>`,
    )
    .join('');
  const socialBlock =
    socialItems.length > 0
      ? `<p class="site-footer__kicker site-footer__kicker--after-block">Social</p>
          <ul class="site-footer__social" role="list">${socialItems}</ul>`
      : '';
  const logoFooterSrc = `${baseUrl}images/logo/logosusfondiscurixweb.png`;
  return `
    <div class="section__inner site-footer__main">
      <div class="site-footer__grid">
        <div class="site-footer__block">
          <p class="site-footer__kicker">Contatti</p>
          <a class="site-footer__logo-link" href="${pageHref('index.html')}" aria-label="OfficinaePhone — Home">
            <img class="site-footer__logo" src="${logoFooterSrc}" alt="OfficinaePhone" width="320" height="64" decoding="async" />
          </a>
          <p class="site-footer__addr">${siteInfo.addressLine}</p>
          <ul class="site-footer__contacts">
            <li><a href="${siteInfo.mobileHref}">Mobile ${siteInfo.mobile}</a></li>
            <li><a href="${siteInfo.whatsappHref}" rel="noopener noreferrer" target="_blank">WhatsApp</a></li>
            <li><a href="${pageHref('contatti.html')}">Pagina contatti e mappa</a></li>
            <li><a href="${siteInfo.mapsHref}" rel="noopener noreferrer" target="_blank">Google Maps</a></li>
          </ul>
          ${socialBlock}
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

  const logoSrc = `${baseUrl}images/logo/logo.png`;
  const navLink = (id, label, href, iconKey) => {
    const isActive = active === id;
    return `<a href="${href}" class="bottom-nav__item${isActive ? ' bottom-nav__item--active' : ''}" data-section="${id}"${isActive ? ' aria-current="page"' : ''}>
      <span class="bottom-nav__icon" aria-hidden="true">${ICONS[iconKey]}</span>
      <span class="bottom-nav__label">${label}</span>
    </a>`;
  };

  header.innerHTML = `
    <div class="site-header__inner">
      <a class="site-logo" href="${pageHref('index.html')}" aria-label="OfficinaePhone — Home">
        <img class="site-logo__img" src="${logoSrc}" alt="OfficinaePhone" width="320" height="64" decoding="async" />
      </a>
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

