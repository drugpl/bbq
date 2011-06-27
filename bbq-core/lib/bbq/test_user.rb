require 'capybara/rails'
require 'capybara/dsl'
require 'bbq/util'

module Bbq
  
  class TestUser
    
    include ActionDispatch::Routing::UrlFor
    include Rails.application.routes.url_helpers
    include Capybara::DSL

    attr_reader :session, :env, :options

    def initialize(env, options = {})
      @current_driver = options.delete(:driver)
      @env, @options = env, options

      @@_callbacks.each do |callback|
        callback[:extension].send(callback[:method], self)
      end
    end

    def roles(*names)
      names.each do |name|
        module_obj = Bbq::Util.find_module(name, self)
        self.extend(module_obj)
      end
    end

    def self.add_callback(extension, method=:init)
      @@_callbacks ||= []
      @@_callbacks << {:extension => extension, :method => method}
    end

  end

end
