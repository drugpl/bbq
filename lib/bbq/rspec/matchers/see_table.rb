require 'capybara/helpers'

module Bbq
  module RSpec
    module Matchers
      module SeeTable
        class Matcher
          attr_reader :selector, :table, :scope

          def initialize(selector)
            @selector = selector
            @scope = nil
          end

          def with_content(table)
            @table = table
            self
          end

          def in_header
            @scope = "thead"
            self
          end

          def in_footer
            @scope = "tfoot"
            self
          end

          def in_body
            @scope = "tbody"
            self
          end

          def matches?(actor)
            check_required_input
            @html_table = extract_table(actor)
            @html_table == table
          end

          def does_not_match?(actor)
            check_required_input
            @html_table = extract_table(actor)
            @html_table != table
          end

          def failure_message_for_should
            "expected to see table within #{selector} with content #{table.inspect}, but got #{@html_table.inspect}".tap do |message|
              case scope
                when "thead" then message << " in table header"
                when "tfoot" then message << " in table footer"
                when "tbody" then message << " in table body"
              end
            end
          end

          def failure_message_for_should_not
            "expected not to see table within #{selector} with content #{table.inspect}".tap do |message|
              case scope
                when "thead" then message << " in table header"
                when "tfoot" then message << " in table footer"
                when "tbody" then message << " in table body"
              end
            end
          end

          private
          def extract_table(actor)
            rows = if scope
              actor.page.find(selector).find(scope).all('tr')
            else
              actor.page.find(selector).all('tr')
            end
            rows.map do |row|
              row.all('th, td').map do |cell|
                Capybara::Helpers.normalize_whitespace(cell.text)
              end
            end
          end

          def check_required_input
            unless table
              raise ArgumentError.new("You must set an expected value for table content using #with_content: see_table(\"#{selector}\").with_content([[]])")
            end
          end
        end

        def see_table(selector)
          Matcher.new(selector)
        end

        def see_table_with_content(selector, table)
          Matcher.new(selector).with_content(table)
        end
      end
    end
  end
end
