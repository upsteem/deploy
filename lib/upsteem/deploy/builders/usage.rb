module Upsteem
  module Deploy
    module Builders
      module Usage
        def self.extended(base)
          base.private_class_method(:new)
        end

        def build
          builder = new
          yield(builder)
          builder.build
        end
      end
    end
  end
end
