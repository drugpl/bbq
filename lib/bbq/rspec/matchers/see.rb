require 'capybara/helpers'

module Bbq
  module RSpec
    module Matchers
      module See
        class Matcher
          attr_reader :text, :scope

          def initialize(text)
            @text = text
            @scope = nil
          end

          def description
            if scope
              "see #{text} within #{scope}"
            else
              "see #{text}"
            end
          end

          def matches?(actor)
            @actual = extract_page_text(actor)
            @actual.has_text?(text)
          end

          def does_not_match?(actor)
            @actual = extract_page_text(actor)
            @actual.has_no_text?(text)
          end

          def failure_message_for_should
            "expected to see \"#{text}\" in #{format(@actual.text)}"
          end

          def failure_message_for_should_not
            "expected not to see \"#{text}\" in #{format(@actual.text)}"
          end

          def within(scope)
            @scope = scope
            self
          end

          def in_table_row(text)
            @scope = ["tr", :text => text]
            self
          end

          private
          def extract_page_text(actor)
            if scope
              actor.page.first(*scope)
            else
              actor.page
            end
          end

          def format(text)
            text = Capybara::Helpers.normalize_whitespace(text) unless text.is_a?(Regexp)
            text.inspect
          end
        end

        def see(text)
          Matcher.new(text)
        end
      end
    end
  end
end
