require 'bbq'

module Bbq
  class InstallGenerator < ::Rails::Generators::Base
    hook_for :test_framework, :aliases => "-t", :as => "bbq_install"
  end
end
