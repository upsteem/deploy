module Upsteem
  module Deploy
    module ConfigurationSections
      class Section
        private

        attr_reader :data

        def initialize(data)
          @data = data || raise(ArgumentError, "Configuration data not supplied")
          validate_data
        end

        # Override.
        def validate_data; end
      end
    end
  end
end
