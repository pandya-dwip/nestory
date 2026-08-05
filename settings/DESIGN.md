---
name: Obsidian Ethereal
colors:
  surface: '#131313'
  surface-dim: '#131313'
  surface-bright: '#3a3939'
  surface-container-lowest: '#0e0e0e'
  surface-container-low: '#1c1b1b'
  surface-container: '#201f1f'
  surface-container-high: '#2a2a2a'
  surface-container-highest: '#353534'
  on-surface: '#e5e2e1'
  on-surface-variant: '#c4c7c8'
  inverse-surface: '#e5e2e1'
  inverse-on-surface: '#313030'
  outline: '#8e9192'
  outline-variant: '#444748'
  surface-tint: '#c6c6c7'
  primary: '#ffffff'
  on-primary: '#2f3131'
  primary-container: '#e2e2e2'
  on-primary-container: '#636565'
  inverse-primary: '#5d5f5f'
  secondary: '#c6c6cf'
  on-secondary: '#2f3037'
  secondary-container: '#45464e'
  on-secondary-container: '#b4b4bd'
  tertiary: '#ffffff'
  on-tertiary: '#303033'
  tertiary-container: '#e4e1e5'
  on-tertiary-container: '#656467'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#e2e2e2'
  primary-fixed-dim: '#c6c6c7'
  on-primary-fixed: '#1a1c1c'
  on-primary-fixed-variant: '#454747'
  secondary-fixed: '#e2e1eb'
  secondary-fixed-dim: '#c6c6cf'
  on-secondary-fixed: '#1a1b22'
  on-secondary-fixed-variant: '#45464e'
  tertiary-fixed: '#e4e1e5'
  tertiary-fixed-dim: '#c8c6c9'
  on-tertiary-fixed: '#1b1b1e'
  on-tertiary-fixed-variant: '#47464a'
  background: '#131313'
  on-background: '#e5e2e1'
  surface-variant: '#353534'
typography:
  display-lg:
    fontFamily: Manrope
    fontSize: 64px
    fontWeight: '200'
    lineHeight: 72px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Manrope
    fontSize: 32px
    fontWeight: '300'
    lineHeight: 40px
    letterSpacing: -0.01em
  headline-lg-mobile:
    fontFamily: Manrope
    fontSize: 28px
    fontWeight: '300'
    lineHeight: 36px
  body-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
    letterSpacing: 0.01em
  label-sm:
    fontFamily: Geist
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.1em
rounded:
  sm: 0.5rem
  DEFAULT: 1rem
  md: 1.5rem
  lg: 2rem
  xl: 3rem
  full: 9999px
spacing:
  unit: 8px
  container-padding: 40px
  gutter: 24px
  stack-sm: 12px
  stack-md: 24px
  stack-lg: 48px
---

## Brand & Style
The design system embodies "Obsidian Ethereal"—a high-luxury, immersive interface inspired by the depth of space and the precision of high-end horology. It is designed for elite memory preservation, functioning as a digital vault that feels both physically heavy and visually weightless.

The aesthetic leverages **Glassmorphism** and **Apple Vision Pro-inspired depth**. By combining the "Black Titanium" matte finish with hyper-realistic glass layers, the UI creates a sense of profound spatial hierarchy. Every interaction should feel like a whisper: precise, expensive, and effortless.

**Key Stylistic Pillars:**
- **Atmospheric Depth:** Multi-layered translucency that interacts with background light.
- **Precision Engineering:** 1px hairlines and microscopic details.
- **Tactile Digitalism:** Surfaces that react to gaze or hover with subtle internal glows.
- **Monochrome Mastery:** A strict absence of color to prioritize the user's content (photos/memories) as the only source of vibrancy.

## Colors
The palette is strictly monochromatic, utilizing the "Black Titanium" aesthetic to create a canvas for luxury.

- **Base Background:** `#050505` (Pure Matte Black). This provides the "void" upon which glass layers sit.
- **Glass Fill:** Hex `#000000` at 40% to 60% opacity with a heavy `30px` to `50px` background blur.
- **Accents:** Pure White (`#FFFFFF`) is used exclusively for primary actions and critical text. Silver/Zinc (`#A1A1AA`) serves as the secondary metal-tone for metadata.
- **Borders:** Semi-transparent white (`rgba(255, 255, 255, 0.15)`) to define edges without adding visual weight.

## Typography
Typography is treated as a structural element. We use thin weights and generous tracking to evoke a "gallery" feel.

- **Display & Headlines:** Manrope in Light (200-300) weights. High tracking on display sizes creates a sense of air and luxury.
- **Body:** Inter provides a clean, neutral baseline for readability against blurred backgrounds.
- **Technical/Labels:** Geist is used for metadata and labels to introduce a slight "technical" precision, echoing the titanium construction.
- **Scale:** On mobile, we reduce display sizes significantly to maintain the "etched" look without overwhelming the smaller screen.

## Layout & Spacing
The layout follows a **Fluid Spatial Model**. Elements do not just sit "on" the screen; they float "in" it.

- **Grid:** A 12-column fluid grid with wide 24px gutters. 
- **Margins:** Generous 40px outer margins on desktop to ensure content feels like a curated exhibit.
- **Rhythm:** An 8px linear scale. However, for "Luxury Spacing," prefer doubling the expected gap (e.g., use 48px where 24px would suffice) to emphasize whitespace.
- **Z-Axis Spacing:** Use padding to create "inner breath" within glass containers, ensuring content never touches the 1px borders.

## Elevation & Depth
Depth is not communicated through traditional drop shadows, but through **Optical Refraction** and **Inner Glows**.

1.  **Level 0 (The Void):** Pure black `#050505`.
2.  **Level 1 (The Floor):** Glass layers with 40% opacity, 30px blur, and a 1px `rgba(255,255,255,0.1)` border.
3.  **Level 2 (Active/Floating):** Higher opacity (60%), 50px blur, and a subtle white inner-shadow (0.5px) at the top to simulate light catching a glass edge.
4.  **The Shadow:** If a shadow is required for legibility, use a very large (60px), ultra-low opacity (15%) black spread to simulate ambient occlusion rather than a direct light source.

## Shapes
The shape language is strictly **Organic and Continuous**. 

All primary buttons and containers utilize the "Pill" or "Full Circle" aesthetic. Squarer shapes are forbidden. This softness offsets the "coldness" of the black titanium and glass, making the interface feel approachable and modern. 

- **Primary Containers:** 2rem (32px) radius or higher.
- **Buttons:** Fully rounded caps (Pill).
- **Media:** Photos and videos should be clipped to at least `rounded-xl` to maintain the consistency of the glass plates.

## Components
- **Buttons:** Primary buttons are solid White with black text. Secondary buttons are glass-filled with white hairlines. On hover, buttons should increase in scale by 2% and increase the intensity of the background blur.
- **Input Fields:** Minimalist glass troughs. The "label" should float as a Geist-font small cap above the field. The cursor should be a thin white needle.
- **Cards (Memory Pods):** These are the core component. Use a 1px white border with 10% opacity. The background must be the heavy-blur glass. When focused, the border opacity should increase to 40%.
- **Lists:** Items separated by 1px hairlines that fade out at the horizontal edges (linear gradient: transparent -> white 15% -> transparent).
- **Navigation:** A floating pill-shaped bar at the bottom of the viewport, utilizing the same glassmorphism tokens.
- **Chips/Badges:** Small, pill-shaped, with Geist font. These act as "engravings" on the glass surfaces.