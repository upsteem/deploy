module Upsteem
  module Deploy
    module Factories
      module TestRunners
        class SkipperFactory
          extend Uninitializable

          def self.create(_configuration, services_container)
            Services::TestRunners::Skipper.new(
              services_container.logger
            )
          end
        end
      end
    end
  end
end
