$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), 'lib'))

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec) do |t|
  end
  task :default => :spec
rescue LoadError
  puts "RSpec couldnae be loaded."
end
