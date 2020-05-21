module Upsteem
  module Deploy
    class Configuration
      module Constants
        # Default mapping of environment names into branches.
        TARGET_BRANCHES = {
          "dev" => "dev",
          "staging" => "staging",
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
