%w[
  constants
  setup
].each do |file|
  require_relative("configuration/#{file}")
end

module Upsteem
  module Deploy
    class Configuration
      include Constants
      extend Setup
      extend Memoist

      attr_reader :project_path

      def supported_environments
        SUPPORTED_ENVIRONMENTS
      end

      def environment_supported?(environment_name)
        supported_environments.include?(environment_name)
      end

      def find_target_branch(environment_name)
        target_branches[environment_name] || environment_name.presence || raise(
          ArgumentError, "Target branch not found for #{environment_name.inspect} environment"
        )
      end

      def logger
        options[:logger]
      end

      # List of gems that do not have environment-specific variations.
      def shared_gems_to_update
        options[:shared_gems_to_update] || []
      end
      memoize :shared_gems_to_update

      # List of gems that are defined for each environment separately
      # in Gemfile.{environment.name}
      def env_gems_to_update
        options[:env_gems_to_update] || []
      end
      memoize :env_gems_to_update

      def tests
        create_section_from_yaml_file(
          ConfigurationSections::TestsConfiguration, options[:tests]
        )
      end
      memoize :tests

      def notifications
        create_section_from_yaml_file(
          ConfigurationSections::NotificationConfiguration, options[:notifications]
        )
      end
      memoize :notifications

      private

      attr_reader :options

      def initialize(project_path, options = {})
        @project_path = project_path
        @options = options
      end

      def target_branches
        TARGET_BRANCHES
      end

      def create_section_from_yaml_file(klass, file_path)
        ConfigurationSections::Factory.create_from_yaml_file(klass, project_path, file_path)
      end
    end
  end
end
