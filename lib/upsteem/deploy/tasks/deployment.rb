module Upsteem
  module Deploy
    module Tasks
      # Full deployment flow compatible with non-executable projects such as gems.
      # However, the functionality here should also be either usable or extensible
      # for application deployment.
      class Deployment < Task
        def run
          log_start
          prepare_deployment
          update_environment_source_code
          execute_environment
          log_success
          true
        rescue Errors::DeployError => e
          log_failure(e)
          false
        end

        private

        def prepare_deployment
          run_sub_task(Tasks::GitStatusValidation)
        end

        def perform_feature_branch_inclusion_flow
          run_sub_task(Tasks::FeatureBranchInclusionFlow)
        end

        def perform_gems_update_flow
          run_sub_task(Tasks::GemsUpdateFlow)
        end

        def update_environment_source_code
          if feature_branch
            perform_feature_branch_inclusion_flow
          else
            perform_gems_update_flow
          end
        end

        # This depends on the type of the project that is to be deployed.
        # Gems usually don't have execution phase while applications do.
        def execute_environment; end

        def log_start
          feature_branch_descr = feature_branch ? " of #{feature_branch}" : ""
          logger.info(
            "Starting deployment#{feature_branch_descr} to #{environment.name} " \
            "environment in #{environment.project_path}"
          )
        end

        def log_success
          logger.info("Deploy OK")
        end

        def log_failure(deploy_error)
          if deploy_error.cause
            logger.error("#{deploy_error.message}. Cause: #{deploy_error.cause}")
          else
            logger.error(deploy_error.message)
          end
          logger.error("Deploy failed")
        end
      end
    end
  end
end
