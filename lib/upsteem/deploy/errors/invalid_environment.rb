module Upsteem
  module Deploy
    module Errors
      class InvalidEnvironment < DeployError
        delegate :supported_environments, to: :configuration

        private

        attr_reader :configuration

        def initialize(environment_name, configuration)
          @configuration = configuration || raise(ArgumentError, "Configuration not supplied")
          super("Invalid environment: #{environment_name.inspect}")
        end
      end
    end
  end
end
