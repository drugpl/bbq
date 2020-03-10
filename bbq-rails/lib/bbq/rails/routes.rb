module Bbq
  module Rails
    module Routes
      def self.included(klass)
        klass.send(:include, ::ActionDispatch::Routing::UrlFor)
        klass.send(:include, ::Rails.application.routes.url_helpers)

        unless ::Rails.version < "3.1"
          klass.send(:include, ::ActionDispatch::Routing::RouteSet::MountedHelpers)
        end
      end
    end
  end
end
