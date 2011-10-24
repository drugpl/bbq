require 'capybara/rails' if Bbq.rails?
require 'capybara/dsl'
require 'securerandom'
require 'bbq/util'
require 'bbq/test_user/eyes'
require 'bbq/test_user/within'

module Bbq
  class TestUser
    include Capybara::DSL
    include Bbq::TestUser::Eyes
    include Bbq::TestUser::Within

    attr_reader :options

    def initialize(options = {})
      @session_name = options.delete(:session_name)
      @current_driver = options.delete(:driver)
      @options = options
    end

    def page
      Capybara.using_driver(current_driver) do
        Capybara.using_session(session_name) do
          Capybara.current_session
        end
      end
    end

    # Discuss: Shall we freeze ?
    def session_name
      @session_name ||= SecureRandom.hex(8)
    end

    # Discuss: Shall we freeze ?
    def current_driver
      @current_driver
    end

    def roles(*names)
      names.each do |name|
        module_obj = Bbq::Util.find_module(name, self)
        self.extend(module_obj)
      end
    end
  end
end
