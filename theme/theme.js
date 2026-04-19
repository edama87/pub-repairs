/**
 * Inizializzazione tema — modalità light.
 * Imposta `data-theme="light"` su <html> e opzionalmente persiste in localStorage.
 * @see docs/DESIGN_THEME_LIGHT.md
 */
(function (global) {
  const STORAGE_KEY = "ds-theme";
  const THEME_LIGHT = "light";

  function getStored() {
    try {
      return global.localStorage?.getItem(STORAGE_KEY);
    } catch {
      return null;
    }
  }

  function setStored(value) {
    try {
      global.localStorage?.setItem(STORAGE_KEY, value);
    } catch {
      /* private mode / denied */
    }
  }

  /**
   * Applica il tema light al documento.
   * @param {{ persist?: boolean }} [options] persist default true
   */
  function applyLight(options = {}) {
    const persist = options.persist !== false;
    const root = global.document?.documentElement;
    if (!root) return THEME_LIGHT;

    root.dataset.theme = THEME_LIGHT;
    if (persist) setStored(THEME_LIGHT);
    return THEME_LIGHT;
  }

  /**
   * Legge il tema corrente (sempre "light" in questa base).
   * @returns {"light"}
   */
  function getTheme() {
    const t = global.document?.documentElement?.dataset?.theme;
    return t === THEME_LIGHT ? THEME_LIGHT : THEME_LIGHT;
  }

  /**
   * @param {{ persist?: boolean }} [options]
   */
  function init(options = {}) {
    const stored = getStored();
    if (stored === THEME_LIGHT) {
      applyLight({ persist: false });
      return;
    }
    applyLight(options);
  }

  const DSTheme = {
    STORAGE_KEY,
    THEME_LIGHT,
    init,
    applyLight,
    getTheme,
  };

  global.DSTheme = DSTheme;
})(typeof window !== "undefined" ? window : globalThis);
