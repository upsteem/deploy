module Upsteem
  module Deploy
    module ConfigurationSections
      class Factory
        # This class shold only contain class methods.
        class << self
          private :new

          def create_from_yaml_file(section_class, project_path, file_path)
            return unless file_path
            data = Utils.load_yaml(project_path, file_path)
            section_class.new(data)
          end
        end
      end
    end
  end
end
