require "spec_helper"
Upsteem::Deploy::SpecHelperLoader.require_shared_contexts_for("unit/logger")

describe Upsteem::Deploy::Services::TestRunners::Skipper do
  include_context "setup for logger"

  let(:logger) { instance_double("Logger") }

  let(:runner) { described_class.new(logger) }

  describe "#run_tests" do
    subject { runner.run_tests }

    before do
      expect_logger_info("Running tests during deploy has not been enabled for this project")
    end

    it { is_expected.to eq(nil) }
  end
end
