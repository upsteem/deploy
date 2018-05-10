module Upsteem
  module Deploy
    module Tasks
      # Parent class for all tasks
      class Task
        def run
          raise NotImplementedError, "Subclasses of Task must implement 'run' instance method"
        end

        private

        attr_reader :environment, :options

        def initialize(environment, options = {})
          @environment = environment
          @options = options
          after_initialize
        end

        # Override this if necessary.
        def after_initialize; end

        def run_sub_task(klass, options = {})
          klass.new(environment, options).run
        end

        def feature_branch
          environment.feature_branch
        end

        def target_branch
          environment.target_branch
        end

        def logger
          environment.logger
        end

        def git
          environment.git
        end
      end
    end
  end
end
