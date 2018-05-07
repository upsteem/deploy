module Upsteem
  module Deploy
    module Proxies
      class Git
        def initialize(git, logger)
          @git = git
          @logger = logger
        end

        def current_branch
          git.current_branch
        end

        def status
          git.status
        rescue Git::GitExecuteError
          raise Errors::DeployError, "Error on git status"
        end

        def checkout(branch)
          git.checkout(branch)
        rescue Git::GitExecuteError
          raise Errors::DeployError, "Error on git checkout"
        end

        def pull(repository, branch)
          git.pull(repository, branch)
        rescue Git::GitExecuteError
          raise Errors::DeployError, "Error on git pull"
        end

        def create_merge_commit(branch, custom_args = [])
          args = [branch, "--no-commit", "--no-ff"] + custom_args
          logger.info(
            "Starting to create a merge commit from #{branch} to #{current_branch}. " \
            "Arguments: #{args[1...args.length].inspect}"
          )
          result = git.lib.send(:command, "merge", args)
          logger.info(result)
          abort_merge_and_fail_deploy!(branch) unless git.lib.unmerged.empty?
          logger.info("Successfully created merge commit from #{branch} to #{current_branch}")
          result
        rescue Git::GitExecuteError => e
          err_msg = e.message.to_s
          abort_merge_and_fail_deploy!(branch, err_msg) if err_msg =~ /conflict/i
          raise DeployError, "Error on creating merge commit from #{branch} to #{current_branch}"
        end

        def create_merge_commit_from_origin(branch, custom_args = [])
          create_merge_commit("origin/#{branch}", custom_args)
        end

        def abort_merge_and_fail_deploy!(branch, err_msg = nil)
          logger.info(err_msg) if err_msg
          logger.info(
            "There are merge conflicts between #{git.current_branch} and #{branch} - " \
            "please merge manually!"
          )
          logger.info("Aborting conflicting merge")
          abort_merge
          raise DeployError, "Merge conflicts must be resolved manually!"
        end

        def abort_merge
          logger.info("Starting to abort a merge")
          result = git.lib.send(:command, "merge", ["--abort"])
          logger.info(result)
          logger.info("Merge aborted")
          result
        rescue Git::GitExecuteError
          raise DeployError, "Error on aborting the merge"
        end

        def commit(message, options = {})
          logger.info(
            "Starting a commit to #{git.current_branch}. " \
            "Message: #{message.inspect}, options: #{options.inspect}"
          )
          result = git.commit(message, options)
          logger.info(result)
          logger.info("Commit successful")
          result
        rescue Git::GitExecuteError => e
          # Deploy without committing anything new is a valid use case
          # that should not end with an exception.
          err_msg = e.message.to_s
          if err_msg =~ /nothing to commit/i
            logger.info(err_msg)
            return err_msg
          end
          raise DeployError, "Error on commit" # other, unexpected commit error
        end

        private

        attr_reader :git, :logger

        # Delegate method calls to wrapped git object by default and add some logging.
        def method_missing(method_name, *arguments)
          logger.info(
            "Starting to call git #{method_name} with the " \
            "following arguments: #{arguments.inspect}"
          )
          result = git.send(method_name, *arguments)
          logger.info(result) if result.is_a?(String)
          logger.info("Finished git #{method_name}")
          result
        rescue Git::GitExecuteError
          raise DeployError, "Error while calling git.#{method_name} with #{arguments.inspect}"
        end
      end
    end
  end
end
