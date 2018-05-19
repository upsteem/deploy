module Upsteem
  module Deploy
    module Services
      module TestRunners
        class Base
          def run_tests
            raise NotImplementedError, "Test runners must implement run_tests() instance method"
          end
        end
      end
    end
  end
end
