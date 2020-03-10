require 'bbq/rspec'
require 'rack/builder'

Bbq::Core.app = Rack::Builder.new do
  map '/test_page' do
    html_page = <<-EOP
      <!DOCTYPE html>
      <html>
        <head>
          <title>Ponycorns</title>
        </head>
        <body>
          <ul id="unicorns">
            <li>Pink</li>
          </ul>
          <ul id="ponies">
            <li>Violet</li>
          </ul>
        </body>
      </html>
    EOP

    run ->(env) { ['200', {'Content-Type' => 'text/html'}, [html_page]] }
  end
end
