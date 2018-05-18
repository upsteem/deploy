module Upsteem
  module Deploy
    class Environment
      class Factory
        def self.create(configuration, name, feature_branch)
          Builder.build do |builder|
            builder.configure!(name, feature_branch, configuration)
          end
        end
      end
    end
  end
end
