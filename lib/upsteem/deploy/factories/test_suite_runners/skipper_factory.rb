module Upsteem
  module Deploy
    module Factories
      module TestSuiteRunners
        module SkipperFactory
          def self.create(_configuration, services_container)
            Services::TestSuiteRunners::Skipper.new(
              services_container.logger
            )
          end
        end
      end
    end
  end
end
