require "active_support/core_ext/string"
require "logger"
require "git"
require "fileutils"
require "memoist"
require "yaml"
require "json"
require "faraday"

%w[
  utils
  builder_interface
  configuration_sections
  configuration
  environment
  errors
  services
  factories
  services_container
  tasks
  deployer
  usage
].each do |file|
  require_relative("deploy/#{file}")
end

module Upsteem
  module Deploy
    extend Usage
  end
end
