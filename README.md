# BBQ

[![Build Status](https://secure.travis-ci.org/drugpl/bbq.png)](http://travis-ci.org/drugpl/bbq) [![Dependency Status](https://gemnasium.com/drugpl/bbq.png)](https://gemnasium.com/drugpl/bbq) [![Code Climate](https://codeclimate.com/github/drugpl/bbq.png)](https://codeclimate.com/github/drugpl/bbq) [![Gem Version](https://badge.fury.io/rb/bbq.png)](http://badge.fury.io/rb/bbq) 

Object oriented acceptance testing using personas.

* Ruby (no Gherkin)
* Objects and methods instead of steps
* Test framework independent (RSpec and Test::Unit support)
* Thins based on Capybara.
* DCI (Data Context Interaction) for roles/personas
* Opinionated

## Setup

First, add BBQ to your apps `Gemfile`:

```ruby
gem "bbq", "0.2.0"
```

Run install generator:

```
bundle exec rails generate bbq:install
```

Require BBQ in test/test_helper.rb (in case of Test::Unit):

```ruby
require "bbq/test_unit"
```

Require BBQ in spec/spec_helper.rb (in case of RSpec):

```ruby
require "bbq/rspec"
```

## Feature generator

```
bundle exec rails g bbq:test MyFeatureName
```

## Running features

For Test::Unit flavour:

```
bundle exec rake test:acceptance
```

For RSpec flavour:

```
bundle exec rake spec:acceptance
```

## Examples

### Roles and Devise integration

```ruby
class TestUser < Bbq::TestUser
  include Bbq::Devise

  def update_ticket(summary, comment)
    show_ticket(summary)
    fill_in  "Comment", :with => comment
    click_on "Add update"
  end

  def open_application
    visit '/'
  end

  module TicketReporter
    def open_tickets_listing
      open_application
      click_link 'Tickets'
    end

    def open_ticket(summary, description)
      open_tickets_listing
      click_on "Open a new ticket"
      fill_in  "Summary", :with => summary
      fill_in  "Description", :with => description
      click_on "Open ticket"
    end

    def show_ticket(summary)
      open_tickets_listing
      click_on summary
    end
  end

  module TicketManager
    def open_administration
      visit '/admin'
    end

    def open_tickets_listing
      open_administration
      click_link 'Tickets'
    end

    def close_ticket(summary, comment = nil)
      open_tickets_listing
      click_on summary
      fill_in  "Comment", :with => comment if comment
      click_on "Close ticket"
    end

    def show_ticket(summary)
      open_tickets_listing
      click_on summary
    end
  end
end
```

```ruby
class AdminTicketsTest < Bbq::TestCase
  background do
    admin = Factory(:admin)
    @email, @password = admin.email, admin.password
  end

  scenario "admin can browse all user tickets" do
    summaries    = ["Forgot my password", "Page is not displayed correctly"]
    descriptions = ["I lost my yellow note with password under the table!",
                    "My IE renders crap instead of crispy fonts!"]

    alice = TestUser.new
    alice.roles(:ticket_reporter)
    alice.register_and_login
    alice.open_ticket(summaries.first, descriptions.first)

    bob = TestUser.new
    bob.roles(:ticket_reporter)
    bob.register_and_login
    bob.open_ticket(summaries.second, descriptions.second)

    charlie = TestUser.new(:email => @email, :password => @password)
    charlie.login # charlie was already "registered" in factory as admin
    charlie.roles(:ticket_manager)
    charlie.open_tickets_listing
    charlie.see!(*summaries)

    charlie.click_on(summaries.second)
    charlie.see!(summaries.second, descriptions.second)
    charlie.not_see!(summaries.first, descriptions.first)
  end
end
```

### RSpec integration

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

    ef within_widget(&block)
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
      user.see!("Thanks!")
    end
  end
end
```

## Testing REST APIs

Bbq provides `Bbq::TestClient`, similar to `Bbq::TestUser`, but intended for testing APIs.
It's a thin wrapper around `Rack::Test` which allows you to send requests and run assertions
against responses.

```ruby
class ApiTest < Bbq::TestCase
  background do
    headers = {'HTTP_ACCEPT' => 'application/json'}
    @client = TestClient.new(:headers => headers)
  end

  scenario "admin can browse all user tickets" do
    @client.get "/unicorn" do |response|
      assert_equal 200, response.status
      assert_equal "pink", response.body["unicorn"]["color"]
    end
    @client.post "/ponies", { :name => "Miracle" } do |response|
      assert_equal 200, response.status
    end
  end
end
```

## Rails URL Helpers

Using url helpers from Rails in integration tests is not recommended.
Testing routes is part of integration test, so you should actually use only

```ruby
  visit '/'
```

in your integration test. Use links and buttons in order to get to other pages in your app.

If you really need url helpers in your test user, just include them in your TestUser class:

```ruby
require 'bbq/rails/routes'

class TestUser < Bbq::TestUser
  include Bbq::Rails::Routes
end
```
or just

```ruby
class TestUser < Bbq::TestUser
  include ::ActionDispatch::Routing::UrlFor
  include ::Rails.application.routes.url_helpers
  include ::ActionDispatch::Routing::RouteSet::MountedHelpers unless ::Rails.version < "3.1"
end
```

## Devise support

```ruby
require "bbq/test_user"
require "bbq/devise"

class TestUser < Bbq::TestUser
  include Bbq::Devise
end
```

After that TestUser have *login*, *logout*, *register*, *register_and_login* methods.

```ruby
test "user register with devise" do
  user = TestUser.new # or TestUser.new(:email => "email@example.com", :password => "secret")
  user.register_and_login
  user.see!("Stuff after auth")
end
```

## Caveats

### Timeout::Error

If you simulate multiple users in your tests and spawn multiple browsers with selenium it might
be a good idea to use Thin instead of Webrick to create application server.
We have experienced some problems with Webrick that lead to `Timeout::Error` exception
when user/browser that was inactive for some time (due to other users/browsers
activities) was requested to execute an action.

Capybara will use Thin instead of Webrick when it's available, so you only need to add Thin to you Gemfile:

```ruby
# In test group if you want it to
# be used only in tests and not in your development mode
# ex. when running 'rails s'

gem 'thin', :require => false
```

## Additional information

* [2 problems with Cucumber](http://andrzejonsoftware.blogspot.com/2011/03/2-problems-with-cucumber.html)
* [Object oriented acceptance testing](http://andrzejonsoftware.blogspot.com/2011/04/object-oriented-acceptance-testing.html)

