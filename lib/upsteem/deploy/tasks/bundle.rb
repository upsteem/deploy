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
          bundler.install_gems
          logger.info("Bundle install OK")
        end

        def update_gems
          return unless environment.env_gems_to_update.present?
          bundler.update_gems(environment.env_gems_to_update)
          logger.info("Bundle update OK")
        end

        def overwrite_gemfile_with_environment_one
          return unless environment.env_gems_to_update.present?
          FileUtils.cp("#{GEMFILE}.#{environment.name}", GEMFILE)
        end

        def bundler
          environment.bundler
        end
      end
    end
  end
end
