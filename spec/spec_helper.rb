require "bundler"
require "rubygems"
Bundler.require(:default, :test)
require_relative "support/preload"

RSpec.configure do |config|
  config.mock_with(:rspec) do |mocks|
    mocks.verify_doubled_constant_names = true
  end
  config.include(Upsteem::Deploy::MockingHelpers)
end
