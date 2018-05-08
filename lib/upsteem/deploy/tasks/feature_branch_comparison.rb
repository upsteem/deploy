module Upsteem
  module Deploy
    module Tasks
      class FeatureBranchComparison < Task
        include FeatureBranchDependent

        def run
          git.must_be_in_sync!(feature_branch)
        end
      end
    end
  end
end
