module Upsteem
  module Deploy
    module Builders
      class HttpRequest
        extend Usage

        def build
          validate
          http_request
        end

        def url(url)
          http_request.url = url.presence
        end

        def http_method(name)
          http_request.http_method = name.presence
        end

        def header(name, value)
          http_request.headers[name.to_s] = value
        end

        def content_type(value)
          header("Content-Type", value)
        end

        def param(key, value)
          http_request.params[key.to_sym] = value
        end

        private

        attr_reader :http_request

        def initialize
          @http_request = Models::HttpRequest.new
        end

        def validate
          validate_url
          validate_http_method
        end

        def validate_url
          http_request.url || raise("URL not set during build")
        end

        def validate_http_method
          http_request.http_method || raise("HTTP method not set during build")
        end
      end
    end
  end
end
