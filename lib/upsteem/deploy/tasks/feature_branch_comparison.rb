module Upsteem
  module Deploy
    module Tasks
      class FeatureBranchComparison < Task
        include FeatureBranchDependent

        def run
          diff = find_diff
          diff.zero? ? comparison_successful : comparison_failed
        rescue Git::GitExecuteError
          raise DeployError, "Failed to compare #{feature_branch} between repositories"
        end

        private

        def find_diff
          git.log.between("origin/#{feature_branch}", feature_branch).size
        end

        def comparison_successful
          logger.info("#{feature_branch} is in sync with remote repository")
          true
        end

        def comparison_failed
          raise Errors::DeployError,
            "Please ensure that #{feature_branch} in your local repository " \
            "is in sync with the remote repository!"
        end
      end
    end
  end
end
