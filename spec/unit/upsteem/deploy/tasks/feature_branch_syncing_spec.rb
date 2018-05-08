require "spec_helper"
Upsteem::Deploy::SpecHelperLoader.require_shared_contexts_and_examples_for("unit/tasks")

describe Upsteem::Deploy::Tasks::FeatureBranchSyncing do
  include_context "setup for tasks"
  include_context "examples for tasks"

  include_context "logging"
  include_context "git operations"

  it_behaves_like "feature branch dependent"

  def expect_merge_commit_creation_and_further
    expect_to_receive_exactly_ordered(1, git_proxy, :create_merge_commit, "origin/master")
    expect_to_receive_exactly_ordered(
      1, git_proxy, :commit, "Sync #{feature_branch} with origin/master", all: true
    )
    expect_to_receive_exactly_ordered(1, git_proxy, :push, "origin", feature_branch)
    expect_logger_info("Syncing successful")
  end

  describe "#run" do
    before do
      expect_logger_info("Starting to sync #{feature_branch} with origin/master")
      expect_to_receive_exactly_ordered(1, git_proxy, :checkout, feature_branch)
      expect_merge_commit_creation_and_further
    end

    it_behaves_like "normal run"

    context "when merge conflict occurs" do
      let(:predefined_exception) do
        [Upsteem::Deploy::Errors::MergeConflict, "Gemfile.lock conflict!"]
      end

      def expect_merge_commit_creation_and_further
        expect_to_receive_exactly_ordered_and_raise(
          1, git_proxy, :create_merge_commit, predefined_exception, "origin/master"
        )
        expect_logger_action(:error, "Syncing failed due to merge conflict")
        expect_to_receive_exactly_ordered(1, git_proxy, :abort_merge)
      end

      it_behaves_like "error run"
    end
  end
end
