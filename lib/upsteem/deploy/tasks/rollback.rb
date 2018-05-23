module Upsteem
  module Deploy
    module Tasks
      class Rollback < Task
        def run
          rollbacker.rollback(options[:cause])
        rescue Errors::DeployError => e
          logger.error("#{e.message} (#{e.class})")
          false
        end

        private

        attr_reader :rollbacker

        def inject(services_container)
          @rollbacker = services_container.rollbacker
        end
      end
    end
  end
end
