Warning & disclaimer
====================

This gem is currently under development. We're targeting most popular use cases - Rails & Rack applications (ex. Sinatra). However the philosophy behind it is not limited to Rails nor web applications in general. There is even example usage with EventMachine. Feel free to modify it for your own needs.

[![Build Status](https://secure.travis-ci.org/drugpl/bbq.png)](http://travis-ci.org/drugpl/bbq)

BBQ
===

Object oriented acceptance testing using personas.

* Ruby
* OOP
* DCI (Data Context Interaction) - for roles/personas
* Test framework independent, based on Capybara
* Opinionated

Difference from Cucumber
========================

* No Gherkin
* Objects and methods instead of steps
* Easier code reuse
* No factories/fixtures

Example applications
====================

* https://github.com/pawelpacana/roundtrip

Related examples
================

* https://github.com/pawelpacana/eventmachine-bbq-example
* https://github.com/drugpl/drug-site

Installation
============

First, add BBQ to your apps Gemfile:

```ruby
# Gemfile
gem "bbq", "~> 0.0.2"
```

Run install generator:

```
rails generate bbq:install
```

Require BBQ in test/test_helper.rb (in case of Test::Unit):

```ruby
require "bbq/test"
```

Require BBQ in spec/spec_helper.rb (in case of RSpec):

```ruby
require "bbq/rspec"
```

Feature generator
=================

```
rails g bbq:test MyFeatureName
```

Running features
================

For Test::Unit flavour:

```
rake test:acceptance
```

For RSpec flavour:

```
spec:acceptance
```

Examples
========

```ruby
module Roundtrip
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

    alice = Roundtrip::TestUser.new
    alice.roles(:ticket_reporter)
    alice.register_and_login
    alice.open_ticket(summaries.first, descriptions.first)

    bob = Roundtrip::TestUser.new
    bob.roles(:ticket_reporter)
    bob.register_and_login
    bob.open_ticket(summaries.second, descriptions.second)

    charlie = Roundtrip::TestUser.new(:email => @email, :password => @password)
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

Rails' URL Helpers
================

Using url helpers from Rails in integration tests is not recommended.
Testing routes is part of integration test, so you should actually use only

```ruby
  visit '/'
```

in your integration test. Use links and buttons in order to get to other pages in your app.

If you really need url helpers in your test user, just include them in your TestUser class:

```ruby
require 'bbq/rails/routes'

module Roundtrip
  class TestUser < Bbq::TestUser
    include Bbq::Rails::Routes
  end
end
```
or just

```ruby
module Roundtrip
  class TestUser < Bbq::TestUser
    include ::ActionDispatch::Routing::UrlFor
    include ::Rails.application.routes.url_helpers
    include ::ActionDispatch::Routing::RouteSet::MountedHelpers unless ::Rails.version < "3.1"
  end
end
```

Deal with Devise
================

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

Caveats
=======

<h2>Timeout::Error</h2>

If you simulate multiple users in your tests and spawn multiple browsers with selenium it might
be a good idea to use `Mongrel` instead of `Webrick` to create application server.
We have experienced some problems with `Webrick` that lead to `Timeout::Error` exception
when user/browser that was inactive for some time (due to other users/browsers
activities) was requested to execute an action.

Put this code into a file loaded before running any acceptance scenario like:
`test/test_helper.rb` or `spec/spec_helper.rb`:

```ruby
Capybara.server do |app, port|
  require 'rack/handler/mongrel'
  Rack::Handler::Mongrel.run(app, :Port => port)
end
```

Add `mongrel` to your `Gemfile`:

```ruby
# In test group if you want it to
# be used only in tests and not in your development mode
# ex. when running 'rails s'
gem 'mongrel', "1.2.0.pre2", :require => false
```

Development environment
=======================

```
bundle install
bundle exec rake test
```

Additional information
======================

* 2 problems with Cucumber http://andrzejonsoftware.blogspot.com/2011/03/2-problems-with-cucumber.html
* Object oriented acceptance testing http://andrzejonsoftware.blogspot.com/2011/04/object-oriented-acceptance-testing.html
* Events in acceptance tests http://andrzejonsoftware.blogspot.com/2011/04/events-in-acceptance-tests.html

Maintainers
===========

* Paweł Pacana (http://github.com/pawelpacana)
* Andrzej Krzywda (http://andrzejkrzywda.com)
* Michał Łomnicki (http://mlomnicki.com)
* Robert Pankowecki (http://robert.pankowecki.pl)

Contributors
============

* Piotr Niełacny (http://ruby-blog.pl)
* Peter Suschlik (http://peter.suschlik.de)
* Jan Dudek (http://jandudek.com)

Future plans
============

* Events (http://andrzejonsoftware.blogspot.com/2011/04/events-in-acceptance-tests.html)

License
=======

MIT License
