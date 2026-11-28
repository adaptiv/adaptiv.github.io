# Web site for Adaptiv Sthlm AB

## Jekyll

This site is based on the [Jekyll](https://jekyllrb.com/) static site generator.
Jekyll uses the [Liquid](https://shopify.github.io/liquid/) template language.

## Agency

We use the Agency theme based on [Agency bootstrap theme](https://startbootstrap.com/template-overviews/agency/)

## GitHub Pages

We host our repo on GitHub and publish the site on [GitHub Pages](https://docs.github.com/en/pages).

## How to use

### Start

The index.html is the start page. It uses its own layout, which includes the sections.
It contains sections on our offerings, the team, about Adaptiv, and contact information.

### Articles

Articles and blog posts is on a separate page. Posts are written in
[Markdown](https://www.markdownguide.org/) and placed in the _posts directory.

Articles are listed on the 'posts.html' page.

Individual articles use the 'post.html' layout.

### Sustainability

Sustainability is a separate page. Content is found in '_includes/sustainability.html'.

### Team

Team members and info are in global configuration file '_config.yml'

Images are in '/img/team/'

## Run locally

- [asdf](https://asdf-vm.com/) (`brew install asdf`)

Run:

```bash
make install
make start
```

Browse to http://localhost:4000

## Trouble shooting

https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/testing-your-github-pages-site-locally-with-jekyll

First, check that your Ruby is the version listed in .ruby-version:

```bash
ruby -v
```

If it is not, run `asdf install` and try again. On a newer Ruby, `bundle install`
drops the locked versions, resolves `github-pages` to an ancient release and fails
on its native extensions. Removing the Gemfile.lock there makes the install pass,
but with an older `github-pages` than the locked one, so fix the Ruby version instead.

If the version is right, remove the Gemfile.lock and regenerate the gems:

```bash
rm Gemfile.lock
bundle install
```

Next step, clean out the Ruby environment:

```bash
# Remove all installed gems
gem uninstall --all --ignore-dependencies --executables

# Uninstall the current Ruby version
asdf uninstall ruby <version>

# Clear gem cache
gem cleanup

# Reinstall Ruby
asdf install ruby <version>

# Reinstall Bundler
gem install bundler

# Install gems
bundle install

# Run site
make start
```
