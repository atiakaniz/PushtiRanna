# PushtiRanna — Landing Page

Static landing site for **PushtiRanna** — Bengali-first healthy recipes. Pure HTML / CSS / JS, no build step.

```
landing/
├── index.html        # the landing page
├── css/style.css     # design system + responsive layout
├── js/script.js      # nav toggle, smooth scroll, reveal-on-scroll
├── images/           # drop your assets here (see below)
├── manifest.json     # PWA manifest (optional)
└── README.md         # this file
```

## What you need to drop in before going live

The page ships with friendly placeholders so it looks fine even without assets. Before going live, drop these into `landing/images/`:

| File | Size (suggested) | Used in | If missing |
|---|---|---|---|
| `hero_phone.png` | 600×1200 | Hero phone mockup | Placeholder shown |
| `preview_home.png` | 600×1200 | (optional) home preview | **Built-in CSS preview already shown** — drop PNG only if you want a real screenshot |
| `preview_detail.png` | 600×1200 | Recipe detail screenshot | Placeholder shown |
| `preview_search.png` | 600×1200 | Search/favorites screenshot | Placeholder shown |
| `cat_breakfast.jpg` | 800×600 | Category tile | Placeholder shown |
| `cat_lunch.jpg` | 800×600 | Category tile | Placeholder shown |
| `cat_dinner.jpg` | 800×600 | Category tile | Placeholder shown |
| `cat_salad.jpg` | 800×600 | Category tile | Placeholder shown |
| `cat_soup.jpg` | 800×600 | Category tile | Placeholder shown |
| `cat_nonveg.jpg` | 800×600 | Category tile | Placeholder shown |
| `app_icon.jpg` | 256×256 | Already present (copied from `assets/icon/app_icon.jpg`) | — |

> **Tip:** take screenshots on an Android emulator or your own device, then crop to roughly 9:18 aspect ratio for the phone mockup slots and 4:3 for the category tiles.

## Local preview

No build step. Open `index.html` directly, or run any tiny static server:

```bash
# from the landing/ folder
python -m http.server 8080
# then open http://localhost:8080
```

## Deploy to cPanel (alongside your PHP proxy)

The landing page lives **next to** your existing `pushtiranna` directory — they don't conflict. When you're ready, upload the **contents of `landing/`** (not the `landing/` folder itself) to a new directory on cPanel, for example:

```
public_html/pushtiranna-landing/
├── index.html
├── css/
├── js/
└── images/
```

Landing URL will then be:

```
https://pushtiranna.nestorabyatia.xyz/pushtiranna-landing/
```

### Checklist
- [ ] Upload `index.html`, `css/`, `js/`
- [ ] Upload `images/` **after** dropping in the PNG/JPGs from the table above
- [ ] In cPanel → File Manager, ensure the directory has no `index.html` from another path blocking it
- [ ] Enable AutoSSL on `pushtiranna.nestorabyatia.xyz` (HTTPS) if not already
- [ ] (Optional) Add `manifest.json` PWA support for "Add to Home Screen"

### Why a separate folder?
Keeping the marketing page separate from the Flutter `web/` build means:
- Future Flutter builds won't clobber it
- You can edit copy/images freely without re-running `flutter build web`
- `images/` is isolated from the app's `assets/`

## Pricing & subscription copy

The price block currently shows:

> Charging: **2.78 BDT** including (Vat+SC+SD)
> For Robi and Airtel Users only.

If your operator changes the rate or adds other carriers, edit:
- `index.html` → `.price-line` block in the hero
- `index.html` → pricing section's `<p class="muted">` and `.disclaimer`

## Customizing

- **Brand colors** → `css/style.css` `:root` block (`--green-700`, `--gold-500`, etc.)
- **Tagline** → `index.html` hero `<h1>`
- **Footer** → `index.html` `.site-footer` (email/contact columns removed per request)

## License

© 2026 PushtiRanna. All rights reserved.
