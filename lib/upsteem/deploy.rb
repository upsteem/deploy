require "active_support/core_ext/string"
require "active_support/core_ext/module/delegation"
require "logger"
require "git"
require "fileutils"
require "memoist"

%w[
  configuration
  errors
  environment
  proxies
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
