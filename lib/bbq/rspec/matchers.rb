require 'bbq/rspec/matchers/see'
require 'bbq/rspec/matchers/see_table'

module Bbq
  module RSpec
    module Matchers
      include See
      include SeeTable
    end
  end
end
