%w[
  skipper_factory
  rspec_factory
].each do |file|
  require_relative("test_runners/#{file}")
end

module Upsteem
  module Deploy
    module Factories
      class TestRunnerFactory
        extend Uninitializable

        SKIPPER_FACTORY = Factories::TestRunners::SkipperFactory

        RUNNER_FACTORIES = {
          rspec: Factories::TestRunners::RspecFactory,
          not_applicable: SKIPPER_FACTORY
        }.freeze

        class << self
          def create(configuration, services_container)
            choose_factory(configuration).create(configuration, services_container)
          end

          private

          def choose_factory(configuration)
            return SKIPPER_FACTORY unless configuration
            RUNNER_FACTORIES[configuration.framework] || raise_error(
              "Unsupported test framework: #{configuration.framework.inspect}"
            )
          end

          def raise_error(message)
            raise Errors::ConfigurationError, message
          end
        end
      end
    end
  end
end
