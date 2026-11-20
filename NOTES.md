# Yuntao Li — Personal Website (`Hybrid BD-1` + `jekyll-scholar`)

Academic homepage built on Jekyll with the custom **`studio` (`Hybrid BD-1`)** editorial layout and BibTeX-driven publications powered by `jekyll-scholar` from `_bibliography/publications.bib`.

The bib file is a verbatim copy of the canonical `cv-yuntaoli/publications.bib` — do not hand-edit it here; GitHub Actions syncs both `_bibliography/publications.bib` and `files/CV_YuntaoLi.pdf` automatically from `929937690/cv-yuntaoli`. Everything CV-specific (inline `%` comments, `presort`, `author+an`, `keywords`) is handled at build time.

## Architecture & Key Files

| File | Role |
|---|---|
| `Gemfile` | `github-pages` (Jekyll 3.10) + `gem 'jekyll-scholar'` (**5.16.0**) |
| `_config.yml` | Site metadata, `jekyll-scholar` plugin config (`sort_by: year,presort`, `order: descending,ascending`, `bibliography_template: bib_entry`) |
| `_layouts/studio.html` | Custom **Hybrid BD-1** layout: warm alabaster paper palette (`#FAF8F4`) + persisted dark mode (`#141413`), sticky glass navbar, portrait hero, flanked horizontal section bars mirroring the `CM-4` CV, structured publication card grid, software bento cards, and responsive layout |
| `_layouts/bib_entry.html` | Structured publication card template: venue badge + `[1]..[9]` counter gutter, serif title, `Tool Paper` chip, initials-first authors (`Y. Li` bolded + `*` co-first), venue/submission line, automatic `DOI`/`Link`/`Code` pills, and inline BibTeX drawer with one-click copy |
| `_plugins/scholar_extras.rb` | Ruby 3.4 patches for `bibtex-ruby` 4.4.7, inline `%` comment stripper, stable tie-breaking sort, and structured card Liquid filters (`scholar_venue_badge`, `scholar_card_authors`, `scholar_card_venue`, `scholar_clean_bibtex`, `scholar_is_flagship`) |
| `_pages/about.md` | Single-scroll homepage (`/`) with Hero, Recent News, Publications, Open-Source Tools, and Teaching & Academic Service |
| `_pages/publications.html`, `_pages/teaching.html`, `_pages/cv.md`, `_pages/404.md` | Dedicated subpages (`/publications/`, `/teaching/`, `/cv/`, `/404.html`) sharing `layout: studio` |
| `_bibliography/publications.bib` | Byte-identical copy of `cv-yuntaoli/publications.bib` |
| `files/CV_YuntaoLi.pdf` | Compiled `CM-4` CV PDF synced from `cv-yuntaoli/main.pdf` |
| `images/profile.jpg` | Web-optimized Retina portrait (`688×720`, ~55 KB) |

## How the requirements are implemented

### Grouped sections (journal / conference / submitted)
`_pages/about.md`, `_pages/publications.html`, and `_pages/cv.md` call the
`{% bibliography %}` tag three times with bibtex-ruby query filters on `keywords`:

```liquid
{% bibliography --query @*[keywords~=journal] %}
{% bibliography --query @*[keywords~=conference] %}
{% bibliography --query @*[keywords~=submitted] %}
```

(`~=` is a substring match, so `keywords = {conference,cofirst}` still matches
`conference`. Double-anonymous submissions tagged `keywords = {submitted,blind}`
in `cv-yuntaoli/publications.bib` are stripped automatically by `deploy.yml`
and `_plugins/scholar_extras.rb` so they never appear on the public website, and
the *In Submission* section auto-hides via `scholar_has_public_entries` whenever
zero non-blind submissions exist.)

### Sorting (newest first, CV hand-order within a year)
`scholar.sort_by: year,presort` with `order: descending,ascending`.
The two same-year journal papers are ordered by their `presort` values
(`mk` < `ml`). `jekyll-scholar`'s stock sort is *unstable* (`Array#sort`), so
`_plugins/scholar_extras.rb` overrides it with a stable sort falling back to
`.bib` file order for full ties — matching the CV order identically.

### Continuous `[1]..[9]` numbering & venue badges
CSS counters in `_layouts/studio.html` (`counter-reset: pubn` on `.s-pub-groups`,
`counter-increment: pubn` on `ol.bibliography > li`, and `.s-pub__gutter::before`)
render `[1]`..`[9]` continuously across all three groups. `scholar_venue_badge`
extracts parenthesized acronyms (`NAHS '25`, `CAV '25`, `HSCC '25`, `ATVA '26`, etc.)
and styles them by category (`journal` emerald, `conference` UF blue, `submitted` amber).

### Structured author, venue, and BibTeX filters
* `scholar_card_authors`: formats initials-first names (`Y. Li`, `S. W. Choi`,
  `H.-D. Tran`, `et al.`), wraps `Y. Li` in `<strong>`, and reads biblatex
  `author+an = {1=cofirst; 2=cofirst; 3=cofirst}` annotations to append `<sup>*</sup>`
  automatically.
* `scholar_card_venue`: renders italicized `journal` / `booktitle` + `note` + `year`.
* `scholar_clean_bibtex`: strips CV-only fields (`presort`, `keywords`, `author+an`)
  and inline `%` comments for the expandable `BibTeX` drawer + `Copy` button.
* `_layouts/bib_entry.html`: also emits `DOI ↗` and `Link ↗` pills automatically
  whenever `doi` or `url` is present on an entry.

## Compatibility patches (in `_plugins/scholar_extras.rb`)

jekyll-scholar 5.16.0 pins bibtex-ruby 4.4.7, which predates Ruby 3. Under
the vendored Ruby 3.4 two things break and are monkey-patched:

* `Proc.new` without a block (removed in Ruby 3.0) in
  `Bibliography#each`, `Entry#each/#convert`, `#each_entry`.
* Ruby 3.4 made `dup` an own-method of `String`, so bibtex-ruby's blanket
  `def_delegators :to_s, *String.instance_methods(false)` turned
  `BibTeX::Name#dup` into "return a plain String", breaking every author-name
  conversion. Restored to a real Struct copy.

Also patched: the canonical bib has trailing `% comments` *inside* entries
(the `presort = {mk},  % hand-order...` lines). bibtex-ruby's lexer chokes on
those and silently drops the entry, so the loader strips
`/^(.*\},?)[ \t]+%[^\n]*$/` before parsing — this keeps the bib copy
byte-identical to the CV source.

## Building locally

Using the shared Ruby 3.4 launcher (`jekyll-env`, configured in `tools/jekyll/`):

```bash
jekyll-env bundle config set --local path 'vendor/bundle'
jekyll-env bundle install                      # gems vendored in vendor/bundle
jekyll-env bundle exec jekyll serve --port 8104
```

## Deploying — GitHub Actions (`.github/workflows/deploy.yml`)

The default GitHub Pages builder runs Jekyll in `--safe` mode with a fixed
plugin whitelist. **jekyll-scholar is not on that whitelist**, and this site
additionally uses a custom `_plugins/` file — both are ignored/blocked by the
classic builder, so pushing to a plain Pages branch would produce a site with
an empty publications page.

Instead, `.github/workflows/deploy.yml` builds and publishes the site via
GitHub Actions (Repo → Settings → Pages → Source: **GitHub Actions**):

1. Runs on pushes to `main`, manual `workflow_dispatch`, and daily at `06:00 UTC`.
2. Checks out `929937690/cv-yuntaoli` via `secrets.CV_REPO_DEPLOY_KEY` and
   copies `publications.bib` → `_bibliography/publications.bib` and
   `main.pdf` → `files/CV_YuntaoLi.pdf`.
3. Builds with Ruby `3.4` (`JEKYLL_ENV=production bundle exec jekyll build`) and
   deploys `_site` to `https://929937690.github.io`.

Since Actions runs `bundle exec jekyll build` directly, `jekyll-scholar` and
`_plugins/scholar_extras.rb` work identically in CI and locally.

## Updating publications

Edit `cv-yuntaoli/publications.bib` (the single source of truth) and push to
`929937690/cv-yuntaoli`. The daily workflow (or clicking **Run workflow** on
`Build and deploy site`) syncs `_bibliography/publications.bib` and
`files/CV_YuntaoLi.pdf` automatically; re-copy them locally only when previewing
unpushed CV changes. Grouping (`keywords`), ordering (`year` + `presort`),
co-first stars (`author+an`), and notes all flow through automatically.
