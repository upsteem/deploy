module Upsteem
  module Deploy
    class Environment
      module Setup
        def self.extended(base)
          base.private_class_method(:new)
        end

        def set_up(configuration, name, feature_branch)
          new(
            configuration,
            parse_name(configuration, name),
            parse_feature_branch(feature_branch)
          )
        end

        private

        def supported?(name)
          SUPPORTED_ENVIRONMENTS.include?(name)
        end

        def parse_name(configuration, str)
          name = str.to_s.strip
          unless configuration.environment_supported?(name)
            raise(
              Errors::InvalidEnvironment.new(name, configuration)
            )
          end
          name
        end

        def parse_feature_branch(str)
          str.to_s.strip.presence
        end
      end
    end
  end
end
