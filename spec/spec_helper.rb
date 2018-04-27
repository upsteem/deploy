require "bundler"
require "rubygems"
Bundler.require(:default, :test)

Dir[File.dirname(__FILE__) + "/support/*.rb"].each do |file|
  require(file)
end

RSpec.configure do |config|
  config.mock_with(:rspec) do |mocks|
    mocks.verify_doubled_constant_names = true
  end
end
