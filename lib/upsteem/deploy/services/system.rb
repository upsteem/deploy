module Upsteem
  module Deploy
    module Services
      class System
        def call(command)
          system(command)
          raise_error "No exitstatus container available for #{command.inspect}" unless $?
          raise_error "Command #{command.inspect} failed with status #{$?.exitstatus}" unless $?.exitstatus.zero?
          true
        end

        private

        def raise_error(message)
          raise Errors::DeployError, message
        end
      end
    end
  end
end
