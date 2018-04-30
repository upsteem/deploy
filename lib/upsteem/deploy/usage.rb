module Upsteem
  module Deploy
    module Usage
      # Deploys a gem-type project.
      def deploy_gem(project_path, environment_name, feature_branch, options = {})
        Deployer.deploy(Tasks::Deployment, project_path, environment_name, feature_branch, options)
      end

      # Deploys an application-type project.
      def deploy_application(project_path, environment_name, feature_branch, options = {})
        Deployer.deploy(Tasks::ApplicationDeployment, project_path, environment_name, feature_branch, options)
      end
    end
  end
end
