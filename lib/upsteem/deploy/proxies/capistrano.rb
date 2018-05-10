module Upsteem
  module Deploy
    module Proxies
      class Capistrano
        def deploy(environment)
          bundler.execute_command("cap #{environment.name} deploy")
        rescue Errors::DeployError => e
          raise Errors::DeployError, "Capistrano deploy failed: #{e}"
        end

        private

        attr_reader :bundler

        def initialize(bundler)
          @bundler = bundler
        end
      end
    end
  end
end
