module Upsteem
  module Deploy
    class Environment
      class Validator
        extend ValidatorInterface

        def validate
          validate_name_and_support
          validate_target_branch
          validate_services
          true
        end

        private

        attr_reader :environment

        def initialize(environment)
          @environment = environment
        end

        def validate_name_and_support
          raise_error("Environment name is required") unless environment.name
          raise_error("Environment not supported: #{environment.name.inspect}") unless environment.supported
        end

        def validate_target_branch
          raise_error("Target branch is required") unless environment.target_branch
        end

        def validate_services
          validate_logger
          validate_system
          validate_bundler
          validate_capistrano
          validate_git
          validate_notifier
        end

        def validate_logger
          raise_error("Logger is required") unless environment.logger
        end

        def validate_system
          raise_error("System is required") unless environment.system
        end

        def validate_bundler
          raise_error("Bundler is required") unless environment.bundler
        end

        def validate_capistrano
          raise_error("Capistrano is required") unless environment.capistrano
        end

        def validate_git
          raise_error("Git is required") unless environment.git
        end

        def validate_notifier
          raise_error("Notifier is required") unless environment.notifier
        end

        def raise_error(message)
          raise Errors::InvalidEnvironment, message
        end
      end
    end
  end
end
