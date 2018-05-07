module Upsteem
  module Deploy
    module Proxies
      class Bundler
        def execute_command(command)
          system.call("bundle exec #{command}")
        end

        def install_gems
          system.call("bundle")
        rescue Errors::DeployError => e
          raise Errors::DeployError, "Bundle install failed: #{e}"
        end

        def update_gems(gem_names)
          gem_names.map { |name| update_gem(name) }.last
        end

        private

        attr_reader :system

        def initialize(system)
          @system = system
        end

        def update_gem(name)
          system.call("bundle update --source #{name}")
        rescue Errors::DeployError => e
          raise Errors::DeployError, "Bundle update failed: #{e}"
        end
      end
    end
  end
end
