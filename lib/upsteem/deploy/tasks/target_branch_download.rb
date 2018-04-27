module Upsteem
  module Deploy
    module Tasks
      class TargetBranchDownload < Task
        def run
          git.checkout(target_branch)
          git.pull("origin", target_branch)
          logger.info("Checked out #{target_branch} and pulled in remote changes.")
          true
        end
      end
    end
  end
end
