require 'rails/railtie'
require 'bbq/core'

module Bbq
  module Rails
    class Railtie < ::Rails::Railtie

      initializer "bqq.set_app" do
        Bbq::Core.app = ::Rails.application
      end

    end
  end
end
