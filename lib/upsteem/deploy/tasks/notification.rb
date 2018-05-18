module Upsteem
  module Deploy
    module Tasks
      class Notification < Task
        def run
          logger.info("Sending deploy notification")
          notifier.notify
          logger.info("Notification sent")
          true
        end

        private

        attr_reader :notifier

        def inject(services_container)
          @notifier = services_container.notifier
        end
      end
    end
  end
end
