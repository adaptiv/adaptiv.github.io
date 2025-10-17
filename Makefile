start:
	bundle exec jekyll serve --livereload --drafts

install:
	asdf install
	gem install bundler
	bundle install
