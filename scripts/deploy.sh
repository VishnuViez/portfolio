#!/usr/bin/env bash
# Publish the static site to the gh-pages branch, which GitHub Pages serves at
# https://vishnuviez.github.io/portfolio/.
#
# Only the files in SITE_FILES are published. The rest of this repository
# (the Flutter app, docs, PDFs) never reaches gh-pages.
set -euo pipefail

SITE_FILES=(
    index.html
    styles.css
    main.js
    favicon.svg
    favicon-32.png
    apple-touch-icon.png
    assets/Vishnu_Resume.pdf
    assets/images/profile.jpg
)

cd "$(git rev-parse --show-toplevel)"

if [[ -n "$(git status --porcelain -- "${SITE_FILES[@]}")" ]]; then
    echo "Commit your site changes first; gh-pages is built from the last commit." >&2
    exit 1
fi

sha=$(git rev-parse --short HEAD)
tmp=$(mktemp -d)
trap 'git worktree remove --force "$tmp" >/dev/null 2>&1 || true; rm -rf "$tmp"' EXIT

git fetch -q origin gh-pages
git worktree add -q -B gh-pages "$tmp" origin/gh-pages
git -C "$tmp" rm -rq --ignore-unmatch .
for f in "${SITE_FILES[@]}"; do
    mkdir -p "$tmp/$(dirname "$f")"
    git show "HEAD:$f" > "$tmp/$f"
done
# Serve files as-is instead of running them through Jekyll.
touch "$tmp/.nojekyll"

git -C "$tmp" add -A
if git -C "$tmp" diff --cached --quiet; then
    echo "gh-pages already matches $sha; nothing to publish."
    exit 0
fi
git -C "$tmp" commit -q -m "Deploy site from main $sha"
git -C "$tmp" push -q origin gh-pages
echo "Published $sha. GitHub Pages usually updates within a minute."
