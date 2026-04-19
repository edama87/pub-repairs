import { defineConfig } from 'vite';

/**
 * GitHub Pages (sito di progetto): URL https://edama87.github.io/pub-repairs/
 * In CI impostiamo VITE_GH_PAGES=1 così asset e chunk usano base corretta.
 * In locale: `npm run dev` / `npm run build` → base "/" (default).
 */
const ghPagesBase = '/pub-repairs/';
const base = process.env.VITE_GH_PAGES === '1' ? ghPagesBase : '/';

export default defineConfig({
  base,
  root: '.',
  publicDir: 'public',
  build: {
    outDir: 'dist',
    assetsDir: 'assets',
    sourcemap: false,
  },
});
