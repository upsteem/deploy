module Upsteem
  module Deploy
    module Tasks
      class TargetBranchDownload < Task
        def run
          checkout
          pull
          logger.info("Target branch download OK")
          true
        end

        private

        def checkout
          logger.info("Checking out #{target_branch} branch")
          result = git.checkout(target_branch)
          logger.info("Result: #{result}")
        end

        def pull
          logger.info("Pulling in remote changes")
          result = git.pull("origin", target_branch)
          logger.info("Result: #{result}")
        end
      end
    end
  end
end
