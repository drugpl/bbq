module BeforeAfterInit

	module InstanceMethods
		def before_initialize(*a, &b) end
    def after_initialize(*a, &b) end
  end

  module ClassMethods
  	def before &b
    	define_method 'before_initialize', &b
      private 'before_initialize'
    end

    def after &b
    	define_method 'after_initialize', &b
      private 'after_initialize'
    end

    def new(*a, &b)
    	(obj = allocate).instance_eval{
      	before_initialize
        initialize *a, &b
        after_initialize
        self
    	}
    end
	end

  def self.included other
    other.module_eval{ include InstanceMethods }
    other.extend ClassMethods
    super
  end
end
