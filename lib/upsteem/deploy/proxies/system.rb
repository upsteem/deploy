module Upsteem
  module Deploy
    module Proxies
      class System
        def call(command)
          system(command)
          raise_error "No exitstatus container available for #{command.inspect}" unless $?
          raise_error "Command #{command.inspect} failed with status #{$?.exitstatus}" unless $?.exitstatus.zero?
          true
        end

        def current_user_name
          `whoami`
        end

        private

        def raise_error(message)
          raise Errors::DeployError, message
        end
      end
    end
  end
end
