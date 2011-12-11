module Bbq
  module Session
    extend self

    def next(options = {})
      driver = options.delete(:driver)
      pool   = options.delete(:pool)

      if pool
        pool.next(driver)
      else
        create(driver)
      end
    end

    def create(driver)
      Capybara::Session.new(driver, Bbq.app)
    end

    def pool
      @pool ||= Pool.new
    end

    class Pool
      attr_accessor :idle, :taken

      def initialize
        @idle   = []
        @taken  = []
      end

      def next(driver)
        take_idle(driver) || create(driver)
      end

      def release
        taken.each(&:reset!)
        idle.concat(taken)
        taken.clear
      end

      private

      def take_idle(driver)
        idle.find { |s| s.mode == driver }.tap do |session|
          if session
            idle.delete(session)
            taken.push(session)
          end
        end
      end

      def create(driver)
        Bbq::Session.create(driver).tap do |session|
          taken.push(session)
        end
      end
    end
  end
end
