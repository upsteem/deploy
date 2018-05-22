module Upsteem
  module Deploy
    module Services
      class Rollbacker
        def rollback
          logger.info("Trying to roll back pending changes for the local repository")
          git.abort_merge
          git.checkout(environment.feature_branch) if environment.feature_branch
          logger.info("Rollback done")
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

        def handle_error(error)
          logger.error("#{error.message} (#{error.class})")
          logger.error("If there are any pending changes for the local repository, you'll have to revert them manually!")
          raise Errors::DeployError, "Rollback failed"
        end
      end
    end
  end
end
