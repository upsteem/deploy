module Upsteem
  module Deploy
    module Utils
      class << self
        def generate_numeric_code(number_of_digits)
          # Double asterisk (**) is exponentiation (e.g. 10**4 == 10000)
          format("%0#{number_of_digits}d", rand(10**number_of_digits))
        end

        def load_yaml(project_path, relative_file_path)
          data = YAML.load_file(File.join(project_path, relative_file_path)) || {}
          data.deep_symbolize_keys
        end

        def normalize_string(str)
          str.to_s.strip.presence
        end
      end
    end
  end
end
