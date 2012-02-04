require 'capybara/dsl'

module Bbq
  class TestUser
    module CapybaraDsl
      ::Capybara::Session::DSL_METHODS.each do |method|
        class_eval <<-RUBY, __FILE__, __LINE__+1
          def #{method}(*args, &block)
            page.#{method}(*args, &block)
          end
        RUBY
      end
    end
  end
end
