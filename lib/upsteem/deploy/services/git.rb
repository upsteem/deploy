module Upsteem
  module Deploy
    module Services
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

        def create_merge_commit(branch)
          args = [branch, "--no-commit", "--no-ff"]
          result = git.lib.send(:command, "merge", args)
          unmerged = git.lib.unmerged
          raise Errors::MergeConflict, "Unmerged changes detected: #{unmerged.inspect}" unless unmerged.empty?
          result
        rescue ::Git::GitExecuteError => e
          err_msg = match_execution_error(e, /conflict/i)
          raise Errors::MergeConflict, "Merge commit creation failed due to conflicts" if err_msg
          # Other, unexpected commit error:
          raise Errors::DeployError, "Error while creating merge commit from #{branch} to #{current_branch}"
        end

        def abort_merge
          git.lib.send(:command, "merge", ["--abort"])
        rescue ::Git::GitExecuteError
          raise Errors::DeployError, "Error while aborting the merge"
        end

        def head_revision
          git.revparse("HEAD")
        rescue ::Git::GitExecuteError
          raise Errors::DeployError, "Error while looking up HEAD revision"
        end

        def user_name
          git.config["user.name"]
        rescue ::Git::GitExecuteError
          raise Errors::DeployError, "Error while looking up user name"
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
