module Upsteem
  module Deploy
    module Services
      class Notifier
        def notify
          return unless configuration
          response = make_request
          handle_response(response)
        rescue Upsteem::Deploy::Errors::HttpError => e
          handle_response_error(e)
        rescue Faraday::Error => e
          handle_connection_error(e)
        end

        private

        attr_reader :configuration, :environment, :logger, :git

        def initialize(configuration, environment, logger, git)
          @configuration = configuration
          @environment = environment
          @logger = logger
          @git = git
        end

        def log_request(request)
          logger.info("Request body: #{request.body}")
        end

        def create_connection(settings)
          logger.info("Connection settings: #{settings.inspect}")
          Faraday.new(settings)
        end

        def make_request
          conn = create_connection(url: configuration.url)
          conn.post do |req|
            req.headers["Content-Type"] = "application/json"
            req.body = request_body
            log_request(req)
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

        # 2xx is OK.
        def response_ok?(response)
          response.status.to_i / 100 == 2 # integer division
        end

        def handle_response(response)
          logger.info("Response status: #{response.status}")
          logger.info("Response body: #{response.body}")
          raise_error("Bad HTTP response status: #{response.status}") unless response_ok?(response)
          true
        end

        def raise_error(message)
          raise Upsteem::Deploy::Errors::HttpError, message
        end

        def handle_response_error(error)
          logger.error(error.message)
          false
        end

        def handle_connection_error(error)
          logger.error("HTTP connection error occurred: #{error.class} (#{error.message})")
          false
        end
      end
    end
  end
end
