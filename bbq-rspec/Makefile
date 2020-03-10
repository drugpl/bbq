GEM_VERSION = $(shell cat ../BBQ_VERSION)
GEM_NAME    = bbq-rspec
REQUIRE     = $(GEM_NAME)

include ../support/make/install.mk
include ../support/make/gem.mk
include ../support/make/help.mk

test: ## Run unit tests
	@echo "Running unit tests"
	@bundle exec rspec
