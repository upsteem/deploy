module Upsteem
  module Deploy
    module Tasks
      # Full deployment flow compatible with executable projects a.k.a. applications.
      class ApplicationDeployment < Deployment
        private

        def execute_environment
          run_sub_task(Tasks::CapistranoDeployment)
        end
      end
    end
  end
end
