require 'spec_helper'
require 'bbq/rspec'

describe 'Bbq RSpec matchers' do

  specify 'see given string' do
    user = Bbq::TestUser.new
    user.visit('/test_page')

    expect { expect(user).to see('Pink') }.to_not raise_error
  end

  specify 'unable to see given string' do
    user = Bbq::TestUser.new
    user.visit('/test_page')

    expect { expect(user).to see('nothing to see') }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
  end

  specify 'see given string within scope' do
    user = Bbq::TestUser.new
    user.visit('/test_page')

    expect { expect(user).to see('Pink').within('#unicorns') }.to_not raise_error
  end

  specify 'unable to see given string within scope' do
    user = Bbq::TestUser.new
    user.visit('/test_page')

    expect { expect(user).to see('Violet').within('#unicorns') }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
  end

end
