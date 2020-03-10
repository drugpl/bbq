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
            @actual = page_fragment(actor)
            @actual.has_text?(text)
          end

          def does_not_match?(actor)
            @actual = page_fragment(actor)
            @actual.has_no_text?(text)
          end

          def failure_message_for_should
            "expected to see \"#{text}\" in #{format(@actual.text)}"
          end
          alias :failure_message :failure_message_for_should

          def failure_message_for_should_not
            "expected not to see \"#{text}\" in #{format(@actual.text)}"
          end
          alias :failure_message_when_negated :failure_message_for_should_not

          def within(scope)
            @scope = scope
            self
          end

          private
          def page_fragment(actor)
            if scope
              actor.page.first(*scope)
            else
              actor.page
            end
          end

          def format(text)
            case text
              when Regexp
                text.inspect
              else
                text.to_s.gsub(/[[:space:]]+/, ' ').strip.inspect
            end
          end
        end

        def see(text)
          Matcher.new(text)
        end
      end
    end
  end
end
