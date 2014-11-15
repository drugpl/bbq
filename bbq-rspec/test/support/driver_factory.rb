class DriverFactory

  attr_reader :drivers_count

  def initialize(log_path)
    @log = File.open(log_path, 'w')
    @drivers = []
  end

  def get_driver(app)
    @log.puts "Driver created"
    driver = TestDriver.new(app)
    @drivers << driver
    driver
  end

  def drivers_clean?
    @drivers.all?(&:clean?)
  end

  def drivers_count
    @drivers.size
  end

  class TestDriver

    def initialize(app)
      @app   = app
      @clean = true
    end

    def visit(path)
      @clean = false
    end

    def reset!
      @clean = true
    end

    def clean?
      @clean
    end

    def needs_server?
      false
    end
  end

end
