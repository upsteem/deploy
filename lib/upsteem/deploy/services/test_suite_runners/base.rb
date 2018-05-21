module Upsteem
  module Deploy
    module Services
      module TestSuiteRunners
        class Base
          def run_test_suite
            raise NotImplementedError, "Test runners must implement run_test_suite() instance method"
          end
        end
      end
    end
  end
end
