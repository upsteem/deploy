module Upsteem
  module Deploy
    class Environment
      class Builder
        extend BuilderInterface

        def build
          environment
        end

        def configure!(name, feature_branch, configuration)
          name!(name, configuration)
          feature_branch!(feature_branch)
          apply_configuration!(configuration)
          self
        end

        private

        attr_reader :environment

        def initialize
          @environment = Environment.new
        end

        def name!(name, configuration)
          valid_name!(name && name.to_s.strip.presence, configuration)
        end

        def valid_name!(name, configuration)
          raise_error("Environment name is required") unless name
          raise_error("Environment not supported: #{name.inspect}") unless configuration.environment_supported?(name)
          environment.name = name
        end

        def feature_branch!(branch)
          environment.feature_branch = branch && branch.to_s.strip.presence
        end

        def apply_configuration!(configuration)
          target_branch!(configuration)
          project_path!(configuration)
          gemfile_overwrite_necessity!(configuration)
          gems_to_update!(configuration)
        end

        def target_branch!(configuration)
          environment.target_branch = configuration.find_target_branch(environment.name)
        end

        def project_path!(configuration)
          environment.project_path = configuration.project_path
        end

        def gemfile_overwrite_necessity!(configuration)
          environment.gemfile_overwrite_needed = configuration.env_gems_to_update.present?
        end

        def gems_to_update!(configuration)
          environment.gems_to_update = configuration.shared_gems_to_update + configuration.env_gems_to_update
        end

        def raise_error(error_msg)
          raise Upsteem::Deploy::Errors::InvalidEnvironment, error_msg
        end
      end
    end
  end
end
