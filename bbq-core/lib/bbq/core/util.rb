require 'active_support/core_ext/string/inflections'

module Bbq
  module Core
    class Util
      def self.find_module(name, scope = nil)
        namespace = case scope
        when String, Symbol
          "::#{scope.to_s.camelize}"
        when Class
          "::#{scope.name}"
        when NilClass
          nil
        else
          "::#{scope.class.name}"
        end
        "#{namespace}::#{name.to_s.camelize}".constantize
      end
    end
  end
end
