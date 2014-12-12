require 'rack/builder'
require 'bbq/test_user'

Bbq.app = Rack::Builder.new do
  map '/test_page' do
    html_page = <<-EOP
      <!DOCTYPE html>
      <html>
        <head>
          <title>Dummy</title>
        </head>
        <body>
          <ul id="unicorns">
            <li>Pink</li>
          </ul>
          <ul id="ponies">
            <li>Violet</li>
          </ul>
          <div id="new_pony">
            <input type="text" name="color" value="" />
          </div>
          <a href="#">More ponycorns</a>
        </body>
      </html>
    EOP

    run ->(env) { ['200', {'Content-Type' => 'text/html'}, [html_page]] }
  end
end
