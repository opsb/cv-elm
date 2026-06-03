# CLAUDE.md — cv-elm

Oliver Searle-Barnes' CV, an Elm 0.19 single-page app. Each URL path renders a
different CV variant (role-targeted cut) from its own `Data` module through a
shared or per-variant `View`.

## Deployment — push to `main`

**Deploy is automatic: pushing to `main` triggers GitHub Actions, which builds
and publishes to GitHub Pages.** See `.github/workflows/deploy.yml`. The job
runs `npm ci` → `npm run build` → `npm run generate-pdf` → upload `dist/` →
deploy to Pages.

- **To deploy: commit and `git push origin main`.** Then watch the run with
  `gh run watch` (or `gh run list`).
- **Do NOT use Netlify.** The site is no longer on Netlify; there is no
  `netlify` step, config, or `.netlify` directory. Don't run `netlify deploy`
  and don't re-introduce Netlify config or references.
- There is no separate "deploy" npm script; the Action is the deploy mechanism.

## Variants and their PDFs

Routes are matched in `src/Main.elm` (the `is<Variant>` predicates + the
dispatch `if/else` chain). Current EM cuts:

- `/em-hands-on` → `Em.Data.HandsOn` (player-coach framing)
- `/em-leader` → `Em.Data.Leader` (manager-first framing)

Each variant has a downloadable PDF, generated at build time by
`scripts/generate-pdf.js` (Puppeteer renders each route to A4). **Every route
must have an entry in that script's `variants` array, or its in-page "Download
PDF" link 404s on the deployed site.** The entry's `file` must exactly match
that variant's `pdfFileName` field in its `Data` module.

### Adding or changing a route

1. Add/keep the route in `src/Main.elm` (predicate + dispatch branch).
2. Set `pdfFileName` in the variant's `Data` module.
3. Add `{ path: "/your-route", file: "<same pdfFileName>" }` to the `variants`
   array in `scripts/generate-pdf.js`.
4. Build and verify (below), then push to `main`.

## Local commands

```
npm install
npm run dev            # vite dev server (default http://localhost:5173)
npm run build          # vite build → dist/ (also copies index.html → 404.html)
npm run generate-pdf   # render every variant in dist/ to PDF (needs a prior build)
npm test               # elm-test
npx elm make src/Main.elm --output=/dev/null   # fast type-check / compile
```

When checking pagination of the A4 variants, each `[data-class="page"]` sheet
is fixed-height with `overflow: hidden`; measure `scrollHeight - clientHeight`
per page (0 = fits, >0 = clipped).

## Dependencies

All deps are dev/build-time only — the deployed site is a compiled Elm static
bundle, so audit findings never reach production. Keep `npm audit` clean
anyway. Note the `cross-spawn` override in `package.json`: `vite-plugin-elm`
pulls `node-elm-compiler`, which still pins the vulnerable `cross-spawn@6.0.5`
(GHSA-3xgq-45jj-v275) with no upstream fix, so we force the API-compatible
`^7.0.6`. Don't remove the override unless `node-elm-compiler` ships a newer
`cross-spawn`. Toolchain: Vite 8 + `vite-plugin-elm` 3 (needs Node ≥ 20.19 /
22.12; CI runs Node 22).
