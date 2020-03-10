require 'bbq/core/util'

module Bbq
  module Core
    module Roles
      def roles(*names)
        names.each do |name|
          module_obj = Bbq::Core::Util.find_module(name, self)
          self.extend(module_obj)
        end
      end
    end
  end
end
