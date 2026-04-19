import { defineConfig } from 'vite';
import { fileURLToPath } from 'node:url';
import { dirname, resolve } from 'node:path';

const __dirname = dirname(fileURLToPath(import.meta.url));

/**
 * GitHub Pages (sito di progetto): URL https://edama87.github.io/pub-repairs/
 * In CI impostiamo VITE_GH_PAGES=1 così asset e chunk usano base corretta.
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
    rollupOptions: {
      input: {
        main: resolve(__dirname, 'index.html'),
        servizi: resolve(__dirname, 'servizi.html'),
        usati: resolve(__dirname, 'usati.html'),
        contatti: resolve(__dirname, 'contatti.html'),
      },
    },
  },
});
