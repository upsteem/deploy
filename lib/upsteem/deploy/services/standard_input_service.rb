module Upsteem
  module Deploy
    module Services
      class StandardInputService
        def read
          STDIN.gets.strip
        end
      end
    end
  end
end
