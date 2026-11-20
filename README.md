# Yuntao Li — Personal Website (`https://929937690.github.io`)

Academic homepage built on Jekyll with a custom **`studio` (`Hybrid BD-1`)** editorial layout and BibTeX-driven publications powered by `jekyll-scholar`.

`_bibliography/publications.bib` and `files/CV_YuntaoLi.pdf` are synced automatically from the private `929937690/cv-yuntaoli` repository via GitHub Actions — do not hand-edit them here.

## Repository Structure

| Path | Role |
| :--- | :--- |
| `_config.yml`, `_config_docker.yml` | Site configuration (`_config_docker.yml` overrides `url: ""` for local preview) |
| `_layouts/studio.html` | **Hybrid BD-1** layout: warm alabaster palette (`#FAF8F4`) + persisted dark mode (`#141413`), sticky glass navbar, portrait hero, flanked section bars, publication cards, and responsive styling |
| `_layouts/bib_entry.html` | Structured publication card template (`[1]..[n]` counter + venue badge gutter, serif title, bold `Y. Li` + `*` co-first authors, `DOI`/`Link`/`Code` pills, and inline BibTeX copy drawer) |
| `_plugins/scholar_extras.rb` | Ruby 3.4 compatibility patches for `bibtex-ruby` 4.4.7, `blind` double-anonymous entry filter, inline `%` comment stripper, stable tie-breaking sort, and structured card Liquid filters |
| `_pages/` | `about.md` (`/`), `publications.html` (`/publications/`), `teaching.html` (`/teaching/`), `cv.md` (`/cv/`), and `404.md` (`/404.html`) |
| `_bibliography/publications.bib` | Public bibliography synced from `cv-yuntaoli/publications.bib` (`blind` entries stripped) |
| `files/CV_YuntaoLi.pdf` | Public CV PDF synced from `cv-yuntaoli/main.pdf` |
| `images/` | Web-optimized Retina portrait (`profile.jpg`) and site favicons |
| `assets/`, `_sass/vendor/font-awesome/` | Self-hosted Font Awesome and Academicons stylesheets/fonts |

## Building Locally

Using the shared Ruby 3.4 launcher (`~/.local/bin/jekyll-env`, configured in `~/Documents/work/tools/jekyll/`):

```bash
jekyll-env bundle config set --local path 'vendor/bundle'
jekyll-env bundle install
jekyll-env bundle exec jekyll serve --config _config.yml,_config_docker.yml --port 8104
```

## Automated Deployment & Double-Blind Filtering (`.github/workflows/deploy.yml`)

GitHub Actions builds and deploys the site on pushes to `main`, manual `workflow_dispatch`, and daily at `06:00 UTC`:

1. Checks out `929937690/cv-yuntaoli` via `secrets.CV_REPO_DEPLOY_KEY`.
2. Strips any `@entry` tagged with `blind` in `keywords` when writing `_bibliography/publications.bib`, and copies `main.pdf` (the public CV edition) to `files/CV_YuntaoLi.pdf`.
3. Builds with Ruby `3.4` (`JEKYLL_ENV=production bundle exec jekyll build`) and deploys `_site` to GitHub Pages (`https://929937690.github.io`).
