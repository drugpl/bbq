if defined?(Devise)
  require 'securerandom'

  module Bbq
    module Devise

      attr_accessor :devise_authentication_key, :email, :password, :scope

      def initialize_devise
        unless @devise_initialized
          self.devise_authentication_key = ::Devise.authentication_keys.first
          self.email = options[devise_authentication_key.to_sym] || next_email
          self.password = options[:password] || next_password
          self.scope = ::Devise.mappings.first.second.singular.to_s
          @devise_initialized = true
        end
      end

      def register
        initialize_devise
        visit send("new_#{scope}_registration_path")
        fill_in "#{scope}_#{devise_authentication_key}", :with => @email
        fill_in "#{scope}_password", :with => @password
        fill_in "#{scope}_password_confirmation", :with => @password
        find(:xpath, "//input[@name='commit']").click
      end

      def login
        initialize_devise
        visit send("new_#{scope}_session_path")
        fill_in "#{scope}_#{devise_authentication_key}", :with => @email
        fill_in "#{scope}_password", :with => @password
        find(:xpath, "//input[@name='commit']").click
      end

      def logout
        visit send("destroy_#{scope}_session_path")
      end

      def register_and_login
        register
      end

      def next_email
        "#{SecureRandom.hex(3)}@example.com"
      end

      def next_password
        SecureRandom.hex(8)
      end
    end
  end
end
