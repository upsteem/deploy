module Upsteem
  module Deploy
    module Services
      module TestSuiteRunners
        # Superclass for all runners that actually run the test suite
        # instead of skipping it or similar.
        class Runner < Base
          def run_test_suite
            logger.info("Starting to run the test suite using #{configuration.framework}")
            execute_test_suite_command
            logger.info("Tests successful")
            true
          rescue Errors::DeployError => e
            handle_error(e)
          end

          private

          attr_reader :configuration, :logger, :input_service, :bundler

          def initialize(configuration, logger, input_service, bundler)
            @configuration = configuration
            @logger = logger
            @input_service = input_service
            @bundler = bundler
          end

          # Override in subclasses:
          def execute_test_suite_command
            raise(
              NotImplementedError,
              "Test suite runners must implement private execute_test_suite_command() instance method"
            )
          end

          def handle_error(error)
            logger.error(error.message)
            logger.error("Tests failed")
            allow_to_continue_deploy
            false
          end

          def allow_to_continue_deploy
            logger.info("") # empty line
            logger.info("Your first priority should be stop doing whatever you are doing now and fix the failing tests!")
            logger.info("Do you still want to proceed with the deploy despite the failing test suite?")
            proceed_when_correct_passcode(generate_correct_passcode)
          end

          def generate_correct_passcode
            Utils.generate_numeric_code(5)
          end

          def proceed_when_correct_passcode(correct_passcode)
            logger.info("Please insert the following code to proceed: #{correct_passcode}. Or hit enter right away to cancel.")
            actual_code = input_service.read
            handle_incorrect_passcode(actual_code) unless actual_code == correct_passcode
            logger.info("Ignoring failing test suite and proceeding")
          end

          def handle_incorrect_passcode(actual_code)
            logger.error("Wrong code: #{actual_code}")
            raise_error("Cancellation due to failing test suite")
          end

          def raise_error(message)
            raise Errors::FailingTestSuite, message
          end
        end
      end
    end
  end
end
