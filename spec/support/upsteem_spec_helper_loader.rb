module Upsteem
  module SpecHelperLoader
    class << self
      def require_shared_contexts_for(path)
        require_helper("shared_contexts/#{path}")
      end

      def require_shared_examples_for(path)
        require_helper("shared_examples/#{path}")
      end

      # Convenience method that can be used when the relative path.
      # of shared contexts and examples is equal.
      def require_shared_contexts_and_examples_for(path)
        require_shared_contexts_for(path)
        require_shared_examples_for(path)
      end

      private

      def require_helper(path)
        require(File.join(File.dirname(__FILE__), "#{path}.rb"))
      end
    end
  end
end
