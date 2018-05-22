module Upsteem
  module Deploy
    module Tasks
      # Parent class for all tasks
      class Task
        def run
          raise NotImplementedError, "Subclasses of Task must implement 'run' instance method"
        end

        private

        attr_reader :services_container, :environment, :logger, :git, :options

        def initialize(services_container, options = {})
          _inject(services_container)
          @options = options
          after_initialize
        end

        # To add additional services, override inject() instead.
        def _inject(services_container)
          @services_container = services_container
          @environment = services_container.environment
          @logger = services_container.logger
          @git = services_container.git
          @rollbacker = services_container.rollbacker
          inject(services_container)
        end

        # Override this to inject additional services.
        def inject(services_container); end

        # Override this if necessary.
        def after_initialize; end

        def run_sub_task(klass, options = {})
          klass.new(services_container, options).run
        end

        def feature_branch
          environment.feature_branch
        end

        def target_branch
          environment.target_branch
        end
      end
    end
  end
end
