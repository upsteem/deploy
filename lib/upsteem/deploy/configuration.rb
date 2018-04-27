%w[
  setup
].each do |file|
  require_relative("configuration/#{file}")
end

module Upsteem
  module Deploy
    class Configuration
      extend Setup
      extend Memoist

      attr_reader :project_path

      # Names of environments supported by default.
      SUPPORTED_ENVIRONMENTS = %w[dev staging production].tap do |list|
        list.each(&:freeze)
        list.freeze
      end

      # Default mapping of environment names into branches.
      TARGET_BRANCHES = { 
        "production" => "master"
      }.tap do |h| 
        h.each do |_, v|
          v.freeze
        end 
        h.freeze
      end

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
        options[:logger] || Logger.new(STDOUT)
      end
      memoize :logger

      def git
        GitProxy.new(Git.open(project_path), logger)
      end
      memoize :git

      def gems_to_update
        options[:gems_to_update] || []
      end
      memoize :gems_to_update

      def environment_invariant_project?
        !!options[:environment_invariant_project]
      end
      memoize :environment_invariant_project?

      attr_reader :options

      def initialize(project_path, options = {})
        @project_path = project_path
        @options = options
      end

      def target_branches
        TARGET_BRANCHES
      end
    end
  end
end
