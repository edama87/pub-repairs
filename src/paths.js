/** Base URL con slash finale (Vite: `/` in dev, `/pub-repairs/` su GitHub Pages). */
export const baseUrl = import.meta.env.BASE_URL;

/** Link a un’altra pagina HTML nella stessa app (rispetta `base`). */
export function pageHref(file) {
  const f = file.endsWith('.html') ? file : `${file}.html`;
  return `${baseUrl}${f}`;
}
