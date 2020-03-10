require 'spec_helper'

class TestUserWithMatchers < Bbq::Core::TestUser
  def ensure_no_red_ponycorns
    expect(self).to have_no_content('Red')
  end

  def ensure_pink_ponycorns
    expect(self).to see('Pink').within('#unicorns')
  end
end

describe 'TestUser matchers' do

  specify 'capybara matcher' do
    user = TestUserWithMatchers.new
    user.visit('/test_page')

    expect { user.ensure_no_red_ponycorns }.not_to raise_error
  end

  specify 'bbq matcher' do
    user = TestUserWithMatchers.new
    user.visit('/test_page')

    expect { user.ensure_pink_ponycorns }.not_to raise_error
  end

end
