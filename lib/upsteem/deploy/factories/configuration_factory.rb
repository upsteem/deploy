module Upsteem
  module Deploy
    module Factories
      module ConfigurationFactory
        class << self
          def create(unchecked_project_path, unchecked_config_file_path)
            project_path = parse_project_path(unchecked_project_path)
            options = parse_config_file(project_path, unchecked_config_file_path)
            Configuration.new(project_path, options)
          end

          private

          def parse_project_path(unchecked_project_path)
            project_path = Utils.normalize_string(unchecked_project_path)
            raise(ArgumentError, "Project path must be supplied!") unless project_path
            raise(ArgumentError, "Project path must be a directory!") unless File.directory?(project_path)
            project_path
          end

          def parse_config_file(project_path, unchecked_config_file_path)
            config_file_path = Utils.normalize_string(unchecked_config_file_path)
            return {} unless config_file_path
            Utils.load_yaml(project_path, config_file_path)
          end
        end
      end
    end
  end
end
