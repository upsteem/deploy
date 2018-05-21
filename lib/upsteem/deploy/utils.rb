module Upsteem
  module Deploy
    module Utils
      class << self
        def generate_numeric_code(number_of_digits)
          # Double asterisk (**) is exponentiation (e.g. 10**4 == 10000)
          format("%0#{number_of_digits}d", rand(10**number_of_digits))
        end
      end
    end
  end
end
