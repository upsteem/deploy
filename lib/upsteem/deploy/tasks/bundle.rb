module Upsteem
  module Deploy
    module Tasks
      class Bundle < Task
        private(*delegate(:bundler, to: :configuration))

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
          return unless configuration.gems_to_update.present?
          bundler.update_gems(configuration.gems_to_update)
          logger.info("Bundle update OK")
        end

        def overwrite_gemfile_with_environment_one
          return unless configuration.gems_to_update.present?
          FileUtils.cp("#{GEMFILE}.#{environment.name}", GEMFILE)
        end
      end
    end
  end
end
