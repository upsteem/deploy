module Upsteem
  module Deploy
    module Proxies
      class VerboseGit < Git
        def checkout(branch)
          logger.info("Checking out #{branch}")
          super.tap { |result| log_result(result, "checkout") }
        end

        def pull(repository, branch)
          logger.info("Pulling in changes from #{repository}/#{branch}")
          super.tap { |result| log_result(result, "pull") }
        end

        def commit(message, options = {})
          logger.info("Committing with message: #{message.inspect}, options: #{options.inspect}")
          super.tap { |result| log_result(result, "commit") }
        end

        def push(remote, branch)
          logger.info("Pushing to #{remote}/#{branch}")
          super.tap { |result| log_result(result, "push") }
        end

        def create_merge_commit(branch)
          logger.info("Starting to create a merge commit from #{branch} to #{current_branch}")
          super.tap { |result| log_result(result, "create_merge_commit") }
        end

        def abort_merge
          logger.info("Starting to abort the merge")
          super.tap { |result| log_result(result, "abort_merge") }
        end

        private

        attr_reader :logger

        def initialize(project_path, logger)
          super(project_path)
          @logger = logger || raise(ArgumentError, "Logger not supplied")
        end

        def log_result(result, operation)
          logger.info("Result (#{operation}): #{result}")
        end
      end
    end
  end
end
