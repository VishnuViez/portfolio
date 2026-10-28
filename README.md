# Vishnu · Portfolio

Personal portfolio site, live at **https://vishnuviez.github.io/portfolio/**.

It's a single static page: plain HTML and CSS, plus a small script for the
mobile menu, the active nav link and the back-to-top button. There's no
framework and no build step.

## Files

| File | What it is |
|---|---|
| `index.html` | All page content: hero, about, skills, projects, experience, contact |
| `styles.css` | Styles, with colors as variables at the top of the file |
| `main.js` | Mobile menu, active nav link, back-to-top button |
| `favicon.svg`, `favicon-32.png`, `apple-touch-icon.png` | Tab and home-screen icons |
| `assets/Vishnu_Resume.pdf` | The resume the Resume buttons open |
| `assets/images/profile.jpg` | Hero photo, also used as the link preview image |

The Flutter app in `lib/`, `android/`, `ios/`, `web/` and the other platform
folders is the previous version of the portfolio. The site doesn't use it.

## Run it locally

```bash
python3 -m http.server 4173
```

Then open http://localhost:4173.

## Publish

GitHub Pages serves the `gh-pages` branch, not `main`. After committing your
changes on `main`:

```bash
scripts/deploy.sh
```

The script copies only the site files listed above onto `gh-pages` and pushes.
GitHub Pages usually updates within a minute.

When you change `styles.css` or `main.js`, bump the `?v=` number on their links
in `index.html`. Otherwise visitors' browsers can keep showing the cached old
files.

## Updating the resume

Replace `assets/Vishnu_Resume.pdf` with the new PDF, keeping the same file
name, then commit and publish. The PDF is public, including the phone number
on it.
