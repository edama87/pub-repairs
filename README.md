# OfficinaePhone (sito vetrina)

Sito statico generato con **Vite**: le pagine pubbliche (`index.html`, `servizi.html`, `usati.html`, `contatti.html`) **non richiedono WordPress**. Dopo `npm run build` il contenuto da pubblicare è la cartella **`dist/`**.

## Sviluppo

```bash
npm install
npm run dev
```

## Build e deploy

```bash
npm run build
```

- **Base path**: in produzione su sottocartella impostare `VITE_BASE` (vedi [vite.config.js](vite.config.js)).  
- **GitHub Pages**: usare `npm run build:gh-pages` con `VITE_GH_PAGES=1` se applicabile.

## WordPress

Il vecchio sito su WordPress **non** è un runtime per questo front-end: sostituisci il deploy del CMS con i file in `dist/` sul dominio. Eventuali moduli **PHP** sotto `api/` e `admin/` sono un layer separato (es. back-office listino) e non dipendono da WordPress.
