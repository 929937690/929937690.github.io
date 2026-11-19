# academicpages + jekyll-scholar (BibTeX-driven publications)

Prototype: the academicpages theme, but with the Publications page generated
from `_bibliography/publications.bib` (al-folio style) instead of the
`_publications/` markdown collection.

The bib file is a verbatim copy of the canonical
`cv-yuntaoli/publications.bib` — do not hand-edit it here; re-copy it from the
CV repo when it changes. Everything CV-specific (comments, `presort`,
`author+an`) is handled at build time.

## What was added / changed

| File | Change |
|---|---|
| `Gemfile` | added `gem 'jekyll-scholar'` (resolves to **5.16.0**, the last line compatible with the `github-pages` gem's Jekyll 3.10) |
| `_config.yml` | added `jekyll-scholar` to `plugins`/`whitelist`; new `scholar:` block (IEEE style, `source: ./_bibliography`, `sort_by: year,presort`, `order: descending,ascending`, template `bib_entry`); removed the `publications` collection, its `defaults` scope and `publication_category` |
| `_bibliography/publications.bib` | byte-identical copy of the canonical CV bib (9 entries) |
| `_layouts/bib_entry.html` | per-entry template: `{{ reference | scholar_strip_number | scholar_cofirst: key | scholar_bold_author }}` + italic `{{ entry.note }}` |
| `_plugins/scholar_extras.rb` | all the custom logic (see below) |
| `_pages/publications.html` | rewritten: legend + three `{% bibliography --query ... %}` groups + CSS-counter numbering |
| `_pages/cv.md` | publications section now uses `{% bibliography %}` instead of the removed collection |
| `_publications/` | deleted (no duplicate content) |

## How the requirements are implemented

### Grouped sections (journal / conference / submitted)
`_pages/publications.html` calls the `{% bibliography %}` tag three times with
bibtex-ruby query filters on the `keywords` field:

```liquid
{% bibliography --query @*[keywords~=journal] %}
{% bibliography --query @*[keywords~=conference] %}
{% bibliography --query @*[keywords~=submitted] %}
```

(`~=` is a substring match, so `keywords = {conference,cofirst}` still matches
`conference`.)

### Sorting (newest first, CV hand-order within a year)
`scholar.sort_by: year,presort` with `order: descending,ascending`.
The two same-year journal papers are ordered by their `presort` values
(`mk` < `ml`). jekyll-scholar's stock sort is *unstable* (plain `Array#sort`),
so `_plugins/scholar_extras.rb` overrides it with a stable sort that falls
back to .bib file order for full ties — exactly the CV order.

### Continuous [1]..[9] numbering
The IEEE CSL style emits its own `[n]` prefix, but it restarts at `[1]` for
every `{% bibliography %}` tag. So:

1. the `scholar_strip_number` Liquid filter removes the CSL-emitted `[n]`, and
2. CSS counters in `_pages/publications.html` draw `[1]`..`[9]` continuously
   across all three groups (`counter-reset` on the `.pub-groups` wrapper,
   `counter-increment` + `li::before` on each entry).

Adding/removing entries automatically renumbers everything; nothing is
hardcoded.

### Bold "Y. Li"
`scholar_bold_author` filter (in `_plugins/scholar_extras.rb`) wraps every
rendering of the name (`Yuntao Li`, `Li, Yuntao`, `Y. Li`, `Li, Y.`) in
`<strong>`. The bib file is untouched.

### Co-first `*` superscripts (StarV entry)
The biblatex annotation `author+an = {1=cofirst; 2=cofirst; 3=cofirst}` is
read by the `scholar_cofirst` Liquid filter **from the raw .bib text** (regex
on the `@entry{...}` block — bibtex-ruby parses the field but it is awkward to
reach through Liquid). The filter resolves annotated indices to family names
from the `author` field and appends `<sup>*</sup>` to the first occurrence of
each in the rendered reference → `H.-D. Tran*, S. W. Choi*, Y. Li*`.
The legend `"*" indicates co-first authors` sits at the top of the page.
Any future entry with an `author+an = {N=cofirst}` annotation gets stars
automatically.

### Italic notes
`_layouts/bib_entry.html` appends `<em>{{ entry.note }}.</em>` whenever an
entry has a `note` field — the three ATVA submissions get
*Submitted to ... (ATVA).* and the ICFEM paper gets *Submitted.*

### Author name format
CSL style `ieee` renders initials-first names (`Y. Li`, `S. W. Choi`,
`H.-D. Tran`) exactly like the CV. `and others` is post-processed to
`et al.`. One quirk: IEEE's CSL only prints a conference `booktitle` when
pages/editors are present, so `_plugins/scholar_extras.rb` remaps
`paper-conference` → `chapter` in `to_citeproc`, giving the CV-style
`"Title," in <i>Booktitle</i>, year.`

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
