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

        attr_reader :bundler

        def install_gems
          bundler.install_gems
          logger.info("Bundle install OK")
        end

        def update_gems
          return unless environment.gems_to_update.present?
          bundler.update_gems(environment.gems_to_update)
          logger.info("Bundle update OK")
        end

        def overwrite_gemfile_with_environment_one
          return unless environment.gemfile_overwrite_needed
          FileUtils.cp("#{GEMFILE}.#{environment.name}", GEMFILE)
        end

        def inject(services_container)
          @bundler = services_container.bundler
        end
      end
    end
  end
end
