module Upsteem
  module Deploy
    class Configuration
      module Constants
        # Names of environments supported by default.
        SUPPORTED_ENVIRONMENTS = %w[dev staging production].tap do |list|
          list.each(&:freeze)
          list.freeze
        end

        # Default mapping of environment names into branches.
        TARGET_BRANCHES = {
          "production" => "master"
        }.tap do |h|
          h.each do |_, v|
            v.freeze
          end
          h.freeze
        end
      end
    end
  end
end
