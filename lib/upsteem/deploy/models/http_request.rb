module Upsteem
  module Deploy
    module Models
      class HttpRequest
        attr_accessor :url, :http_method
        attr_reader :headers, :params

        private

        def initialize
          @headers = {}
          @params = {}
        end
      end
    end
  end
end
