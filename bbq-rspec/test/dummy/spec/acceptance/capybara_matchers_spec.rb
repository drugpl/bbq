require 'spec_helper'
require 'bbq/rspec'
require 'bbq/test_user'

feature 'capybara matchers' do
  scenario 'should see welcome text' do
    user = Bbq::TestUser.new
    user.visit "/miracle"
    expect(user.page).to have_content("MIRACLE")
    expect(user).to have_no_content("BBQ")
  end
end
