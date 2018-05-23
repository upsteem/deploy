module Upsteem
  module Deploy
    module Factories
      module TestSuiteRunners
        module RspecFactory
          def self.create(configuration, services_container)
            Services::TestSuiteRunners::Rspec.new(
              configuration,
              services_container.logger,
              services_container.input_service,
              services_container.bundler
            )
          end
        end
      end
    end
  end
end
