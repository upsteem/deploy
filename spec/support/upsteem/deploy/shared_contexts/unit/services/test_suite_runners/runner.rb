Upsteem::Deploy::SpecHelperLoader.require_shared_contexts_for("unit/logger")

shared_context "setup for test suite runner" do
  include_context "setup for logger"

  let(:correct_passcode) { format("%05d", rand(100_000)) }
  let(:actual_passcode) { correct_passcode }

  let(:configuration) { instance_double("Upsteem::Deploy::ConfigurationSections::TestSuiteConfiguration") }
  let(:logger) { instance_double("Logger") }
  let(:input_service) { instance_double("Upsteem::Deploy::Services::StandardInputService") }
  let(:bundler) { instance_double("Upsteem::Deploy::Services::Bundler") }

  let(:runner) { described_class.new(configuration, logger, input_service, bundler) }

  let(:framework) do
    raise(
      NotImplementedError,
      "let(:framework) { ... } must be defined in order to use features from " \
      "'setup for test suite runner' shared context"
    )
  end

  def stub_framework_from_configuration
    allow(configuration).to receive(:framework).and_return(framework)
  end

  def stub_passcode_generation
    allow(Upsteem::Deploy::Utils).to receive(:generate_numeric_code).with(5).and_return(correct_passcode)
  end

  def expect_events_before_test_suite_command
    expect_logger_info("Starting to run the test suite using #{framework}")
  end

  def expect_test_suite_command
    raise(
      NotImplementedError,
      "expect_test_suite_command instance method must be defined in order to use features from " \
      "'setup for test suite runner' shared context"
    )
  end

  def expect_failing_test_suite_command
    raise(
      NotImplementedError,
      "expect_failing_test_suite_command instance method must be defined in order to use features from " \
      "'setup for test suite runner' shared context"
    )
  end

  def expect_events_after_test_suite_command
    expect_logger_info("Tests successful")
  end

  shared_context "failing test suite" do
    let(:bundler_exception_message) { "Command failed with exit status 1" }
    let(:bundler_exception) do
      [Upsteem::Deploy::Errors::DeployError, bundler_exception_message]
    end

    def expect_test_suite_command
      expect_failing_test_suite_command
    end

    def expect_events_after_test_suite_command
      expect_logger_error(bundler_exception_message)
      expect_logger_error("Tests failed")
      expect_logger_info("")
      expect_continuation_instructions
      expect_passcode_input
      expect_events_after_passcode_input
    end

    def expect_continuation_instructions
      expect_logger_info("Your first priority should be stop doing whatever you are doing now and fix the failing tests!")
      expect_logger_info("Do you still want to proceed with the deploy despite the failing test suite?")
      expect_logger_info("Please insert the following code to proceed: #{correct_passcode}. Or hit enter right away to cancel.")
    end

    def expect_passcode_input
      expect_to_receive_exactly_ordered_and_return(1, input_service, :read, actual_passcode)
    end

    def expect_events_after_passcode_input
      expect_logger_info("Ignoring failing test suite and proceeding")
    end
  end
end
