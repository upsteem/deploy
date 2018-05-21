require "spec_helper"
Upsteem::Deploy::SpecHelperLoader.require_shared_contexts_for("unit/logger")

describe Upsteem::Deploy::Services::TestRunners::Rspec do
  include_context "setup for logger"

  let(:correct_passcode) { format("%05d", rand(100_000)) }
  let(:actual_passcode) { correct_passcode }

  let(:configuration) { instance_double("Upsteem::Deploy::ConfigurationSections::TestsConfiguration") }
  let(:bundler) { instance_double("Upsteem::Deploy::Services::Bundler") }
  let(:logger) { instance_double("Logger") }

  let(:runner) { described_class.new(configuration, bundler, logger) }

  def stub_passcode_generation
    allow(Upsteem::Deploy::Utils).to receive(:generate_numeric_code).with(5).and_return(correct_passcode)
  end

  def expect_rspec_command
    expect_to_receive_exactly_ordered(
      1, bundler, :execute_command, "rspec"
    )
  end

  def expect_events_after_rspec_command
    expect_logger_info("Tests successful")
  end

  shared_context "failing tests" do
    let(:bundler_exception_message) { "Command rspec failed with exit status 1" }
    let(:bundler_exception) do
      [Upsteem::Deploy::Errors::DeployError, bundler_exception_message]
    end

    def expect_rspec_command
      expect_to_receive_exactly_ordered_and_raise(
        1, bundler, :execute_command, bundler_exception, "rspec"
      )
    end

    def expect_events_after_rspec_command
      expect_logger_error(bundler_exception_message)
      expect_logger_error("Tests failed")
      expect_logger_info("")
      expect_continuation_instructions
      expect_passcode_input
      expect_events_after_passcode_input
    end

    def expect_continuation_instructions
      expect_logger_info("Your first priority should be stop doing whatever you are doing now and fix the failing tests!")
      expect_logger_info("Do you still want to proceed with the deploy despite the failing tests?")
      expect_logger_info("Please insert the following code to proceed: #{correct_passcode}. Or hit enter right away to cancel.")
    end

    def expect_passcode_input
      expect_to_receive_exactly_ordered_and_return(
        1, runner, :gets, " #{actual_passcode}\n"
      )
    end

    def expect_events_after_passcode_input
      expect_logger_info("Ignoring failing tests and proceeding")
    end
  end

  describe "#run_tests" do
    subject { runner.run_tests }

    before do
      stub_passcode_generation
      expect_logger_info("Starting to run tests using rspec")
      expect_rspec_command
      expect_events_after_rspec_command
    end

    it { is_expected.to eq(true) }

    context "when tests fail and user enters a correct passcode" do
      include_context "failing tests"

      it { is_expected.to eq(false) }
    end

    context "when tests fail and user enters an incorrect passcode" do
      include_context "failing tests"

      let(:actual_passcode) { "#{correct_passcode}123" }

      let(:predefined_exception) do
        [Upsteem::Deploy::Errors::FailingTestSuite, "Cancellation due to failing tests"]
      end

      def expect_events_after_passcode_input
        expect_logger_error("Wrong code: #{actual_passcode}")
      end

      it_behaves_like "exception raiser"
    end
  end
end
