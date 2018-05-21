module Upsteem
  module Deploy
    module Factories
      module TestSuiteRunners
        module RspecFactory
          def self.create(configuration, services_container)
            Services::TestSuiteRunners::Rspec.new(
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
