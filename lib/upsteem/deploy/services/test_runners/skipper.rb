module Upsteem
  module Deploy
    module Services
      module TestRunners
        class Skipper < Base
          def run_tests
            logger.info("Running tests during deploy has not been enabled for this project")
            nil
          end

          private

          attr_reader :logger

          def initialize(logger)
            @logger = logger
          end
        end
      end
    end
  end
end
