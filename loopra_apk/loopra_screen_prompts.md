# Loopra App — Detailed AI UI Prompts
> Use these prompts with Figma AI, v0.dev, Framer AI, or any AI UI generator.
> App: **Loopra** — a waste management & bio-asset recycling mobile app
> Design language: Dark green (#0E3D2F) and black base, neon/lime green (#4ADE80) accents, white text
> Font: Rounded sans-serif (e.g. Nunito, Poppins, or DM Sans)
> Platform: iOS mobile, 390×844px

---

## SCREEN 1 — Splash Screen

Design a full-screen splash/loading screen for a mobile app called **Loopra**.

**Background:** Solid black (#000000), completely clean with no other elements.

**Center content (vertically and horizontally centered):**
- A circular logo made of three rotating recycling arrows arranged in a pinwheel formation. The arrows should have a gradient from lime green (#4ADE80) to teal (#14B8A6), giving a 3D-metallic appearance with subtle depth. The arrows should spiral inward and overlap slightly to suggest continuous looping.
- Directly below the logo icon, display the wordmark **"loopra"** in all-lowercase, white, in a clean modern rounded sans-serif font (weight: 600), font size ~32px. No tagline, no other text.

**Logo size:** ~120×120px centered icon, wordmark below with ~16px gap.

**No bottom navigation bar. No status bar styling. Just the centered logo and wordmark on pure black.**

---

## SCREEN 2 — Home Dashboard (Dark Mode)

Design a mobile home screen dashboard for the Loopra waste-recycling app in **dark mode**.

**Background:** Near-black (#0A0A0A) overall page background.

**Top section (header):**
- Left: Small circular avatar/profile photo (40px)
- Next to avatar: Two lines of text — top line reads *"Hai, Penjaga Energi!"* in small muted green text (~12px), bottom line reads **"Ahmad S"** in bold white (~18px)
- Right side: Two square icon buttons (~40×40px each, dark gray #1A1A1A rounded corners) — a **bell icon** (notifications) and a **"?" icon** (help)

**Main wallet card** (full-width, ~200px tall, rounded corners ~20px, placed just below header):
- Background: Rich green gradient (#1B5E2F → #2D8A4E), feels like a premium card
- Top-left: Loopra logo (small recycling arrows icon) + wordmark "loopra" in white, inline
- Top-right: Two small dark rounded square icon buttons — one with a **wallet/card icon**, one with a **transfer/send icon**
- Center-left label: *"Total Energy Credits"* in small white text, with a small circular ℹ️ info icon beside it
- Large balance: A coin stack icon + **"1.250.000 EC"** in bold white ~32px, followed by an eye/visibility icon
- Below balance: *"≈ Rp 1.250.000,-"* in small muted white text (~12px)
- Bottom section of card: A horizontal progress bar — left label *"Target Harian"* with a small upward trending arrow icon, right label **"85%"** — the bar is ~85% filled in bright lime green (#4ADE80) on a dark green track. Below the bar: *"85% dari target harian tercapai"* in small white text (~11px)

**Quick action icons** (4 icons in one row, dark background section ~80px tall, gap below card):
Each icon is a dark green rounded square (~56×56px) with a white icon inside:
1. Factory/hub building icon → label *"Cari Hub"*
2. Ticket/voucher icon → label *"Voucher"*
3. Globe with leaf icon → label *"Edu-Bio"*
4. Lightning bolt icon → label *"Misi Harian"*
Labels in small white text (~11px) centered below each icon.

**Stats row** (two equal cards side by side, dark green #1A2F24 background, ~120px tall, rounded 16px):
- Left card: Small leaf plant icon in lime green, large number **"450"** in lime green (~36px bold), below: *"Impact Points"* in small white text
- Right card: Same leaf icon, large **"12,4"** with *"Kg"* in smaller superscript, in lime green, below: *"CO2 Prevented"*

**Contribution banner** (full-width, dark green #1A2F24, ~60px tall, rounded 12px):
- Left: Small lightning bolt icon in a darker square
- Text: *"Kontribusi Anda hari ini telah "* followed by bold white **"menerangi 5 rumah melalui Biogas"*

**Section: "Harga Bio-Asset Hari Ini"** with *"Lihat semua"* in lime green on the right — section title in bold white
Horizontal scrollable cards (~100×90px each, dark green #1A2F24, rounded 12px):
- Each card has: small leaf icon top-left, a green upward arrow + percentage badge (e.g. **"+4.2%"** in small lime text), item name (e.g. *"Limbah Jeruk"*) in white, price (**"2.500 EC/Kg"**) in lime green bold
- Show at least: Limbah Jeruk (+4.2%, 2.500 EC/Kg), Pulp Wortel (+2.4%, 2.100 EC/Kg), and one partially visible card on the right edge

**Section: Transaction history** (same header style, "Lihat semua" link):
Three transaction rows (full width, dark green cards, rounded 12px, ~64px tall each):
1. Down-arrow icon (lime green square) — *"Deposit 50Kg Kulit Mangga"* (white bold) / *"2 jam yang lalu"* (gray small) — **+50.000 EC** (lime green, right-aligned)
2. Up-arrow icon (dark square) — *"Konversi ke Bioetanol Hu..."* / *"2 jam yang lalu"* — **–12.500 EC** (red #EF4444, right-aligned)
3. Lightning bolt icon (lime green square) — *"Bonus Misi Penjaga Energi"* / *"Kemarin, 18:42"* — **+8.200 EC** (lime green)

**Bottom Navigation Bar** (fixed, dark #111 background, ~80px tall, thin top border):
5 items centered: **Beranda** (home icon, lime green active), **Wallet** (wallet icon), center **scan button** (large ~60px circle, bright lime-to-green gradient, with a rounded square scan/camera viewfinder icon in white), **History** (clock icon), **Profil** (person icon). Active item label in lime green, others in muted gray.

---

## SCREEN 3 — Home Dashboard (Light Mode)

Same layout and all content as Screen 2 (Home Dashboard Dark Mode), but with these changes:

**Background:** Off-white (#F5F5F0) overall page background.

**Header:** Same layout, but text is dark (#111).

**Wallet card:** Same green gradient — the card retains its dark green appearance regardless of light/dark mode.

**Quick action icons:** White background section, icons are dark green rounded squares.

**Stats cards:** Dark green (#1A3D2A) background retained (same as dark mode — these cards always stay dark green).

**Contribution banner:** Dark green background retained.

**Transaction rows:** Light gray (#F0F0EC) background with dark text, colored amounts same as before.

**Bottom nav bar:** White background, thin light gray top border. Active item in lime green, others in dark gray.

**All other measurements, spacing, and content identical to dark mode version.**

---

## SCREEN 4 — Location List / Hub Finder (Light Mode)

Design a mobile list screen for finding waste collection hubs and "bank sampah" (waste banks) in the Loopra app — **light mode**.

**Background:** White (#FFFFFF)

**Top bar (no header card, just search + filter):**
- Full-width search bar (~48px tall, rounded pill, white fill with light gray border #E0E0E0): magnifying glass icon on left, placeholder text *"Cari lokasi pasar induk / bank sampah..."* in gray, and a **filter icon** (three horizontal lines, stacked, green) on the far right outside the search bar
- Below search bar: Horizontal scrollable filter pill tabs:
  - **"Semua"** — active, filled lime green (#4ADE80) background, dark green text, pill shape
  - *"Terdekat"* — dark gray #2A2A2A filled pill, white text
  - *"Terjauh"* — dark gray pill, white text
  - *"Best Seller"* — dark gray pill, white text (partially visible on right edge)

**Scrollable card list** (full-width cards, rounded 20px corners, white card background with subtle shadow):

Each card contains:
- **Top portion (~160px):** A photo image of a waste collection area (bins, recycling containers, bags of waste outdoors). Over the image, top-left: a dark pill badge showing the operating hours *"10.00 – 16.00"* in white small text, and next to it a green pill badge with *"Tersedia"* (Available) in white.
- **Bottom portion (~70px):** Dark green (#1B4332) background. Left side: circular logo — dark green circle with a yellow/gold tree illustration inside (the Bank Sampah Inyong logo). Right of logo: **"Bank Sampah Inyong"** in white bold (~15px), below it: a small location pin icon in lime green + *"Jl. Melati No. 45, Desa Kutasari"* in small muted white (~12px)

Show **3 cards** in the list — the last one is partially cropped at the bottom (indicating scroll).

**Bottom Navigation Bar:** Same as Screen 2, light mode version (white background).

---

## SCREEN 5 — Location List / Hub Finder (Dark Mode)

Identical layout and content to Screen 4, but:

**Background:** Pure black (#000000)
**Cards:** Same structure, but card shadow becomes invisible; instead use a very subtle dark green border (#1A3D2A) or slightly lighter card background (#111111)
**Search bar:** Dark gray (#1A1A1A) fill, muted white placeholder, border #2A2A2A
**Filter pills:** Same — "Semua" in lime green, others in dark #2A2A2A
**Card bottom section:** Same dark green — no change
**Bottom nav bar:** Dark #111 background

---

## SCREEN 6 — Map Lokasi (Dark Mode)

Design a map routing screen for the Loopra app — **dark mode**.

**Background:** A full-screen dark map — use a dark/night-mode map style (black streets, white road lines, very minimal labels). The map should fill the entire screen behind all UI elements.

**Top navigation bar** (floating, transparent background):
- Far left: white back arrow (←)
- Center: A rounded pill button (~140px wide, lime green background #4ADE80, dark green text) reading **"Map Lokasi"** in bold
- Far right: A small circular gray button (~36px) with a lowercase **"i"** in white (info button)

**Floating direction input card** (positioned near top of screen, below nav bar, full-width with ~16px horizontal margins, dark green #1A3D2A background, rounded 20px corners, ~180px tall, with a soft shadow):

Inside the card:
- Label **"Lokasi Anda"** in white bold (~14px)
- Input row: White rounded pill field (~52px tall) with a **green location pin icon** (filled green circle with dot) on the left, text *"Dextra Kost, Jl. Raya Banaran"* in white/light gray, and a **three-dot vertical menu icon** (⋮) on the right
- Label **"Lokasi Tujuan"** in white bold (~14px), ~8px below
- Input row: Same pill field style, green pin icon left, placeholder *"Isi Tujuan"* in muted gray, and a **swap arrows icon** (↑↓ stacked) in gray on the right

**Map content:**
- The map fills behind the card and nav
- One **green map location pin** visible on the map area (below the card), indicating the user's current position — bright lime green circle with a white center dot, with a small stem

**Bottom Navigation Bar:** Same dark mode nav bar as Screen 2.

---

## SCREEN 7 — Map Lokasi (Light Mode)

Same layout as Screen 6 (Map Dark Mode), with these changes:

**Map style:** Light/day mode map — white/very light gray road network, thin gray road lines, minimal pastel labels. Clean and airy.

**Top nav pill button:** Changes from lime green to **dark green (#1B4332)** background with white text "Map Lokasi".

**Floating card:** Still dark green #1A3D2A background — card retains dark appearance even in light mode.

**Location pin on map:** Same bright lime green.

**Background page (outside map):** White. The map fills the full screen so this mostly doesn't matter.

**Bottom nav bar:** White background, light mode.

---

## SCREEN 8 — AI Scan Active (Camera View)

Design a camera scanning screen for the Loopra app's AI waste detection feature.

**Background:** Full-screen live camera view — show a realistic photo of a hand holding a clear plastic bag full of orange peels/citrus fruit waste. The photo fills 100% of the screen from edge to edge. Apply a very subtle dark vignette around the edges.

**Top bar (overlaid on camera):**
- Far left: white back arrow (←) with no background
- Far right: lowercase **"i"** in white, no background or subtle circle

**Scan viewfinder overlay (center of screen):**
A rounded square scan frame (~260×260px), centered horizontally, placed in the upper-middle of the screen. The frame consists of only the 4 corner brackets (L-shaped thick white rounded lines, ~30px per arm) — not a complete rectangle. Inside the frame: a **red horizontal scanning line** (~2px, spans full frame width) positioned about 40% from the top of the frame, indicating an active scan in progress. This line should look like it's mid-animation.

**Bottom section (overlaid on camera, ~180px from bottom):**
- Center pill label: *"AI Cek Sampah"* in white, on a semi-transparent white/frosted glass pill background (#FFFFFF55), centered horizontally
- Large green center scan/capture button (~64px circle): bright lime-to-green gradient, with a **white magnifying glass icon** inside (search/scan icon). This is the main action button.
- Bottom-left: A small square thumbnail (~60×60px, rounded 12px) showing a previous scan result — an image of orange peel
- Bottom-right: A small circle (~52px) with a **yellow/gold lightning bolt icon** (#FACC15) on a semi-transparent dark background — quick action shortcut

**No bottom navigation bar on this screen.**

---

## SCREEN 9 — AI Scan Result (Waste Grade Detail)

Design a post-scan result screen for the Loopra app, shown after the AI identifies a waste type.

**Top half (full-width photo, ~55% of screen height):**
- Full-bleed photo of orange peels in a plastic bag (same as camera screen), slightly darkened
- A rounded square scan viewfinder frame overlay (same corner-bracket style, white) centered over the photo — this time no scanning line, scan is complete
- A rounded pill badge **"GRADE B"** centered below the frame but still over the photo — bright lime green (#4ADE80) border, transparent fill, bold lime green text

**Bottom half (dark #0A0A0A background, takes remaining screen):**

- Title: **"Limbah Hortikultura (Jeruk)"** in bold white, ~20px, left-aligned with padding
- Info/description card (~80px tall, dark #1A1A1A background, rounded 12px, full-width):
  - Left: a circular science/atom icon in lime green (~36px)
  - Right (text block): *"Klasifikasi Grade B mengidentifikasi bio-asset dengan karakteristik kadar air (moisture content) menengah dan profil nutrisi yang telah "* in small white/gray text (~12px), followed by a tappable link text **"lihat lebih detail"** in lime green

- Section label: **"Industrial Assay Data"** in bold white, ~15px

- A row of **4 equal icon data cards** (horizontally arranged, ~80px wide each, dark green #1A2F24, rounded 12px, ~90px tall):
  1. Small green seedling icon — label *"Est. Yield: 1.2 L"* white bold — sublabel *"(Crude Ethanol)"* gray small
  2. Small green container icon — *"Energy Pot.: 35.4 MJ"* — *"(Biogas)"*
  3. Small factory building icon — *"Water Content: 12%"* — *"(Kadar Air)"*
  4. Small recycling arrows icon — *"Purity: 98%"* — *"(Kemurnian)"*

**Top bar (over photo):**
- Far left: white back arrow (←)
- Far right: lowercase "i" in white circle

**No bottom navigation bar on this screen.**

---

## DESIGN SYSTEM REFERENCE

Use these tokens consistently across all screens:

| Token | Value |
|---|---|
| Primary background (dark) | #0A0A0A |
| Card background (dark) | #111111 |
| Green card / section | #1A2F24 |
| Deep green card | #1A3D2A |
| Wallet card gradient | #1B5E2F → #2D8A4E |
| Accent / CTA green | #4ADE80 |
| Dark green text on green bg | #0F3D22 |
| White text | #FFFFFF |
| Muted text | #9CA3AF |
| Danger / negative | #EF4444 |
| Warning / highlight | #FACC15 |
| Border radius (cards) | 16–20px |
| Border radius (pills) | 999px |
| Border radius (icon tiles) | 12px |
| Font | Nunito / Poppins / DM Sans |
| Font weight (titles) | 700 |
| Font weight (labels) | 600 |
| Font weight (body) | 400 |

---

## TIPS FOR AI GENERATORS

- Always specify **mobile frame 390×844px** (iPhone 14 proportions)
- Mention **"no lorem ipsum"** — use the exact Indonesian text strings above
- For v0.dev: preface with *"Create a React mobile UI component..."*
- For Figma AI: preface with *"Design a mobile app screen..."*
- For Midjourney/image gen: add *"UI/UX mobile app design, flat design, high fidelity mockup, no phone frame"*
- Always include **"dark green and black color scheme, lime green accent (#4ADE80)"** in your prompt
