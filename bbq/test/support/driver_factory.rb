class DriverFactory

  attr_reader :drivers_count

  def initialize
    @drivers_count = 0
  end

  def get_driver(app, name = :bbq)
    @drivers_count += 1
    TestDriver.new(app)
  end

  class TestDriver

    def initialize(app)
      @app = app
    end

    def visit(path)
    end

    def reset!
    end

  end

end
