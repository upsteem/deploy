module Upsteem
  module Deploy
    class ServicesContainer
      extend Memoist

      attr_reader :environment

      def logger
        configuration.logger || Logger.new(STDOUT)
      end
      memoize :logger

      def input_service
        Services::StandardInputService.new
      end
      memoize :input_service

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

      def test_suite_runner
        Factories::TestSuiteRunnerFactory.create(configuration.test_suite, self)
      end
      memoize :test_suite_runner

      private

      attr_reader :configuration

      def initialize(configuration, environment)
        @configuration = configuration
        @environment = environment
      end
    end
  end
end
