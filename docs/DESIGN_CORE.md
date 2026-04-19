# Design System — Nucleo condiviso

Applica a entrambi i temi. Per valori colore e superficie vedi [DESIGN_THEME_DARK.md](./DESIGN_THEME_DARK.md) e [DESIGN_THEME_LIGHT.md](./DESIGN_THEME_LIGHT.md).

---

## 1. Overview & Creative North Star

The Creative North Star for this design system is **"The Precision Atelier."**

We are moving away from the "utility app" aesthetic and toward a "luxury service" experience. This system treats smartphone repair not as a mechanical chore, but as a restoration of a personal essential. To break the "template" look, we utilize **Intentional Asymmetry** and **Editorial Scale**.

Instead of a centered, predictable grid, we use wide-set margins and overlapping elements (e.g., a high-resolution device macro shot bleeding off the edge of a `surface-container` card). This creates a sense of depth and movement, suggesting that our expertise—and the technology we handle—is too expansive to be contained by standard boxes.

---

## 2. Tonal structure (senza linee nette)

### The "No-Line" Rule

**Explicit Instruction:** Do not use 1px solid borders to define sections.

Structure is **Tonal Stepping** on both themes (rampe in [DESIGN_THEME_DARK.md](./DESIGN_THEME_DARK.md) e [DESIGN_THEME_LIGHT.md](./DESIGN_THEME_LIGHT.md)): adjacent regions differ **solo** per token di superficie, non per stroke. The transition in tone is the boundary. This mimics the unibody construction of premium electronics.

### The "Glass & Gradient" Rule (principio)

Do not use `primary` as a flat fill for key actions. Use the **linear gradient** and **glass** recipes defined in the theme file (angle, opacity, blur restano allineati tra i temi; cambiano i riferimenti colore dove serve contrasto).

---

## 3. Typography: Editorial Authority

We use a dual-typeface system to balance technical precision with modern elegance.

- **Display & Headlines (Manrope):** This is our "Editorial" voice. Manrope’s geometric yet warm curves should be used for all `display-lg` through `headline-sm` scales. For `display-lg`, use `tracking-tighter` (-0.02em); for `headline` scales, use `tracking-widest` (0.05em) to achieve that high-end boutique look.
- **Body & UI (Inter):** This is our "Functional" voice. Inter is used for `title`, `body`, and `label` roles. It provides maximum legibility for technical specs and repair pricing.

**Hierarchy Note:** Always pair a `display-md` headline with a `label-md` uppercase sub-header using the `primary` color token to establish immediate brand authority.

---

## 4. Elevation & Depth

### The Layering Principle

Forget shadows in 90% of use cases. Depth is achieved by **stacking surface tokens**: each step up reads as a distinct material layer (vedi gerarchia per tema nei file tema).

### Ambient Shadows

When an element must float (e.g., FAB or modal), use **Ambient Bloom** con i parametri del file tema (blur, opacity, colore).

### The "Ghost Border"

If a container requires a boundary (e.g., an input field), use the `outline-variant` token at the **opacity** indicated in the theme file. It should be felt, not seen.

---

## 5. Components

### Cards & Lists

- **Rule:** No dividers. Use `2rem` (xl) or `3rem` (xxl) vertical spacing to separate list items.
- **Radius:** All cards must use `rounded-lg` (2rem) or `rounded-md` (1.5rem) to mirror the industrial design of modern flagship smartphones. This aligns with our high `roundedness` value.

### Buttons

- **Primary:** Gradient fill (`primary` → `primary-container`), text on `on-primary`, `rounded-full`.
- **Secondary:** Transparent background with a "Ghost Border" (`outline-variant` at the secondary opacity in the theme).
- **Interaction:** On hover, the `surface-bright` token should subtly illuminate the background.

### Input Fields

- **Base:** `surface-container-highest` background, `rounded-sm` (0.5rem).
- **Active State:** Change border from "Ghost" to a solid 1px `primary` glow. Helper text must use `label-sm`.

### Glass Chips

Use for repair status or device categories. Use a `surface-variant` background at the **opacity** given in the theme, with **`blur-md`**. Keeps hierarchy readable without heavy borders.

---

## 6. Do’s and Don’ts (trasversali)

### Do

- **Do** use high-quality macro photography of glass, silicon, and metal. Let the imagery overlap the edge of containers.
- **Do** use generous white space, but keep in mind the slightly more compact `spacing` setting.
- **Do** use `primary-fixed-dim` for subtle icons to maintain a sophisticated "Silver" look without losing brand color.

### Don't

- **Don't** use sharp corners. Everything should feel "haptic" and smooth to the touch, reinforcing our maximum `roundedness`.
- **Don't** use aggressive animations. Use "Slow & Smooth" transitions (e.g., `cubic-bezier(0.4, 0, 0.2, 1)`) for all hover and modal states.
- **Don't** use standard 1px dividers. They make a premium interface look like a spreadsheet. Use tonal shifts.

Theme-specific constraints (e.g. nero/bianco puro) are listed in each theme file.
