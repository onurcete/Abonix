---
name: Premium Subscription Tracker
colors:
  surface: '#f7fafb'
  surface-dim: '#d7dadb'
  surface-bright: '#f7fafb'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f1f4f5'
  surface-container: '#ebeeef'
  surface-container-high: '#e6e9ea'
  surface-container-highest: '#e0e3e4'
  on-surface: '#181c1d'
  on-surface-variant: '#424844'
  inverse-surface: '#2d3132'
  inverse-on-surface: '#eef1f2'
  outline: '#727974'
  outline-variant: '#c1c8c3'
  surface-tint: '#466557'
  primary: '#466557'
  on-primary: '#ffffff'
  primary-container: '#9dbead'
  on-primary-container: '#304e40'
  inverse-primary: '#adcebd'
  secondary: '#94483b'
  on-secondary: '#ffffff'
  secondary-container: '#fd9d8c'
  on-secondary-container: '#773227'
  tertiary: '#3e5ba7'
  on-tertiary: '#ffffff'
  tertiary-container: '#9bb4ff'
  on-tertiary-container: '#24438e'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#c8ead8'
  primary-fixed-dim: '#adcebd'
  on-primary-fixed: '#022016'
  on-primary-fixed-variant: '#2f4d40'
  secondary-fixed: '#ffdad4'
  secondary-fixed-dim: '#ffb4a7'
  on-secondary-fixed: '#3d0702'
  on-secondary-fixed-variant: '#763126'
  tertiary-fixed: '#dbe1ff'
  tertiary-fixed-dim: '#b3c5ff'
  on-tertiary-fixed: '#001849'
  on-tertiary-fixed-variant: '#23438d'
  background: '#f7fafb'
  on-background: '#181c1d'
  surface-variant: '#e0e3e4'
typography:
  headline-lg:
    fontFamily: Manrope
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 36px
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Manrope
    fontSize: 22px
    fontWeight: '600'
    lineHeight: 28px
  headline-sm:
    fontFamily: Manrope
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-lg:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
  label-md:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.5px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 4px
  xs: 8px
  sm: 12px
  md: 16px
  lg: 24px
  xl: 32px
  margin-mobile: 16px
  gutter: 12px
---

## Brand & Style

The design system is centered on a "Mindful Management" philosophy. It aims to transform the often-stressful task of tracking recurring expenses into a calm, intentional experience. The target audience consists of professionals and tech-savvy individuals who value aesthetic clarity and financial transparency.

The style is **Corporate / Modern** with a strong infusion of **Minimalism**. It draws structural inspiration from Material Design 3—specifically the use of container-based hierarchy—but softens the execution with a custom organic color palette and tactile elements. The emotional response should be one of reliability and "breathing room," achieved through generous whitespace and a lack of aggressive visual noise.

## Colors

The palette uses an off-white base to reduce eye strain compared to pure white. The primary Sage Green (#9DBEAD) acts as the "growth" and "positive status" color, used for primary actions and healthy financial indicators. A muted Red/Orange (#E68A7A) provides a soft but clear warning for upcoming payments or cancellations.

Typography is anchored by a Clean Dark Grey (#2D3132), ensuring high legibility without the harshness of pure black. Secondary surfaces use subtle tonal shifts to differentiate between the background and interactive cards.

## Typography

This design system utilizes a dual-font approach. **Manrope** is used for headlines to provide a modern, slightly geometric personality that feels premium and structured. **Inter** is used for all body text and labels to ensure maximum functional clarity at small sizes, particularly for numerical data and currency.

Numerical figures in "Statistics" views should utilize slightly tighter letter-spacing to maintain a compact, data-heavy look while remaining elegant.

## Layout & Spacing

The layout follows a **fluid grid** model optimized for mobile-first consumption. It uses a 4-column structure on mobile devices with 16px side margins. 

Spacing is governed by an 8pt grid system, though 4px increments (base) are allowed for fine-tuning icons and tight label groupings. Vertical rhythm is critical; use `lg` (24px) spacing between distinct content cards to emphasize the "plenty of whitespace" requirement.

## Elevation & Depth

Depth is communicated through **Tonal Layers** supplemented by **Ambient Shadows**. 

1.  **Level 0 (Background):** The off-white base layer.
2.  **Level 1 (Cards):** White surfaces with a very soft, diffused shadow (Blur: 15px, Y: 4px, Opacity: 4% Black). These cards house the main content.
3.  **Level 2 (Active Elements):** Buttons and active chips. Primary buttons feature a subtle linear gradient (Sage Green to a slightly lighter tint) to create a soft convex feel.

Avoid harsh borders. Instead, use thin, low-contrast 1px strokes in a slightly darker off-white if additional separation is needed on white-on-white layouts.

## Shapes

The shape language is "Friendly Professional." In accordance with the requested 16-24px range, the standard card corner radius is set to **20px**. This creates a soft, modern container that feels safe and approachable.

Interactive elements like buttons and input fields use a slightly tighter **12px** radius to maintain a distinction between "containers" and "actions."

## Components

-   **Buttons:** Primary buttons use a subtle top-to-bottom Sage Green gradient. Secondary buttons use a tonal background (a 10% opacity version of the primary color) with no shadow.
-   **Cards:** The primary container for subscription items. Cards should have internal padding of 16px and utilize horizontal layouts for subscription lists (Logo | Name/Date | Price).
-   **Chips:** Used for categories (e.g., "Entertainment," "Productivity"). These are pill-shaped with 12px horizontal padding and use the label-md typography.
-   **Progress Bars/Charts:** Utilize the Sage Green for positive trends and the muted Red/Orange for alerts. Use rounded caps on all bar charts and line graphs.
-   **Input Fields:** Ghost-style inputs with a soft grey border that transitions to Sage Green on focus. Labels should be floating or positioned clearly above the field.
-   **Navigation:** A clean bottom navigation bar with minimal line icons. The active state is indicated by the Sage Green color and a subtle dot or bar indicator below the icon.