$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), 'app'))

require 'braino'

run Rack::Cascade.new [API, Web]
