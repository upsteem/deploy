module Upsteem
  module Deploy
    module Proxies
      class Notifier
        def notify
          return unless configuration
          log_request
          response = make_request
          handle_response(response)
        rescue Faraday::Error => e
          handle_error(e)
        end

        private

        attr_reader :configuration, :environment, :logger, :git

        def initialize(configuration, environment, logger, git)
          @configuration = configuration
          @environment = environment
          @logger = logger
          @git = git
        end

        def log_request
          logger.info("Making HTTP POST request to #{configuration.url}")
          logger.info("Request body: #{request_body}")
        end

        def make_request
          conn = Faraday.new(url: configuration.url)
          conn.post do |req|
            req.headers["Content-Type"] = "application/json"
            req.body = request_body
          end
        end

        def request_body
          {
            environment: environment.name,
            username: git.user_name,
            repository: configuration.repository,
            revision: git.head_revision
          }.to_json
        end

        def handle_response(response)
          logger.info("Response status: #{response.status}")
          logger.info("Response body: #{response.body}")
          true
        end

        def handle_error(error)
          logger.error("HTTP error occurred: #{error.class} (#{error.message})")
          false
        end
      end
    end
  end
end
