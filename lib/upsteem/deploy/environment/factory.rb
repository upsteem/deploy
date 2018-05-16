module Upsteem
  module Deploy
    class Environment
      class Factory
        def self.create(services_container, configuration, name, feature_branch)
          Builder.build do |builder|
            builder.services(services_container)
            builder.configure(name, feature_branch, configuration)
          end
        end
      end
    end
  end
end
