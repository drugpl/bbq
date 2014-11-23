require 'rubygems'
gemfile = File.expand_path('../../../Gemfile', __FILE__)

raise 'could not find gemfile' unless File.exist?(gemfile)
ENV['BUNDLE_GEMFILE'] = gemfile
require 'bundler'
Bundler.setup

$:.unshift File.expand_path('../../../../lib', __FILE__)

module Dope
  class App
    def call(env)
      ['200', {'Content-Type' => 'text/plain'}, ['BBQ supports rack']]
    end
  end
end
