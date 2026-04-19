/**
 * Tema sito: light (Material-ish) o dark (Stitch · Modern Phone Repair Website).
 * Default: dark per allineamento al progetto MCP Stitch.
 */
(function (global) {
  const STORAGE_KEY = "ds-theme";
  const THEME_LIGHT = "light";
  const THEME_DARK = "dark";
  const VALID = new Set([THEME_LIGHT, THEME_DARK]);
  const DEFAULT_THEME = THEME_DARK;

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
      /* private mode */
    }
  }

  /**
   * @param {"light" | "dark"} theme
   * @param {{ persist?: boolean }} [options]
   */
  function applyTheme(theme, options = {}) {
    const persist = options.persist !== false;
    const root = global.document?.documentElement;
    if (!root) return DEFAULT_THEME;

    const next = VALID.has(theme) ? theme : DEFAULT_THEME;
    root.dataset.theme = next;
    if (persist) setStored(next);
    return next;
  }

  function applyLight(options) {
    return applyTheme(THEME_LIGHT, options);
  }

  function applyDark(options) {
    return applyTheme(THEME_DARK, options);
  }

  function getTheme() {
    const t = global.document?.documentElement?.dataset?.theme;
    return VALID.has(t) ? t : DEFAULT_THEME;
  }

  /**
   * @param {{ persist?: boolean; defaultTheme?: "light" | "dark" }} [options]
   */
  function init(options = {}) {
    const fallback = options.defaultTheme || DEFAULT_THEME;
    const stored = getStored();
    if (stored === THEME_LIGHT || stored === THEME_DARK) {
      applyTheme(stored, { persist: false });
      return;
    }
    applyTheme(fallback, options);
  }

  /** Commuta light ↔ dark e persiste. */
  function toggle() {
    const next = getTheme() === THEME_DARK ? THEME_LIGHT : THEME_DARK;
    return applyTheme(next);
  }

  const DSTheme = {
    STORAGE_KEY,
    THEME_LIGHT,
    THEME_DARK,
    init,
    applyTheme,
    applyLight,
    applyDark,
    getTheme,
    toggle,
  };

  global.DSTheme = DSTheme;
})(typeof window !== "undefined" ? window : globalThis);
