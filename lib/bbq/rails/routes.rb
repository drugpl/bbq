module Bbq
  module Rails
    module Routes
      def self.included(klass)
        if Bbq.rails?
          klass.send(:include, ::ActionDispatch::Routing::UrlFor)
          klass.send(:include, ::Rails.application.routes.url_helpers)
          klass.send(:include, ::ActionDispatch::Routing::RouteSet::MountedHelpers) unless ::Rails.version < "3.1"
        end
      end
    end
  end
end
