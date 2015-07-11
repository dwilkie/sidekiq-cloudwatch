unless ENV["RACK_ENV"] == "production"
  require 'rspec/core/rake_task'

  desc "Run all examples"
  RSpec::Core::RakeTask.new(:spec)

  task :default => [:spec]
end
