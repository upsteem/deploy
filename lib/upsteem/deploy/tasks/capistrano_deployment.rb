module Upsteem
  module Deploy
    module Tasks
      class CapistranoDeployment < Task
        def run
          logger.info("Starting capistrano deploy")
          capistrano.deploy(environment)
          logger.info("Capistrano deploy OK")
          true
        end

        private

        def capistrano
          environment.capistrano
        end
      end
    end
  end
end
