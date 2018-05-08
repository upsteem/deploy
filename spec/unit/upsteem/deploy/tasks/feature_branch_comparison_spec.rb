require "spec_helper"
Upsteem::Deploy::SpecHelperLoader.require_shared_contexts_and_examples_for("unit/tasks")

describe Upsteem::Deploy::Tasks::FeatureBranchComparison do
  include_context "setup for tasks"
  include_context "examples for tasks"

  include_context "logging"
  include_context "git operations"

  it_behaves_like "feature branch dependent"

  let(:up_to_date) { true }

  def expect_result_logging
    expect_logger_info("#{feature_branch} is in sync with remote repository")
  end

  describe "#run" do
    shared_examples_for "comparison failure or error" do
      # Nothing logged on error.
      def expect_result_logging; end

      it_behaves_like "error run"
    end

    before do
      expect_logger_info("Comparing #{feature_branch} with remote")
      expect_to_receive_exactly_ordered_and_return(1, git_proxy, :up_to_date?, up_to_date, feature_branch)
      expect_result_logging
    end

    it_behaves_like "normal run"

    context "when feature branch is not up-to-date" do
      let(:up_to_date) { false }

      let(:predefined_exception) do
        [
          Upsteem::Deploy::Errors::DeployError,
          "Please ensure that #{feature_branch} in your local repository " \
          "is in sync with the remote repository!"
        ]
      end

      it_behaves_like "comparison failure or error"
    end
  end
end
