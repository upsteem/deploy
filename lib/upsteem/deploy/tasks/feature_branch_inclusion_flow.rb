module Upsteem
  module Deploy
    module Tasks
      class FeatureBranchInclusionFlow < Task
        include FeatureBranchDependent

        def run
          compare_feature_branch_between_repositories
          sync_feature_branch_with_master
          download_target_branch
          merge_feature_branch
          bundle
          upload_target_branch
          true
        end

        def compare_feature_branch_between_repositories
          run_sub_task(FeatureBranchComparison)
        end

        def sync_feature_branch_with_master
          run_sub_task(FeatureBranchSyncing)
        end

        def download_target_branch
          run_sub_task(TargetBranchDownload)
        end

        def merge_feature_branch
          run_sub_task(FeatureBranchMerging)
        end

        def bundle
          run_sub_task(Bundle)
        end

        def upload_target_branch
          run_sub_task(TargetBranchUpload, message: "Merge from #{feature_branch}")
        end
      end
    end
  end
end
