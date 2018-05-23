module Upsteem
  module Deploy
    module Services
      class Rollbacker
        def rollback(reason)
          check_rollback_reason(reason)
          return handle_missing_feature_branch unless environment.feature_branch
          rollback_feature_branch
          true
        rescue Errors::DeployError => e
          handle_error(e)
        end

        private

        attr_reader :logger, :git, :environment

        def initialize(logger, git, environment)
          @logger = logger
          @git = git
          @environment = environment
        end

        def check_rollback_reason(reason)
          raise("No reason for rollback given") unless reason
          logger.info("Rollback reason: #{reason.message} (#{reason.class})")
        end

        def rollback_feature_branch
          logger.info("Trying to roll back pending changes for the local repository")
          git.abort_merge
          git.checkout(environment.feature_branch)
          logger.info("Rollback done")
        end

        def log_pending_changes_disclaimer
          logger.info("If there are any pending changes for the local repository, you'll have to revert them manually!")
          logger.info("Also, you might need to check your current branch as well before you continue investigation!")
        end

        def handle_missing_feature_branch
          logger.info("Not able to rollback anything, since there is no feature branch")
          log_pending_changes_disclaimer
          false
        end

        def handle_error(error)
          logger.error("#{error.message} (#{error.class})")
          log_pending_changes_disclaimer
          raise Errors::DeployError, "Rollback failed"
        end
      end
    end
  end
end
