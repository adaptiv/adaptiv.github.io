# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

The company website for Adaptiv Sthlm AB (https://adaptiv.se, see `CNAME`): a Jekyll site built on the Agency Bootstrap theme and published by GitHub Pages. Site content is in Swedish.

## Commands

```bash
make                 # list targets
make install         # asdf ruby plugin + Ruby from .tool-versions, bundler, gems
make start           # serve on http://localhost:4000 with livereload and drafts
bundle exec jekyll build   # one-off build into _site/ (gitignored)
```

There are no tests and no linter. Verify a change by building or serving the site and looking at the page.

Ruby is pinned to 3.3.6 in `.tool-versions` and `.ruby-version`. Run Bundler on that Ruby: on a newer system Ruby it drops the locked versions and resolves `github-pages` to an ancient release whose native extensions do not compile.

## Deployment

A push to `main` publishes the site. There is no workflow in `.github/`; GitHub Pages builds the branch itself with the `github-pages` gem, which is why that gem is in the `Gemfile`.

Jekyll publishes every file in the repo root that is not listed under `exclude` in `_config.yml`, and renders Markdown files as pages even without front matter. Add new non-site files (docs, scripts) to that list.

Custom plugins in `_plugins/` do not run in that build, nor locally under the `github-pages` gem. The live `style.css` contains the unconverted output of the `hex_to_rgb` filter (`rgba(62822d, .9)`), and the `localize` date filter is commented out in `_layouts/post.html`. Do not build features on `_plugins/` or `_locales/`.

## Structure

Pages are thin root files that only pick a layout; the content is in `_includes/`:

- `index.html` → `_layouts/index.html`, which stitches the start page from section includes (`services`, `team`, `about`, `contact`). The layout has no `{{ content }}`, so the body of `index.html` is never rendered.
- `sustainability.html` and `accounting.html` → a layout of the same name → the include of the same name.
- `posts.html` lists the articles and uses `_layouts/default.html`, as does `_layouts/post.html`.

`permalink: pretty` is set, so pages are served at `/posts/`, `/sustainability/` and `/accounting/`. The nav in `_includes/header.html` links to start page sections with `/#team` style anchors. `/accounting` is not in the nav; it is linked from `_includes/about.html`. `/posts` is not in the nav either, but is kept for links shared earlier; each article links back to it.

### Styling

`style.css` in the root is a stub with `layout: style`. The real stylesheet is assembled by `_layouts/style.css`, which inlines `_includes/css/bootstrap.min.css` and `_includes/css/agency.css` and then adds the site's own rules. Both `agency.css` and the layout are Liquid templates: colors and fonts come from `_data/template.yml` (hex codes without the leading `#`). Change a color there, not in the CSS.

Running text is 17px in the body color (`secondary-dark`), set once on `p` in `agency.css`. Put text and what belongs with it in a `<div class="text-column">` inside a `row`: it centers a column of about 70 characters per line and styles the `h2` subheadings in it. Do not put `text-muted` on body paragraphs; it is for subheadings and meta lines. Short captions in narrow columns (team, services) are 16px.

### Content

- Team members are the `people` list in `_config.yml`; `pic: N` maps to `img/team/N.jpg`. Changes to `_config.yml` need a restart of `make start`.
- Articles are Markdown files in `_posts/` named `YYYY-MM-DD-title.md` with front matter `layout: post`, `title` and `author`. The date comes from the filename. Unfinished articles go in `_drafts/` without a date.
- A new quarterly report is a PDF in `assets/pdf/accounting/`, a new `<li>` at the top of the list in `_includes/accounting.html`, and a new entry in `_data/accounting.yml` with the sums from the report's "Period" column. The list and the data hold the eight latest quarters only; older PDFs stay in the folder without a link. The charts on `/accounting/` are drawn from the data file with Liquid and CSS, without JavaScript. The skill `add-quarterly-report` in `.claude/skills/` reads the PDFs in the folder, updates the data and the list, and checks the figures. Climate reports are in `assets/pdf/` and linked from `_includes/sustainability.html`.

## Leftovers from the theme

`mail/contact_me.php`, `js/contact_me.js` and `js/jqBootstrapValidation.js` belong to the theme's contact form. The contact section has no form, and GitHub Pages does not run PHP. The `#portfolio` rules in `agency.css` have no matching section either.
