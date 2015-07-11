RSpec.configure do |config|
  Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|f| require f}
end
