# Design System — Tema scuro

Valori per **dark mode**. I nomi dei token sono gli stessi del tema chiaro; cambiano solo i colori.

---

## Surface hierarchy & nesting

Treat the UI as a physical stack of materials.

- **Base Layer:** `surface` `#131313` or `surface-container-lowest` `#0e0e0e` for the deep, cinematic background.
- **Mid Layer:** `surface-container` `#201f1f` for primary content areas.
- **Top Layer:** `surface-container-highest` `#353534` for interactive cards or floating elements.

Support layers (when referenced in core): `surface-dim`, `surface-container-high`, `surface-bright`, `surface-variant` — map in implementation to the same stepped ramp (lighter grays on darker bases).

---

## Brand & accents

- **Primary:** `#adc6ff` — “Electric Blue” (editorial / highlights).
- **Primary container:** `#4b8eff` — gradient end / stronger accent.
- **On-primary:** text/icons on primary-filled controls (typically near-white).
- **Primary-fixed-dim:** use per icone discrete (look “Silver” con brand presente).

### Primary gradient

Subtle linear gradient from `primary` (`#adc6ff`) to `primary-container` (`#4b8eff`) at **135deg**. Do not use flat `primary` fills for primary buttons (see [DESIGN_CORE.md](./DESIGN_CORE.md) §2).

### Glassmorphism (overlays)

Apply `surface-variant` at **60%** opacity with **`24px`** backdrop-blur.

---

## Elevation: Ambient Bloom

When an element must float:

- Shadow blur: **40px**
- Opacity: **8%**
- Color: **`surface-tint` / glow** `#adc6ff` (allineato al primary; riflesso tipo schermo su superficie scura)

---

## Ghost borders

- **Default boundary** (inputs, subtle containers): `outline-variant` at **15%** opacity.
- **Secondary button** stroke: `outline-variant` at **20%** opacity.

---

## Glass chips

- `surface-variant` background at **40%** opacity + **`blur-md`**.

---

## Theme-specific don’ts

- **Don't** use pure black `#000000`. It kills the depth. Use `surface-container-lowest` (`#0e0e0e`) or richer base tokens.

---

## Note implementative

- Preferire `prefers-reduced-motion` per ridurre blur/animazioni dove necessario (accessibilità).
- Verificare contrasto WCAG per `on-surface` / `on-primary` rispetto alle superfici effettive nel build.
