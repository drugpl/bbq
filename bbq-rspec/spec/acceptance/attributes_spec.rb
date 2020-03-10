require 'spec_helper'

describe 'attributes' do

  specify 'acceptance type in spec/acceptance' do
    expect(RSpec.current_example.metadata[:type]).to eq(:acceptance)
  end

end
