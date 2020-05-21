module Upsteem
  module Deploy
    module Usage
      # Deploys a gem-type project.
      def deploy_gem(project_path, environment_name, feature_branch, config_file_path = nil)
        Deployer.deploy(Tasks::Deployment, project_path, environment_name, feature_branch, config_file_path)
      end

      # Deploys an application-type project.
      def deploy_application(project_path, environment_name, feature_branch, config_file_path = nil)
        Deployer.deploy(Tasks::ApplicationDeployment, project_path, environment_name, feature_branch, config_file_path)
      end
    end
  end
end
