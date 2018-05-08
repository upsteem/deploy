module Upsteem
  module Deploy
    module Tasks
      class FeatureBranchSyncing < Task
        include FeatureBranchDependent

        REMOTE = "origin".freeze
        MASTER = "#{REMOTE}/master".freeze

        def run
          logger.info("Starting to sync #{feature_branch} with #{master}")
          checkout
          create_merge_commit
          commit
          push
          logger.info("Syncing successful")
          true
        rescue Errors::MergeConflict => e
          handle_merge_conflict(e)
        end

        private

        def master
          MASTER
        end

        def checkout
          git.checkout(feature_branch)
        end

        def create_merge_commit
          git.create_merge_commit(master)
        end

        def commit
          git.commit("Sync #{feature_branch} with #{MASTER}", all: true)
        end

        def push
          git.push(REMOTE, feature_branch)
        end

        def handle_merge_conflict(error)
          logger.error("Syncing failed due to merge conflict")
          git.abort_merge
          raise error
        end
      end
    end
  end
end
