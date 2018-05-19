module Upsteem
  module Deploy
    module Services
      module TestRunners
        class Rspec < Base
          def run_tests
            logger.info("Starting to run tests using rspec")
            bundler.execute_command("rspec")
            logger.info("Tests successful")
            true
          rescue Errors::DeployError => e
            handle_error(e)
          end

          private

          attr_reader :configuration, :bundler, :logger

          def initialize(configuration, bundler, logger)
            @configuration = configuration
            @bundler = bundler
            @logger = logger
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
            logger.info("Do you still want to proceed with the deploy despite the failing tests?")
            proceed_when_correct_passcode(generate_correct_passcode)
          end

          def generate_correct_passcode
            Utils.generate_numeric_code(5)
          end

          def proceed_when_correct_passcode(correct_passcode)
            logger.info("Please insert the following code to proceed: #{correct_passcode}. Or hit enter right away to cancel.")
            actual_code = gets.strip
            handle_incorrect_passcode(actual_code) unless actual_code == correct_passcode
            logger.info("Ignoring failing tests and proceeding")
          end

          def handle_incorrect_passcode(actual_code)
            logger.error("Wrong code: #{actual_code}")
            raise Upsteem::Deploy::Errors::DeployError, "Cancellation due to failing tests"
          end
        end
      end
    end
  end
end
