import './styles/base.css';
import './styles/layout.css';
import './styles/components.css';
import './styles/bokeh.css';
import './styles/reviews.css';

import { mountChrome, setYear, siteInfo } from './chrome.js';

mountChrome('home');
setYear();
mountReviews();

function escapeHtml(s) {
  return String(s)
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;');
}

function starsHtml(rating) {
  const n = Math.round(Math.min(5, Math.max(0, Number(rating) || 0)));
  return `<span class="reviews-stars" title="${n} su 5" aria-hidden="true">${'★'.repeat(n)}</span>`;
}

async function mountReviews() {
  const mount = document.getElementById('reviews-mount');
  const introEl = document.getElementById('reviews-intro');
  const foot = document.getElementById('reviews-foot');
  if (!mount) return;

  try {
    const res = await fetch(`${import.meta.env.BASE_URL}data/recensioni.json`, { cache: 'no-store' });
    if (!res.ok) return;
    const data = await res.json();
    const reviews = Array.isArray(data.reviews) ? data.reviews : [];

    if (introEl && typeof data.intro === 'string' && data.intro.trim()) {
      introEl.textContent = data.intro.trim();
    }

    if (reviews.length === 0) {
      mount.innerHTML = '';
      return;
    }

    mount.innerHTML = reviews
      .map(
        (r) => `
      <article class="review-card">
        <header class="review-card__head">
          ${starsHtml(r.rating)}
          <span class="review-card__author">${escapeHtml(r.author ?? '')}</span>
          ${r.time ? `<span class="review-card__time">${escapeHtml(r.time)}</span>` : ''}
        </header>
        <blockquote class="review-card__text">
          <p>${escapeHtml(r.text ?? '')}</p>
        </blockquote>
      </article>`,
      )
      .join('');

    if (foot) {
      const mapsUrl = siteInfo.mapsHref;
      foot.hidden = false;
      foot.innerHTML = `<a href="${escapeHtml(mapsUrl)}" rel="noopener noreferrer" target="_blank">Vedi tutte le recensioni su Google Maps</a><span class="reviews-foot__note"> · Le recensioni sono pubblicate dagli utenti su Google; i testi qui sono aggiornati manualmente dalla scheda del negozio.</span>`;
    }
  } catch {
    /* listino offline o JSON assente: resta il testo statico dell’intro */
  }
}
