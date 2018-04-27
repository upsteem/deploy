module Upsteem
  module Deploy
    module Tasks
      class TargetBranchUpload < Task
        extend Memoist

        def run
          git.commit(commit_message, all: true)
          git.push("origin", target_branch)
          logger.info("Successfully committed and pushed to #{target_branch}")
          true
        end

        private

        def after_initialize
          commit_message
        end

        def commit_message
          options[:message] || raise(ArgumentError, "Commit message not supplied via :message option")
        end
        memoize :commit_message
      end
    end
  end
end
