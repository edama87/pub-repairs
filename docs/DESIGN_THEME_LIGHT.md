# Design System — Tema chiaro

Valori per **light mode**: stessi **nomi token** del tema scuro; rampa di superfici più chiara con stepping morbido (no “foglio Excel” di bordi).

---

## Surface hierarchy & nesting

Treat the UI as a physical stack of materials. On light, depth reads as **slightly darker or warmer steps** on a soft canvas, not harsh outlines.

- **Base Layer:** `surface` `#ebebea` — main canvas (warm neutral).
- **Deepest floor (optional band):** `surface-container-lowest` `#e3e3e0` — use instead of pushing everything to pure paper-white.
- **Mid Layer:** `surface-container` `#f4f4f2` — primary content regions.
- **Top Layer:** `surface-container-highest` `#ffffff` — cards, inputs, elevated panels.

Support layers: `surface-dim`, `surface-container-high`, `surface-bright`, `surface-variant` — maintain the same *relative* lighter-on-darker or elevated-on-canvas relationship as in code (implementation ramp).

---

## Brand & accents

Contrast on light UI needs slightly **deeper** blues for text and gradient endpoints than on dark.

- **Primary:** `#1d4ed8` — main brand on light (text, strong accents).
- **Primary container:** `#3b82f6` — gradient end / fills.
- **On-primary:** `#ffffff` (or near-white) on filled primary controls.
- **Primary-fixed-dim:** softer blue-gray for quiet icons (stesso ruolo del core).

### Primary gradient

Linear gradient from `primary` (`#1d4ed8`) to `primary-container` (`#3b82f6`) at **135deg**. Same rule as dark: no flat primary slab on primary actions.

### Glassmorphism (overlays)

Apply `surface-variant` at **55%** opacity with **`24px`** backdrop-blur (leggermente più presente che su dark per leggerezza su fondo chiaro; ritoccare in implementazione se necessario).

---

## Elevation: Ambient Bloom

When an element must float:

- Shadow blur: **40px**
- Opacity: **12%** (un filo più visibile su fondo chiaro rispetto all’8% dark)
- Color: **`surface-tint` / shadow tone** `#64748b` con leggera componente blu, oppure `#3b82f6` a bassissima saturazione — evitare alone “neon” se illeggibile; validare su card reali.

---

## Ghost borders

- **Default boundary:** `outline-variant` at **12%** opacity (stesso concetto “felt not seen”; su chiaro spesso serve meno opacità).
- **Secondary button:** `outline-variant` at **18%** opacity.

---

## Glass chips

- `surface-variant` background at **35%** opacity + **`blur-md`** — keeps chips legibili without heavy strokes on light gray.

---

## Theme-specific don’ts

- **Don't** use pure white `#ffffff` as the **only** surface for the entire UI. It flattens depth. Use the stepped tokens (`surface`, `surface-container`, etc.).
- **Don't** use pure black `#000000` for body text unless contrast requires it; prefer semantic `on-surface` tuned in implementation (typically near-black charcoal).

---

## Note implementative

- Tabella token light/dark nel codice dovrebbe **riusare gli stessi nomi** elencati qui e in [DESIGN_THEME_DARK.md](./DESIGN_THEME_DARK.md).
- Verificare contrasto WCAG per testi e stati focus rispetto a `surface-container-highest` e al primary.
