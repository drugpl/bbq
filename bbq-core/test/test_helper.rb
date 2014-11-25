require 'minitest/autorun'
require 'capybara'

Capybara.register_driver :rack_test_the_other do |app|
  Capybara::RackTest::Driver.new(app)
end


