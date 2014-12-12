# Bbq-rspec

[![Build Status](https://secure.travis-ci.org/drugpl/bbq-rspec.png)](http://travis-ci.org/drugpl/bbq-rspec) [![Dependency Status](https://gemnasium.com/drugpl/bbq-rspec.png)](https://gemnasium.com/drugpl/bbq-rspec) [![Code Climate](https://codeclimate.com/github/drugpl/bbq-rspec.png)](https://codeclimate.com/github/drugpl/bbq-rspec) [![Gem Version](https://badge.fury.io/rb/bbq-rspec.png)](http://badge.fury.io/rb/bbq-rspec)


RSpec integration for object oriented acceptance testing with [bbq](https://github.com/drugpl/bbq).

## Setup

Add `bbq-rspec` to your `Gemfile`:

```ruby
gem "bbq-rspec"
```

Run install generator:

```
bundle exec rails generate bbq:install
```

Require BBQ in spec/spec_helper.rb:

```ruby
require "bbq/rspec"
```

## Feature generator

```
bundle exec rails g bbq:test MyFeatureName
```

## Running features

```
bundle exec rake spec:acceptance
```

## Examples

```ruby
class TestUser < Bbq::TestUser
  def email
    @options[:email] || "buyer@example.com"
  end

  module Buyer
    def ask_question(question)
      fill_in "question", :with => question
      fill_in "email", :with => email
      click_on("Ask")
    end

    def go_to_page_and_open_widget(page_url, &block)
      go_to_page(page_url)
      open_widget &block
    end

    def go_to_page(page_url)
      visit page_url
      wait_until { page.find("iframe") }
    end

    def open_widget
      within_widget do
        page.find("#widget h3").click
        yield if block_given?
      end
    end

    def within_widget(&block)
      within_frame(widget_frame, &block)
    end

    def widget_frame
      page.evaluate_script("document.getElementsByTagName('iframe')[0].id")
    end
  end
end
```

```ruby
feature "ask question widget" do
  let(:user) {
    user = TestUser.new(:driver => :webkit)
    user.roles('buyer')
    user
  }

  scenario "as a guest user, I should be able to ask a question" do
    user.go_to_page_and_open_widget("/widget") do
      user.ask_question "my question"
      expect(user).to see("Thanks!")
    end
  end
end
```

## Contributing

1. Fork it ( https://github.com/drugpl/bbq-rspec/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
