require 'spec_helper'

describe 'Capybara RSpec matchers' do

  specify 'matchers are included in TestUser' do
    user = Bbq::Core::TestUser.new
    user.visit('/test_page')

    expect { expect(user).to have_no_content('Capybara') }.not_to raise_error
  end

end
