module Upsteem
  module Deploy
    module ValidatorInterface
      def validate(validatable, *custom_initialization_args)
        new(validatable, *custom_initialization_args).validate
        true
      end
    end
  end
end
