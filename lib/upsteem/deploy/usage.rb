module Upsteem
  module Deploy
    module Usage
      # Deploys a gem-type project.
      def deploy_gem(project_path, environment_name, feature_branch, options = {})
        deploy(Tasks::Deployment, project_path, environment_name, feature_branch, options)
      end

      # Deploys an application-type project.
      def deploy_application(project_path, environment_name, feature_branch, options = {})
        deploy(Tasks::ApplicationDeployment, project_path, environment_name, feature_branch, options)
      end

      private

      def deploy(task_class, project_path, environment_name, feature_branch, options)
        create_deployment_task(
          task_class, project_path, environment_name, feature_branch, options
        ).run
      rescue Errors::InvalidEnvironment => e
        display_invalid_environment_error(e)
      end

      def create_deployment_task(klass, project_path, environment_name, feature_branch, options)
        configuration = Configuration.set_up(project_path, options)
        environment = Environment.set_up(configuration, environment_name, feature_branch)
        klass.new(environment)
      end

      def display_invalid_environment_error(error)
        puts(error)
        supported = error.supported_environments
        puts("Usage: ./deploy (#{supported.join('|')}) feature_branch_to_release")
        puts("EXAMPLE: ./deploy #{supported.first} DEV-455")
      end
    end
  end
end
