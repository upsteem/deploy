module Upsteem
  module Deploy
    module SpecExtensions
      module OrderedValidations
        def validation_passing_order
          raise(
            NotImplementedError,
            "self.validation_passing_order must be defined in order to use extensions from OrderedValidations"
          )
        end

        def validation_succeeds_until(attribute_name)
          validation_passing_order.each do |name|
            include_context("valid #{name}")
            return(true) if name == attribute_name
          end
          raise("No matching attribute in validation_passing_order found for #{attribute_name.inspect}")
        end

        def validation_succeeds
          validation_succeeds_until(validation_passing_order.last)
        end
      end
    end
  end
end
