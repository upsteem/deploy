module Upsteem
  module Deploy
    class Environment
      module Setup
        def self.extended(base)
          base.private_class_method(:new)
        end

        def set_up(configuration, name, feature_branch)
          new(
            parse_configuration(configuration),
            parse_name(configuration, name),
            parse_feature_branch(feature_branch)
          )
        end

        private

        def parse_configuration(configuration)
          configuration || raise(ArgumentError, "Configuration must be supplied!")
        end

        def parse_name(configuration, str)
          name = str.to_s.strip
          raise_error("Environment name cannot be blank") unless name.present?
          raise_error("Environment not supported: #{name.inspect}") unless supported?(configuration, name)
          name
        end

        def parse_feature_branch(str)
          str.to_s.strip.presence
        end

        def supported?(configuration, name)
          configuration.environment_supported?(name)
        end

        def raise_error(message)
          raise Errors::InvalidEnvironment, message
        end
      end
    end
  end
end
