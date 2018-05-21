module Upsteem
  module Deploy
    module Factories
      module TestSuiteRunners
        class SkipperFactory
          extend Uninitializable

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
