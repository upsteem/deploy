require "spec_helper"
Upsteem::Deploy::SpecHelperLoader.require_shared_contexts_and_examples_for(
  "unit/services/test_suite_runners/runner"
)

describe Upsteem::Deploy::Services::TestSuiteRunners::Rspec do
  include_context "setup for test suite runner"
  include_context "examples for test suite runner"

  let(:framework) { :rspec }

  def expect_test_suite_command
    expect_to_receive_exactly_ordered(
      1, bundler, :execute_command, "rspec"
    )
  end

  def expect_failing_test_suite_command
    expect_to_receive_exactly_ordered_and_raise(
      1, bundler, :execute_command, bundler_exception, "rspec"
    )
  end

  describe "#run_test_suite" do
    it_behaves_like "typical test suite run"
  end
end
