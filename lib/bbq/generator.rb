module Bbq
  module Generator
    def self.included(base)
      base.source_root Bbq.root.join("lib/generators/bbq/templates")
      base.class_option :test_framework, :alias => "-t", :type => :string, :default => "test_unit", :desc => "Test framework to be invoked"
    end

    protected
    def test_framework_short
      case options.test_framework
      when :test_unit then 'test'
      end
    end

    def test_root
      "#{test_framework_short}/acceptance"
    end

    def support_root
      "#{test_root}/support"
    end
  end
end
