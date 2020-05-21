%w[
  constants
].each do |file|
  require_relative("configuration/#{file}")
end

module Upsteem
  module Deploy
    class Configuration
      include Constants
      extend Memoist

      attr_reader :project_path

      def supported_environments
        target_branches.keys
      end

      def environment_supported?(environment_name)
        target_branches[environment_name].present?
      end

      def find_target_branch(environment_name)
        target_branches[environment_name] || raise(
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

      def test_suite
        create_section_from_yaml_file(
          ConfigurationSections::TestSuiteConfiguration, options[:test_suite]
        )
      end
      memoize :test_suite

      def notifications
        create_section_from_yaml_file(
          ConfigurationSections::NotificationConfiguration, options[:notifications]
        )
      end
      memoize :notifications

      private

      attr_reader :options

      def initialize(project_path, options)
        @project_path = project_path
        @options = options
      end

      def target_branches
        TARGET_BRANCHES.merge(additional_target_branches.stringify_keys)
      end
      memoize :target_branches

      def additional_target_branches
        options[:additional_target_branches] || {}
      end

      def create_section_from_yaml_file(klass, file_path)
        ConfigurationSections::Factory.create_from_yaml_file(klass, project_path, file_path)
      end
    end
  end
end
