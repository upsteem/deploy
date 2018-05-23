module Upsteem
  module Deploy
    module Services
      module TestSuiteRunners
        class Skipper < Base
          def run_test_suite
            logger.info("Test suite running during deploy has not been enabled for this project")
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
