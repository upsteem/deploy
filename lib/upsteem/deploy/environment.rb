%w[
  validator
  builder
  factory
].each do |file|
  require_relative("environment/#{file}")
end

module Upsteem
  module Deploy
    class Environment
      attr_accessor :name, :feature_branch
      attr_accessor :supported, :target_branch, :project_path, :gemfile_overwrite_needed, :gems_to_update
    end
  end
end
