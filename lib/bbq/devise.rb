require 'bbq/util'

if defined?(Devise)
  module Bbq
    class TestUser

      def initialize(env, options={})
        super
        @devise_authentication_key = Devise.authentication_keys.first
        @email = options[@devise_authentication_key.to_sym] || next_email
        @password = options[:password] || next_password
        @scope = Devise.mappings.first.singular.to_s
      end

      def register
        @session.visit send("new_#{self.scope}_registration_path")
        @session.fill_in "#{self.scope}_#{self.devise_authentication_key}", :with => @email
        @session.fill_in "#{self.scope}_password", :with => @password
        @session.fill_in "#{self.scope}_password_confirmation", :with => @password
        @session.click_on "#{self.scope}_submit"
      end

      def login
        @session.visit send("new_#{self.scope}_session")
        @session.fill_in "#{self.scope}_#{self.devise_authentication_key}", :with => @email
        @session.fill_in "#{self.scope}_password", :with => @password
        @session.click_on "#{self.scope}_submit"
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
