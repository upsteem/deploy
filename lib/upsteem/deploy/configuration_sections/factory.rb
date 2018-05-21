module Upsteem
  module Deploy
    module ConfigurationSections
      class Factory
        # This class shold only contain class methods.
        class << self
          private :new

          def create_from_yaml_file(section_class, project_path, file_path)
            return unless file_path
            data = YAML.load_file(File.join(project_path, file_path)).deep_symbolize_keys
            section_class.new(data)
          end
        end
      end
    end
  end
end
