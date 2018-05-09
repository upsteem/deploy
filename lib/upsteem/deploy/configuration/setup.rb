module Upsteem
  module Deploy
    class Configuration
      module Setup
        def self.extended(base)
          base.private_class_method(:new)
        end

        def set_up(project_path, options = {})
          new(
            parse_project_path(project_path),
            options
          )
        end

        private

        def parse_project_path(str)
          project_path = str && str.strip
          raise(ArgumentError, "Project path must be supplied!") unless project_path.present?
          raise(ArgumentError, "Project path must be a directory!") unless File.directory?(project_path)
          project_path
        end
      end
    end
  end
end
