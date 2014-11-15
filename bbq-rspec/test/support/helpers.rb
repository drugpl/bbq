module CommandHelper
  attr_accessor :output

  def run_cmd(command)
    self.output = Bundler.with_clean_env { `#{command} 2>&1` }
    raise "`#{command}` failed with:\n#{output}" unless $?.success?
  end
end
