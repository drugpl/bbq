if defined?(Devise)

  require 'bbq/test'

  module Bbq
    module SpicyDevise

      attr_accessor :devise_authentication_key, :email, :password, :scope

      def self.included(other)
        other.add_callback(self)
      end

      def self.init(user)
        user.devise_authentication_key = Devise.authentication_keys.first
        user.email = user.options[user.devise_authentication_key.to_sym] || next_email
        user.password = user.options[:password] || next_password
        user.scope = Devise.mappings.first.second.singular.to_s
      end

      def register
        visit send("new_#{self.scope}_registration_path")
        fill_in "#{self.scope}_#{self.devise_authentication_key}", :with => @email
        fill_in "#{self.scope}_password", :with => @password
        fill_in "#{self.scope}_password_confirmation", :with => @password
        find(:xpath, "//input[@name='commit']").click
      end

      def login
        visit send("new_#{self.scope}_session_path")
        fill_in "#{self.scope}_#{self.devise_authentication_key}", :with => @email
        fill_in "#{self.scope}_password", :with => @password
        find(:xpath, "//input[@name='commit']").click
      end

      def logout
        visit send("destroy_#{self.scope}_session_path")
      end

      def register_and_login
        register
      end

      def self.next_email
        "#{ActiveSupport::SecureRandom.hex(3)}@example.com"
      end

      def self.next_password
        ActiveSupport::SecureRandom.hex(8)
      end
    end
  end
end
