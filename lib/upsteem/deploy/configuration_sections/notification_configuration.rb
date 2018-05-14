module Upsteem
  module Deploy
    module ConfigurationSections
      class NotificationConfiguration < Section
        extend Memoist

        def url
          url_template % credentials
        end
        memoize :url

        private

        def url_template
          data[:deploy_notification_url_template]
        end

        def credentials
          data[:credentials]
        end

        def validate_data
          validate_url_template
          validate_credentials
        end

        def validate_url_template
          raise(ArgumentError, "URL template not given in configuration data") unless url_template.present?
        end

        def validate_credentials
          raise(ArgumentError, "Credentials not given in configuration data") unless credentials.present?
        end
      end
    end
  end
end
