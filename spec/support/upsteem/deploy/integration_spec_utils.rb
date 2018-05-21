module Upsteem
  module Deploy
    # Generic helper methods for integration specs.
    module IntegrationSpecUtils
      def project_path
        File.join(File.dirname(__FILE__), "../../../../")
      end

      # Path relative to project path.
      def fake_config_path_relative_to_project(file_name)
        File.join("spec/support/upsteem/deploy/fake_config", file_name)
      end
    end
  end
end
