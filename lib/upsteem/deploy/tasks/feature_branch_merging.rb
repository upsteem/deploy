module Upsteem
  module Deploy
    module Tasks
      class FeatureBranchMerging < Task
        include FeatureBranchDependent

        def run
          git.create_merge_commit_from_origin(feature_branch)
          true
        end
      end
    end
  end
end
