Warning & disclaimer
====================

This gem is currently under development. We're targeting most popular use case - Rails. However the philosophy behind it is not limited to Rails nor web applications in general. There is even example usage with EventMachine. Feel free to modify it for your own needs.

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
* https://github.com/pawelpacana/eventmachine-bbq-example
* https://github.com/drugpl/drug-site

Installation
============

First, add BBQ to your apps Gemfile:

    ```ruby
    # Gemfile
    gem "bbq", :git => "git://github.com/drugpl/bbq.git"
    ```

Run install generator:

    rails generate bbq:install


Require BBQ in test/test_helper.rb:

    ```ruby
    require "bbq/test"
    ```

Feature generator
=================

    rails g bbq:test MyFeatureName

Examples
========

    ```ruby
    test "admin can browse all user tickets" do
      summaries = ["Forgot my password", "Page is not displayed correctly"]
      descriptions = ["I lost my yellow note with password under the table!",
                      "My IE renders crap instead of crispy fonts!"]

      alice = Roundtrip::TestUser.new
      alice.extend(Roundtrip::TestUser::TicketReporter)
      alice.register_and_login
      alice.open_ticket(summaries.first, descriptions.first)

      bob = Roundtrip::TestUser.new
      bob.extend(Roundtrip::TestUser::TicketReporter)
      bob.register_and_login
      bob.open_ticket(summaries.second, descriptions.second)

      bofh = Roundtrip::TestUser.new(:email => @admin.email)
      bofh.extend(Roundtrip::TestUser::TicketManager)
      bofh.login
      bofh.visit "/support/admin/tickets"
      assert bofh.see?(*summaries)
      bofh.click_on(summaries.second)
      assert bofh.see?(summaries.second, descriptions.second)
      assert bofh.not_see?(summaries.first, descriptions.first)
    end
    ```

Deal with Devise
================

    ```ruby
    require "bbq/test_user"
    require "bbq/devise"

    class TestUser < Bbq::TestUser
      include Bbq::SpicyDevise
    end
    ```

After that TestUser have *login*, *logout*, *register*, *register_and_login* methods.

    ```ruby
    test "user register with devise" do
      user = TestUser.new # or TestUser.new(:email => "email@example.com", :password => "secret")
      user.register_and_login
      user.see?("Stuff after auth")
    end
    ```


Development environment
=======================

    bundle install
    bundle exec rake test


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
* Piotr Niełacny (http://ruby-blog.pl)

Contributors
============

* Peter Suschlik (http://peter.suschlik.de)

Future plans
============

* Events (http://andrzejonsoftware.blogspot.com/2011/04/events-in-acceptance-tests.html)

License
=======

MIT License
