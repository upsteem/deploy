module Upsteem
  module Deploy
    module Tasks
      class GemsUpdateFlow < Task
        def run
          download_target_branch
          bundle
          upload_target_branch
          true
        end

        private

        def download_target_branch
          run_sub_task(TargetBranchDownload)
        end

        def bundle
          run_sub_task(Bundle)
        end

        def upload_target_branch
          run_sub_task(TargetBranchUpload, message: "Deploy: update gems")
        end
      end
    end
  end
end
