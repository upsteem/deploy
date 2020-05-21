module Upsteem
  module Deploy
    class Deployer
      extend Memoist

      private_class_method :new

      def self.deploy(task_class, project_path, environment_name, feature_branch, config_file_path)
        new(task_class, project_path, environment_name, feature_branch, config_file_path).deploy
      end

      def deploy
        task_class.new(services_container).run
      rescue Errors::InvalidEnvironment => e
        display_invalid_environment_error(e)
      end

      private

      attr_reader :task_class, :project_path, :environment_name, :feature_branch, :config_file_path

      def initialize(task_class, project_path, environment_name, feature_branch, config_file_path)
        @task_class = task_class
        @project_path = project_path
        @environment_name = environment_name
        @feature_branch = feature_branch
        @config_file_path = config_file_path
      end

      def configuration
        Factories::ConfigurationFactory.create(project_path, config_file_path)
      end
      memoize :configuration

      def environment
        Environment::Factory.create(configuration, environment_name, feature_branch)
      end
      memoize :environment

      def services_container
        ServicesContainer.new(configuration, environment)
      end
      memoize :services_container

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
