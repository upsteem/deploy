module Upsteem
  module Deploy
    class Deployer
      extend Memoist

      private_class_method :new

      def self.deploy(task_class, project_path, environment_name, feature_branch, options)
        new(task_class, project_path, environment_name, feature_branch, options).deploy
      end

      def deploy
        task_class.new(environment).run
      rescue Errors::InvalidEnvironment => e
        display_invalid_environment_error(e)
      end

      private

      attr_reader :task_class, :project_path, :environment_name, :feature_branch, :options

      def initialize(task_class, project_path, environment_name, feature_branch, options)
        @task_class = task_class
        @project_path = project_path
        @environment_name = environment_name
        @feature_branch = feature_branch
        @options = options
      end

      def configuration
        Configuration.set_up(project_path, options)
      end
      memoize :configuration

      def services_container
        ServicesContainer.new(configuration)
      end
      memoize :services_container

      def environment
        Environment::Factory.create(services_container, configuration, environment_name, feature_branch)
      end
      memoize :environment

      def display_invalid_environment_error(error)
        puts(error)
        supported = configuration.supported_environments
        puts("Usage: ./deploy (#{supported.join('|')}) feature_branch_to_release")
        puts("EXAMPLE: ./deploy #{supported.first} DEV-455")
        nil
      end
    end
  end
end
