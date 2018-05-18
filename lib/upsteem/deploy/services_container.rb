module Upsteem
  module Deploy
    class ServicesContainer
      extend Memoist

      attr_reader :environment

      def logger
        configuration.logger || Logger.new(STDOUT)
      end
      memoize :logger

      def system
        Services::System.new
      end
      memoize :system

      def bundler
        Services::Bundler.new(system)
      end
      memoize :bundler

      def capistrano
        Services::Capistrano.new(bundler)
      end
      memoize :capistrano

      def git
        Services::VerboseGit.new(configuration.project_path, logger)
      end
      memoize :git

      def notifier
        Services::Notifier.new(configuration.notifications, environment, logger, git)
      end
      memoize :notifier

      private

      attr_reader :configuration

      def initialize(configuration, environment)
        @configuration = configuration
        @environment = environment
      end
    end
  end
end
