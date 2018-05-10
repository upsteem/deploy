require "spec_helper"
Upsteem::Deploy::SpecHelperLoader.require_shared_contexts_and_examples_for("unit/tasks")

describe Upsteem::Deploy::Tasks::TargetBranchUpload do
  include_context "setup for tasks"
  include_context "examples for tasks"

  include_context "git operations"
  include_context "task with options"

  let(:current_branch) { target_branch }

  let(:commit_message) { "Merge from some branch" }
  let(:commit_options) { { all: true } }

  let(:task_options) { { message: commit_message } }

  let(:validation_occurrences) { 1 }
  let(:committing_occurrences) { 1 }
  let(:pushing_occurrences) { 1 }

  before do
    allow(git_proxy).to receive(:current_branch).and_return(current_branch)
  end

  def expect_current_branch_validation
    expect_to_receive_exactly_ordered(
      validation_occurrences, git_proxy, :must_be_current_branch!, target_branch
    )
  end

  def expect_git_commit
    expect_to_receive_exactly_ordered(
      committing_occurrences, git_proxy, :commit, commit_message, commit_options
    )
  end

  def expect_git_push
    expect_to_receive_exactly_ordered(
      pushing_occurrences, git_proxy, :push, "origin", target_branch
    )
  end

  describe "#run" do
    before do
      expect_current_branch_validation
      expect_git_commit
      expect_git_push
    end

    it_behaves_like "normal run"

    context "when commit message not supplied" do
      let(:commit_message) { nil }

      let(:validation_occurrences) { 0 }
      let(:committing_occurrences) { 0 }
      let(:pushing_occurrences) { 0 }

      let(:predefined_exception) { [ArgumentError, "Commit message not supplied via :message option"] }

      it_behaves_like "error run"
    end
  end
end
