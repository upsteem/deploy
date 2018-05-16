module Upsteem
  module Deploy
    class Environment
      class Builder
        extend BuilderInterface

        def build
          Validator.validate(environment)
          environment
        end

        def configure(name, feature_branch, configuration)
          name(name)
          feature_branch(feature_branch)
          apply_configuration(configuration)
          self
        end

        def services(services_container)
          logger(services_container)
          system(services_container)
          bundler(services_container)
          capistrano(services_container)
          git(services_container)
          notifier(services_container)
          self
        end

        private

        attr_reader :environment

        def initialize
          @environment = Environment.new
        end

        def name(str)
          environment.name = str && str.to_s.strip.presence
        end

        def feature_branch(str)
          environment.feature_branch = str && str.to_s.strip.presence
        end

        def apply_configuration(configuration)
          configure_name_dependent_features(configuration)
          configure_project_path(configuration)
          configure_gemfile_overwrite_necessity(configuration)
          configure_gems_to_update(configuration)
        end

        def configure_name_dependent_features(configuration)
          return unless environment.name
          configure_support(configuration)
          configure_target_branch(configuration)
        end

        def configure_support(configuration)
          environment.supported = configuration.environment_supported?(environment.name)
        end

        def configure_target_branch(configuration)
          environment.target_branch = configuration.find_target_branch(environment.name)
        end

        def configure_project_path(configuration)
          environment.project_path = configuration.project_path
        end

        def configure_gemfile_overwrite_necessity(configuration)
          environment.gemfile_overwrite_needed = configuration.env_gems_to_update.present?
        end

        def configure_gems_to_update(configuration)
          environment.gems_to_update = configuration.shared_gems_to_update + configuration.env_gems_to_update
        end

        def logger(services_container)
          environment.logger = services_container.logger
        end

        def system(services_container)
          environment.system = services_container.system
        end

        def bundler(services_container)
          environment.bundler = services_container.bundler
        end

        def capistrano(services_container)
          environment.capistrano = services_container.capistrano
        end

        def git(services_container)
          environment.git = services_container.git
        end

        def notifier(services_container)
          environment.notifier = services_container.notifier
        end
      end
    end
  end
end
