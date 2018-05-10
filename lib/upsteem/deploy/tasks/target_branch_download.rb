module Upsteem
  module Deploy
    module Tasks
      class TargetBranchDownload < Task
        def run
          checkout
          pull
          true
        end

        private

        def checkout
          git.checkout(target_branch)
        end

        def pull
          git.pull("origin", target_branch)
        end
      end
    end
  end
end
