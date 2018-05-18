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
        Proxies::System.new
      end
      memoize :system

      def bundler
        Proxies::Bundler.new(system)
      end
      memoize :bundler

      def capistrano
        Proxies::Capistrano.new(bundler)
      end
      memoize :capistrano

      def git
        Proxies::VerboseGit.new(configuration.project_path, logger)
      end
      memoize :git

      def notifier
        Proxies::Notifier.new(configuration.notifications, environment, logger, git)
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
