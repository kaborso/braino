$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), 'app'))
require 'rubygems'
require 'bundler'

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec) do |t|
  end
  task :default => :spec
rescue LoadError
  puts "RSpec couldnae be loaded."
end

desc 'Document API routes'
task :docs do
  Bundler.setup(:default, :development)
  Bundler.require(:default, :development)
  require 'braino'
  # puts API.methods
  puts API.endpoints.first.endpoints
  puts "braino API #{API::version}"
  puts "============="
  API::routes.each do |route|
    puts "#{route.request_method} #{route.path}"
    puts route.description
    puts route.params
    puts
  end
end
