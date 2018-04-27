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
  git_proxy
  tasks
  usage
].each do |file|
  require_relative("deploy/#{file}")
end

module Upsteem
  module Deploy
    extend Usage
  end
end
