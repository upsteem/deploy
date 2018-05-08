module Upsteem
  module Deploy
    module Proxies
      class Git
        extend Memoist

        def current_branch
          git.current_branch
        rescue ::Git::GitExecuteError
          raise Errors::DeployError, "Error while looking up current branch"
        end

        def must_be_current_branch!(branch)
          current = current_branch
          return true if branch == current
          raise(
            Upsteem::Deploy::Errors::DeployError,
            "Expected current branch to be #{branch}, but it was #{current}"
          )
        end

        def status
          git.status
        rescue ::Git::GitExecuteError
          raise Errors::DeployError, "Error while checking git status"
        end

        def checkout(branch)
          git.checkout(branch)
        rescue ::Git::GitExecuteError
          raise Errors::DeployError, "Error while checking out #{branch}"
        end

        def pull(repository, branch)
          git.pull(repository, branch)
        rescue ::Git::GitExecuteError
          raise Errors::DeployError, "Error while pulling from #{repository}/#{branch}"
        end

        def must_be_in_sync!(branch)
          size = git.log.between("origin/#{branch}", branch).size
          raise Errors::DeployError, "No information found" unless size
          return true if size.zero?
          raise Errors::DeployError, "#{branch} in local repository is not in sync with remote repository!"
        rescue ::Git::GitExecuteError
          raise Errors::DeployError, "Error while comparing #{branch} with remote"
        end

        def commit(message, options = {})
          git.commit(message, options)
        rescue ::Git::GitExecuteError => e
          # Deploy without committing anything new is a valid use case
          # that should not end with an exception.
          err_msg = match_execution_error(e, /nothing to commit/i)
          return err_msg if err_msg
          # Other, unexpected commit error:
          raise Errors::DeployError, "Error while committing with #{message.inspect}, #{options.inspect}"
        end

        def push(remote, branch)
          git.push(remote, branch)
        rescue ::Git::GitExecuteError
          raise Errors::DeployError, "Error while pushing to #{remote}/#{branch}"
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

        private

        attr_reader :project_path

        def initialize(project_path)
          @project_path = project_path || raise(ArgumentError, "Project path not supplied")
        end

        def git
          ::Git.open(project_path)
        end
        memoize :git

        def match_execution_error(error, regex)
          err_msg = error.message.to_s
          err_msg =~ regex ? err_msg : nil
        end
      end
    end
  end
end
