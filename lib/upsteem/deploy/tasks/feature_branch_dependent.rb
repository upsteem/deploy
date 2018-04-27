module Upsteem
  module Deploy
    module Tasks
      # Additional functionality for tasks that require
      # the presence of feature branch to operate normally.
      module FeatureBranchDependent
        def self.included(base)
          base.extend(Memoist)
          base.memoize(:feature_branch)
        end

        private

        # Initialization hook for feature branch validation.
        def after_initialize
          feature_branch
        end

        def feature_branch
          environment.feature_branch || raise("Feature branch not supplied with environment")
        end
      end
    end
  end
end
