module CommandHelper
  def create_file(path, content)
    file = Bbq.root.join(path)
    FileUtils.mkdir_p(file.dirname)
    file.open('w') { |f| f.write(content) }
  end

  attr_accessor :output

  def run_cmd(command)
    self.output = Bundler.with_clean_env { `#{command} 2>&1` }
    raise "`#{command}` failed with:\n#{output}" unless $?.success?
  end
end
