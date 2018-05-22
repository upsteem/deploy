module Upsteem
  module Deploy
    module Tasks
      class FeatureBranchMerging < Task
        include FeatureBranchDependent

        def run
          logger.info("Starting to merge feature branch into #{environment.name} environment")
          validate_current_branch
          create_merge_commit
          logger.info("Finished merging feature branch into #{environment.name} environment")
          true
        rescue Errors::MergeConflict => e
          handle_merge_conflict(e)
        end

        private

        def branch_to_merge
          "origin/#{feature_branch}"
        end

        def validate_current_branch
          git.must_be_current_branch!(target_branch)
        end

        def create_merge_commit
          git.create_merge_commit(branch_to_merge)
        end

        def handle_merge_conflict(error)
          logger.error("Feature branch merging into #{environment.name} failed due to merge conflict")
          raise error
        end
      end
    end
  end
end
