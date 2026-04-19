const SECTION_IDS = ['home', 'servizi', 'usati', 'contatti'];

/**
 * @param {string} id
 */
function setActiveNav(id) {
  const items = document.querySelectorAll('.bottom-nav__item[data-section]');
  items.forEach((el) => {
    const match = el.getAttribute('data-section') === id;
    el.classList.toggle('bottom-nav__item--active', match);
    if (match) el.setAttribute('aria-current', 'page');
    else el.removeAttribute('aria-current');
  });
}

/**
 * @param {string} hash
 */
function idFromHash(hash) {
  const raw = (hash || '').replace('#', '');
  return SECTION_IDS.includes(raw) ? raw : 'home';
}

export function initNavigation() {
  const bottomLinks = document.querySelectorAll('.bottom-nav__item[href^="#"]');
  const headerLinks = document.querySelectorAll('.site-header__nav a[href^="#"]');

  const scrollToId = (id, { instant = false } = {}) => {
    const el = document.getElementById(id);
    if (!el) return;
    el.scrollIntoView({ behavior: instant ? 'instant' : 'smooth', block: 'start' });
  };

  const onNavClick = (e) => {
    const a = e.currentTarget;
    if (!(a instanceof HTMLAnchorElement)) return;
    const href = a.getAttribute('href');
    if (!href || !href.startsWith('#')) return;
    const id = href.slice(1);
    if (!SECTION_IDS.includes(id)) return;
    e.preventDefault();
    history.replaceState(null, '', `#${id}`);
    setActiveNav(id);
    scrollToId(id);
  };

  bottomLinks.forEach((a) => a.addEventListener('click', onNavClick));
  headerLinks.forEach((a) => a.addEventListener('click', onNavClick));

  const syncFromHash = () => {
    const id = idFromHash(window.location.hash);
    setActiveNav(id);
  };

  window.addEventListener('hashchange', syncFromHash);

  const io = new IntersectionObserver(
    (entries) => {
      const visible = entries
        .filter((e) => e.isIntersecting)
        .sort((a, b) => b.intersectionRatio - a.intersectionRatio)[0];
      if (!visible?.target?.id) return;
      const id = visible.target.id;
      if (!SECTION_IDS.includes(id)) return;
      setActiveNav(id);
    },
    { root: null, rootMargin: '-38% 0px -42% 0px', threshold: [0, 0.15, 0.35, 0.55, 0.85] },
  );

  SECTION_IDS.forEach((id) => {
    const el = document.getElementById(id);
    if (el) io.observe(el);
  });

  syncFromHash();
  if (!window.location.hash) {
    setActiveNav('home');
  } else {
    const id = idFromHash(window.location.hash);
    requestAnimationFrame(() => scrollToId(id, { instant: true }));
  }
}
