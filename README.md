### Introduction

This is the CV for Oliver Searle-Barnes, a full stack web developer.

It's written in Elm, a compile to javascript funtional language. Take a look at the rendered version at https://goo.gl/6v17iC.

### Getting started

```
$ npm install
$ npm run dev
```

### Deployment

Deploys run automatically on push to `main` via GitHub Actions
(`.github/workflows/deploy.yml`), which builds the app, generates a PDF per
variant (`npm run generate-pdf`), and publishes `dist/` to GitHub Pages. There
is no manual deploy step: **push to `main` to deploy.** (The project is no
longer hosted on Netlify.)

Each route is a CV variant; every route needs an entry in the `variants` array
in `scripts/generate-pdf.js` so its "Download PDF" link resolves. See
[CLAUDE.md](./CLAUDE.md) for details.
