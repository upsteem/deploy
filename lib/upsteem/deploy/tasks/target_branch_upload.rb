module Upsteem
  module Deploy
    module Tasks
      class TargetBranchUpload < Task
        extend Memoist

        def run
          validate_current_branch
          commit
          push
          logger.info("Target branch upload OK")
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

        def commit_options
          { all: true }
        end
        memoize :commit_options

        def git_remote
          "origin"
        end
        memoize "git_remote"

        def validate_current_branch
          current_branch = git.current_branch
          return true if current_branch == target_branch
          raise(
            Upsteem::Deploy::Errors::DeployError,
            "Expected current branch to be #{target_branch}, but it was #{current_branch}"
          )
        end

        def commit
          log_commig_start
          result = git.commit(commit_message, commit_options)
          logger.info("Result: #{result}")
        end

        def log_commig_start
          logger.info("Committing to #{target_branch} branch")
          logger.info("Message: #{commit_message.inspect}, options: #{commit_options.inspect}")
        end

        def push
          logger.info("Pushing to #{git_remote}/#{target_branch}")
          result = git.push(git_remote, target_branch)
          logger.info("Result: #{result}")
        end
      end
    end
  end
end
