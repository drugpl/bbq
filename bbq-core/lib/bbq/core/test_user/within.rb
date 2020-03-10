require 'active_support/core_ext/array/extract_options'

module Bbq
  module Core
    class TestUser
      module Within
        METHODS_USING_WITHIN = [
          :see?, :not_see?,
          :attach_file, :check, :choose, :click_link_or_button, :click_button,
          :click_link, :click_on, :fill_in, :select, :uncheck, :unselect
        ]

        METHODS_USING_WITHIN.each do |method_name|
          class_eval <<-RUBY
            def #{method_name}(*args)
              using_within(args) { super }
            end
          RUBY
        end

        def using_within(args)
          options = args.extract_options!
          locator = options.delete(:within)
          args.push(options) unless options.empty?

          if locator
            within(locator) { yield }
          else
            yield
          end
        end
      end
    end
  end
end
