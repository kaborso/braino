$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), 'app'))

require 'braino'

use Rack::Session::Cookie
run Rack::Cascade.new [API, Web]
