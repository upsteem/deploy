module Upsteem
  module Deploy
    module Tasks
      class Notification < Task
        extend Memoist

        def run
          logger.info("Sending deploy notification")
          make_request
          logger.info("Notification sent")
          true
        end

        private

        attr_reader :notification_configuration, :system, :git

        def make_request
          conn = Faraday.new(url: notification_configuration.url)
          conn.post do |req|
            req.headers["Content-Type"] = "application/json"
            req.body = request_body
          end
        end

        def request_body
          {
            environment: environment.name,
            username: system.current_user_name,
            repository: notification_configuration.repository,
            revision: git.head_revision
          }.to_json
        end
        memoize :request_body
      end
    end
  end
end
