module Upsteem
  module Deploy
    module Services
      class System
        def call(command)
          result = system(command)
          return handle_call_failure(command, result) unless result
          true
        end

        private

        def handle_call_failure(command, result)
          status = $? && $?.exitstatus
          raise_error(
            "Command #{command.inspect} failed by returning #{result.inspect}. " \
            "Exit status from last process: #{status.inspect}."
          )
        end

        def raise_error(message)
          raise Errors::DeployError, message
        end
      end
    end
  end
end
