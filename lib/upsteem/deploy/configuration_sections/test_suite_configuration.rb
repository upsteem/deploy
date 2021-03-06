module Upsteem
  module Deploy
    module ConfigurationSections
      class TestSuiteConfiguration < Section
        extend Memoist

        DEFAULT_FRAMEWORK = :rspec

        def framework
          (data[:framework] || DEFAULT_FRAMEWORK).to_sym
        end
        memoize :framework
      end
    end
  end
end
