require "spec_helper"

describe Upsteem::Deploy::Services::System do
  let(:service) { described_class.new }

  describe "#call" do
    let(:test_script) { integration_tool_path("system_exit_code") }
    let(:test_script_arg) { "true" }
    let(:call_arg) { "#{test_script} #{test_script_arg}" }

    # Some content in the exception message might be subject to platform-specific variations.
    # Let's just check the exception type.
    let(:predefined_exception) { [Upsteem::Deploy::Errors::DeployError] }

    subject { service.call(call_arg) }

    it { is_expected.to eq(true) }

    context "when command execution fails" do
      let(:test_script_arg) { "asdf" }
      it_behaves_like "exception raiser"
    end

    context "when command not found" do
      # Let's introduce a typo in file name:
      let(:test_script) { integration_tool_path("system_exitcode") }
      it_behaves_like "exception raiser"
    end
  end
end
