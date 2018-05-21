module Upsteem
  module Deploy
    module Services
      module TestSuiteRunners
        class Rspec < Runner
          private

          def execute_test_suite_command
            bundler.execute_command("rspec")
          end
        end
      end
    end
  end
end
