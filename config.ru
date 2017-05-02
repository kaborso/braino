require 'rubygems'
require 'bundler'

ENVIRONMENT = (ENV['RACK_ENV'] || 'development').to_sym

Bundler.setup(:default, ENVIRONMENT)
Bundler.require(:default, ENVIRONMENT)

$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), 'app'))

require 'braino'

use Rack::Session::Cookie
run Rack::Cascade.new [API, Web]
