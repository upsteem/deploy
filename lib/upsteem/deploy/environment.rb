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

      attr_reader :configuration, :name, :feature_branch

      def target_branch
        configuration.find_target_branch(name)
      end
      memoize :target_branch

      private

      def initialize(configuration, name, feature_branch)
        @configuration = configuration
        @name = name
        @feature_branch = feature_branch
      end
    end
  end
end
