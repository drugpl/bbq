require 'spec_helper'
require 'bbq/rspec'
require 'bbq/test_user'

feature 'bbq matchers' do
  scenario 'should see welcome text' do
    user = Bbq::TestUser.new
    user.visit "/miracle"
    expect { expect(user).to see("MIRACLE") }.not_to raise_error
    expect { expect(user).not_to see("MIRACLE") }.to raise_error(RSpec::Expectations::ExpectationNotMetError, /expected not to see "MIRACLE" in "MIRACLE"/)
    expect { expect(user).not_to see("BBQ") }.not_to raise_error
    expect { expect(user).to see("BBQ") }.to raise_error(RSpec::Expectations::ExpectationNotMetError, /expected to see "BBQ" in "MIRACLE"/)
  end

  scenario 'should allow to chain matcher with within scope' do
    user = Bbq::TestUser.new
    user.visit '/ponycorns'

    expect { expect(user).to see('Pink').within('#unicorns') }.not_to raise_error
    expect { expect(user).not_to see('Pink').within('#unicorns') }.to raise_error(RSpec::Expectations::ExpectationNotMetError, /expected not to see "Pink" in "Pink"/)
    expect { expect(user).not_to see('Violet').within('#unicorns') }.not_to raise_error
    expect { expect(user).to see('Violet').within('#unicorns') }.to raise_error(RSpec::Expectations::ExpectationNotMetError, /expected to see "Violet" in "Pink"/)
  end
end
