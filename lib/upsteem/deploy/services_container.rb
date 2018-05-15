module Upsteem
  module Deploy
    class ServicesContainer
      extend Memoist

      attr_reader :configuration

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
        Proxies::Notifier.new(configuration.notifications, logger)
      end
      memoize :notifier

      private

      def initialize(configuration)
        @configuration = configuration || raise(
          ArgumentError, "Cannot create services container without configuration"
        )
      end
    end
  end
end
