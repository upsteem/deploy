module Upsteem
  module Deploy
    module Tasks
      class Bundle < Task
        GEMFILE = "Gemfile".freeze

        def run
          logger.info("Running bundle")
          overwrite_gemfile_with_environment_one
          install_gems
          update_gems
          true
        end

        private

        def install_gems
          system("bundle")
          raise Errors::DeployError, "Bundle install failed" unless success?
          logger.info("Bundle install OK")
        end

        def update_gems
          return unless configuration.gems_to_update.present?
          configuration.gems_to_update.each do |name|
            update_gem(name)
          end
          logger.info("Bundle update OK")
        end

        def update_gem(name)
          system("bundle update --source #{name}")
          raise Errors::DeployError, "Bundle update of gem #{name} failed" unless success?
        end

        def overwrite_gemfile_with_environment_one
          return if configuration.environment_invariant_project?
          FileUtils.cp("#{GEMFILE}.#{environment.name}", GEMFILE)
        end

        def success?
          $?.exitstatus.zero?
        end
      end
    end
  end
end
