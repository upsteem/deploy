require "bundler"
require "rubygems"
Bundler.require(:default, :test)
require_relative "support/preload"

RSpec.configure do |config|
  config.define_derived_metadata do |metadata|
    md = metadata[:file_path].match(/(unit|integration)/)
    metadata[:type] = md[1].to_sym if md # e.g. :unit
  end

  config.mock_with(:rspec) do |mocks|
    mocks.verify_doubled_constant_names = true
  end

  config.include(Upsteem::Deploy::MockingHelpers, type: :unit)
  config.include(Upsteem::Deploy::IntegrationSpecUtils, type: :integration)
end
