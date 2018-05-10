require "spec_helper"
Upsteem::Deploy::SpecHelperLoader.require_shared_contexts_and_examples_for("unit/tasks")

describe Upsteem::Deploy::Tasks::FeatureBranchMerging do
  include_context "setup for tasks"
  include_context "examples for tasks"

  include_context "logging"
  include_context "git operations"

  it_behaves_like "feature branch dependent"

  def expect_merge_commit_creation_and_further
    expect_to_receive_exactly_ordered(
      1, git_proxy, :create_merge_commit, "origin/#{feature_branch}"
    )
    expect_logger_info("Finished merging feature branch into #{environment_name} environment")
  end

  describe "#run" do
    before do
      expect_logger_info("Starting to merge feature branch into #{environment_name} environment")
      expect_to_receive_exactly_ordered(
        1, git_proxy, :must_be_current_branch!, target_branch
      )
      expect_merge_commit_creation_and_further
    end

    it_behaves_like "normal run"

    context "when merge conflict occurs" do
      let(:predefined_exception) do
        [Upsteem::Deploy::Errors::MergeConflict, "Gemfile.lock conflict!"]
      end

      def expect_merge_commit_creation_and_further
        expect_to_receive_exactly_ordered_and_raise(
          1, git_proxy, :create_merge_commit, predefined_exception, "origin/#{feature_branch}"
        )
        expect_logger_action(:error, "Feature branch merging into #{environment_name} failed due to merge conflict")
        expect_to_receive_exactly_ordered(1, git_proxy, :abort_merge)
      end

      it_behaves_like "error run"
    end
  end
end
