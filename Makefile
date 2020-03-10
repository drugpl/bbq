UPSTREAM_REV = `git rev-parse upstream/master`
ORIGIN_REV   = `git rev-parse origin/master`
CURRENT_REV  = `git rev-parse HEAD`
BBQ_VERSION  ?= $(shell cat BBQ_VERSION)
NIX_TYPE     =  $(shell uname -s)
GEMS         = bbq \
               bbq-core \
               bbq-rspec \
               bbq-rails \
               bbq-devise

ifeq ($(NIX_TYPE),Linux)
  SED_OPTS = -i
endif

ifeq ($(NIX_TYPE),Darwin)
  SED_OPTS = -i ""
endif

$(addprefix install-, $(GEMS)):
	@make -C $(subst install-,,$@) install

$(addprefix reinstall-, $(GEMS)):
	@make -C $(subst reinstall-,,$@) reinstall

$(addprefix test-, $(GEMS)):
	@make -C $(subst test-,,$@) test

$(addprefix build-, $(GEMS)):
	@make -C $(subst build-,,$@) build

$(addprefix push-, $(GEMS)):
	@make -C $(subst push-,,$@) push

$(addprefix clean-, $(GEMS)):
	@make -C $(subst clean-,,$@) clean

git-check-clean:
	@git diff --quiet --exit-code

git-check-committed:
	@git diff-index --quiet --cached HEAD

git-tag:
	@git tag -m "Version v$(BBQ_VERSION)" v$(BBQ_VERSION)
	@git push origin master --tags

git-rebase-from-upstream:
	@git remote remove upstream > /dev/null 2>&1 || true
	@git remote add upstream git@github.com:RailsEventStore/rails_event_store.git
	@git fetch upstream master
	@git rebase upstream/master
	@git push origin master

set-version: git-check-clean git-check-committed
	@echo $(BBQ_VERSION) > BBQ_VERSION
	@find . -path ./contrib -prune -o -name version.rb -exec sed $(SED_OPTS) "s/\(VERSION = \)\(.*\)/\1\"$(BBQ_VERSION)\"/" {} \;
	@find . -path ./contrib -prune -o -name *.gemspec -exec sed $(SED_OPTS) "s/\(\"bbq-core\", \)\(.*\)/\1\"= $(BBQ_VERSION)\"/" {} \;
	@find . -path ./contrib -prune -o -name *.gemspec -exec sed $(SED_OPTS) "s/\(\"bbq-rspec\", \)\(.*\)/\1\"= $(BBQ_VERSION)\"/" {} \;
	@find . -path ./contrib -prune -o -name *.gemspec -exec sed $(SED_OPTS) "s/\(\"bbq-rails\", \)\(.*\)/\1\"= $(BBQ_VERSION)\"/" {} \;
	@find . -path ./contrib -prune -o -name *.gemspec -exec sed $(SED_OPTS) "s/\(\"bbq-devise\", \)\(.*\)/\1\"= $(BBQ_VERSION)\"/" {} \;
	@git add -A **/*.gemspec **/version.rb BBQ_VERSION
	@git commit -m "Version v$(BBQ_VERSION)"

install: $(addprefix install-, $(GEMS)) ## Install all dependencies

reinstall: $(addprefix reinstall-, $(GEMS)) ## Reinstall (with new resolve) dependencies

test: $(addprefix test-, $(GEMS)) ## Run all unit tests

build: $(addprefix build-, $(GEMS)) ## Build all gem packages

push: $(addprefix push-, $(GEMS)) ## Push all gem packages to RubyGems

clean: $(addprefix clean-, $(GEMS)) ## Remove all previously built packages

release: git-check-clean git-check-committed install test git-tag clean build push ## Make a new release on RubyGems
	@echo Released v$(BBQ_VERSION)

include support/make/help.mk
