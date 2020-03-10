module Bbq
  module Core
    class TestUser
      module Eyes
        def see?(*args)
          args.all? { |arg| has_content?(arg) }
        end

        def not_see?(*args)
          args.all? { |arg| has_no_content?(arg) }
        end
      end
    end
  end
end
