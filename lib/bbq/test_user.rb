require 'capybara/rails'
require 'bbq/util'

module Bbq
  class TestUser
    include ActionView::Helpers::UrlHelper
    include Rails.application.routes.url_helpers

    attr_reader :session, :env, :options

    def initialize(env, options = {})
      @driver  = options.delete(:driver) || Capybara.current_driver
      @session = Capybara::Session.new(@driver, Capybara.app)
      @env, @options = env, options
    end

    def roles(*names)
      names.each do |name|
        module_obj = Bbq::Util.find_module(name, self)
        self.extend(module_obj)
      end
    end

    Capybara::Session::DSL_METHODS.each do |method|
      class_eval <<-RUBY
        def #{method}(*args, &block)
          session.send(:#{method}, *args, &block)
        end
      RUBY
    end
  end
end
