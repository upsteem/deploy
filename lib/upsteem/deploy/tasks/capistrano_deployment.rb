module Upsteem
  module Deploy
    module Tasks
      class CapistranoDeployment < Task
        private(*delegate(:capistrano, to: :configuration))

        def run
          logger.info("Starting capistrano deploy")
          capistrano.deploy(environment)
          logger.info("Capistrano deploy OK")
          true
        end
      end
    end
  end
end
