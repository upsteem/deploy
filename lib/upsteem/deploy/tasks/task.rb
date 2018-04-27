module Upsteem
  module Deploy
    module Tasks
      # Parent class for all tasks
      class Task
        private *delegate(:configuration, to: :environment)
        private *delegate(:logger, :git, to: :configuration)
        private *delegate(:target_branch, :feature_branch, to: :environment)

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
      end
    end
  end
end
