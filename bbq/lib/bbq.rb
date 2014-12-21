require 'bbq/core'
require 'bbq/rails' if defined?(::Rails)

module Bbq
  class << self

    def app
      Bbb::Core.app
    end

    def app=(value)
      Bbq::Core.app = value
    end

  end
end
