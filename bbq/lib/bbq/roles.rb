require 'bbq/util'

module Bbq
  module Roles
    def roles(*names)
      names.each do |name|
        module_obj = Bbq::Util.find_module(name, self)
        self.extend(module_obj)
      end
    end
  end
end
