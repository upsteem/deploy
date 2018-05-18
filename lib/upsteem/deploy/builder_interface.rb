module Upsteem
  module Deploy
    module BuilderInterface
      def build(*initialization_args)
        builder = new(*initialization_args)
        yield(builder) if block_given?
        builder.build
      end
    end
  end
end
