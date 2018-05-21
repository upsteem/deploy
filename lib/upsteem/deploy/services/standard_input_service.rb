module Upsteem
  module Deploy
    module Services
      class StandardInputService
        def ask(instructions)
          logger.info(instructions)
          STDIN.gets.strip
        end

        private

        attr_reader :logger

        def initialize(logger)
          @logger = logger
        end
      end
    end
  end
end
