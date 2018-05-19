module Upsteem
  module Deploy
    # Prohibits external instance creation in a class that extends this module.
    module Uninitializable
      def self.extended(base)
        base.private_class_method(:new)
      end
    end
  end
end
