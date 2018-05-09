module Upsteem
  module Deploy
    module MockingHelpers
      def expect_to_receive_exactly_ordered(times, receiver, method_name, *method_args)
        if times > 0
          receive_expectations = receive_with_args_exactly_ordered(
            times, method_name, *method_args
          ).tap do |e|
            yield(e) if block_given?
          end

          expect(receiver).to(receive_expectations)
        else
          # RSpec does not allow to use all features seen above when 0 times expected.
          expect(receiver).not_to receive_with_args(method_name, *method_args)
        end
      end

      def expect_to_receive_exactly_ordered_and_return(times, receiver, method_name, return_val, *method_args)
        expect_to_receive_exactly_ordered(times, receiver, method_name, *method_args) do |expectation|
          expectation.and_return(return_val)
        end
      end

      def expect_to_receive_exactly_ordered_and_raise(times, receiver, method_name, exception, *method_args)
        expect_to_receive_exactly_ordered(times, receiver, method_name, *method_args) do |expectation|
          expectation.and_raise(*exception)
        end
      end

      private

      def receive_with_args(method_name, *method_args)
        if method_args.present?
          receive(method_name).with(*method_args)
        else
          receive(method_name).with(no_args)
        end
      end

      def receive_with_args_exactly(times, method_name, *method_args)
        receive_with_args(method_name, *method_args).exactly(times)
      end

      def receive_with_args_exactly_ordered(times, method_name, *method_args)
        receive_with_args_exactly(times, method_name, *method_args).ordered
      end
    end
  end
end
