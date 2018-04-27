module Upsteem
  module Deploy
    module Tasks
      class FeatureBranchSyncing < Task
        include FeatureBranchDependent

        def run
          git.checkout(feature_branch)
          git.create_merge_commit_from_origin("master")
          git.commit("Sync #{git.current_branch} with master", all: true)
          git.push("origin", feature_branch)
          syncing_successful
        end

        private

        def syncing_successful
          logger.info("Successfully synced #{git.current_branch} with master")
          true
        end
      end
    end
  end
end
