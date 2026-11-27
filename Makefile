help: ## List available targets
	@awk -F ':.*## ' '/^[a-zA-Z_-]+:.*## / {printf "%-10s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

start: ## Serve the site locally with livereload and drafts
	bundle exec jekyll serve --livereload --drafts

install: ## Install Ruby (asdf), bundler and gems
	asdf plugin add ruby
	asdf install
	gem install bundler
	bundle install
