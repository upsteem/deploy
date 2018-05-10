%w[
  setup
].each do |file|
  require_relative("environment/#{file}")
end

module Upsteem
  module Deploy
    class Environment
      extend Setup
      extend Memoist

      attr_reader :name, :feature_branch

      def target_branch
        configuration.find_target_branch(name)
      end
      memoize :target_branch

      def project_path
        configuration.project_path
      end

      def logger
        configuration.logger
      end

      def git
        configuration.git
      end

      def bundler
        configuration.bundler
      end

      def capistrano
        configuration.capistrano
      end

      def gemfile_overwrite_needed?
        configuration.env_gems_to_update.present?
      end
      memoize :gemfile_overwrite_needed?

      def gems_to_update
        configuration.shared_gems_to_update + configuration.env_gems_to_update
      end
      memoize :gems_to_update

      private

      attr_reader :configuration

      def initialize(configuration, name, feature_branch)
        @configuration = configuration
        @name = name
        @feature_branch = feature_branch
      end
    end
  end
end
