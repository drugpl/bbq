require 'bbq/util'

if defined?(Devise)
  module Bbq
    class TestUser
      include ActionView::Helpers::UrlHelper
      include Rails.application.routes.url_helpers

      def initialize(env, options={})
        super
        @email = options[:email] || next_email
        @password = options[:password] || next_password
        @scope = Devise.mappings.first.singular.to_s
      end

      def register
        @session.visit send("new_#{self.scope}_registration_path")
        @session.fill_in "Email", :with => @email
        @session.fill_in "Password", :with => @password
        @session.fill_in "Password confirmation", :with => @password
        @session.click_on "Sign up"
      end

      def login
        @session.visit send("new_#{self.scope}_session")
        @session.fill_in "Email", :with => @email
        @session.fill_in "Password", :with => @password
        @session.click_on "Sign in"
      end

      def logout
        @session.visit send("destroy_#{self.scope}_session")
      end

      def register_and_login
        register
      end

      protected
      def next_email
        "#{ActiveSupport::SecureRandom.hex(3)}@example.com"
      end

      def next_password
        "#{ActiveSupport::SecureRandom.hex(8)}"
      end
    end
  end
end
