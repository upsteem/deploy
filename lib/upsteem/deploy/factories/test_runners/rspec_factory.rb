module Upsteem
  module Deploy
    module Factories
      module TestRunners
        class RspecFactory
          extend Uninitializable

          def self.create(configuration, services_container)
            Services::TestRunners::Rspec.new(
              configuration,
              services_container.bundler,
              services_container.logger
            )
          end
        end
      end
    end
  end
end
