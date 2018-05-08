module Upsteem
  module Deploy
    module Tasks
      class FeatureBranchComparison < Task
        include FeatureBranchDependent

        def run
          logger.info("Comparing #{feature_branch} with remote")
          return comparison_successful if git.up_to_date?(feature_branch)
          comparison_failed
        end

        private

        def comparison_successful
          logger.info("#{feature_branch} is in sync with remote repository")
          true
        end

        def comparison_failed
          raise(
            Errors::DeployError,
            "Please ensure that #{feature_branch} in your local repository " \
            "is in sync with the remote repository!"
          )
        end
      end
    end
  end
end
