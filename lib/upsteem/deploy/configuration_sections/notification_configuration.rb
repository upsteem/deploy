module Upsteem
  module Deploy
    module ConfigurationSections
      class NotificationConfiguration < Section
        extend Memoist

        def url
          (url_template % credentials).freeze
        end
        memoize :url

        def repository
          deploy_data[:repository].freeze
        end
        memoize :repository

        private

        def deploy_data
          data[:deploy] || {}
        end
        memoize :deploy_data

        def credentials
          data[:credentials]
        end

        def url_template
          deploy_data[:url_template]
        end

        def validate_data
          validate_credentials
          validate_url_template
          validate_repository
        end

        def validate_credentials
          raise(ArgumentError, "Credentials not given in configuration data") unless credentials.present?
        end

        def validate_url_template
          raise(ArgumentError, "URL template not given in configuration data") unless url_template.present?
        end

        def validate_repository
          raise(ArgumentError, "Repository not given in configuration data") unless repository.present?
        end
      end
    end
  end
end
