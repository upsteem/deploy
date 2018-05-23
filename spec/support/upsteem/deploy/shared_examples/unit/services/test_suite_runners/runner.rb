shared_context "examples for test suite runner" do
  shared_examples_for "typical test suite run" do
    subject { runner.run_test_suite }

    before do
      stub_framework_from_configuration
      stub_passcode_generation
      expect_events_before_test_suite_command
      expect_test_suite_command
      expect_events_after_test_suite_command
    end

    it { is_expected.to eq(true) }

    context "when test suite fail and user enters a correct passcode" do
      include_context "failing test suite"

      it { is_expected.to eq(false) }
    end

    context "when test suite fail and user enters an incorrect passcode" do
      include_context "failing test suite"

      let(:actual_passcode) { "#{correct_passcode}123" }

      let(:predefined_exception) do
        [Upsteem::Deploy::Errors::FailingTestSuite, "Cancellation due to failing test suite"]
      end

      def expect_events_after_passcode_input
        expect_logger_error("Wrong code: #{actual_passcode}")
      end

      it_behaves_like "exception raiser"
    end
  end
end
