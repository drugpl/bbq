if defined?(Devise)

  require 'bbq/test'

  module Bbq
    class TestUser

      attr_reader :devise_authentication_key, :email, :password, :scope

      def spicy_devise
        @devise_authentication_key = Devise.authentication_keys.first
        @email = options[@devise_authentication_key.to_sym] || next_email
        @password = options[:password] || next_password
        @scope = Devise.mappings.first.second.singular.to_s
      end

      def register
        @session.visit send("new_#{self.scope}_registration_path")
        @session.fill_in "#{self.scope}_#{self.devise_authentication_key}", :with => @email
        @session.fill_in "#{self.scope}_password", :with => @password
        @session.fill_in "#{self.scope}_password_confirmation", :with => @password
        @session.find(:xpath, "//input[@name='commit']").click
      end

      def login
        @session.visit send("new_#{self.scope}_session_path")
        @session.fill_in "#{self.scope}_#{self.devise_authentication_key}", :with => @email
        @session.fill_in "#{self.scope}_password", :with => @password
        @session.find(:xpath, "//input[@name='commit']").click
      end

      def logout
        @session.visit send("destroy_#{self.scope}_session_path")
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
