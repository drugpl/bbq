# Bbq::Rails

[![Build Status](https://secure.travis-ci.org/drugpl/bbq-rails.png)](http://travis-ci.org/drugpl/bbq-rails) [![Dependency Status](https://gemnasium.com/drugpl/bbq-rails.png)](https://gemnasium.com/drugpl/bbq-rails) [![Code Climate](https://codeclimate.com/github/drugpl/bbq-rails.png)](https://codeclimate.com/github/drugpl/bbq-rails) [![Gem Version](https://badge.fury.io/rb/bbq-rails.png)](http://badge.fury.io/rb/bbq-rails)

## Quick start

Add following to your Gemfile:

```ruby
gem 'bbq-rails', require: 'bbq/rails'

```

You may also run `rails generate bbq:install` to have a basic configuration generated.

## Features

### Test integration

Your Rails application hooks up to `Bbq::Core.app` in tests automatically. Thus `Bbq::Core::TestUser` and `Bbq::Core::TestClient` can run against it.

### Generators

Generators help you kickstart Bbq test environment.

At the begging of your journey with Bbq you can use `rails generate bbq:install`. It'll create directory for acceptance test files and give you basic TestUser class for customization.

There's also `rails generate bbq:test` which creates new test files for you which have Bbq goodies baked (DSL and test actor session pool handling).

### Rake integration

Provided you've created `spec/acceptance` or `test/acceptance` directory, there we'll be following tasks for running acceptance tests available: `bundle exec rake spec:acceptance` or `bundle exec rake test:acceptance` respectively.

### Routes

When you require 'bbq/rails/routes' you can then `include Bbq::Rails::Routes` in TestActor to have access to Rails url helpers. While convenient it's not recommended in general. Testing routes is part of acceptance test. Use links and buttons in order to get to other pages in your app.

```ruby
require 'bbq/rails/routes'

class TestUser < Bbq::TestUser
  include Bbq::Rails::Routes
end
```

## Development

We develop and test against multiple Rails versions. When working with legacy software a test toolkit should be the last to require special attention.

```sh
for gemfile in `ls Gemfile* | grep -v lock`; do
  BUNDLE_GEMFILE=$gemfile bundle install
  BUNDLE_GEMFILE=$gemfile bundle exec rake test
done
