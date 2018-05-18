module Upsteem
  module Deploy
    class Environment
      class Validator
        extend ValidatorInterface

        def validate
          validate_name_and_support
          validate_target_branch
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

        def raise_error(message)
          raise Errors::InvalidEnvironment, message
        end
      end
    end
  end
end
