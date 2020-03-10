module Bbq
  class TestGenerator < ::Rails::Generators::NamedBase
    hook_for :test_framework, :aliases => "-t", :as => "bbq_test"
  end
end
