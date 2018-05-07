require "spec_helper"
Upsteem::Deploy::SpecHelperLoader.require_shared_contexts_and_examples_for("unit/tasks")

describe Upsteem::Deploy::Tasks::TargetBranchUpload do
  include_context "setup for tasks"
  include_context "examples for tasks"

  include_context "logging"
  include_context "git operations"
  include_context "task with options"

  let(:current_branch) { target_branch }

  let(:commit_message) { "Merge from some branch" }
  let(:commit_options) { { all: true } }
  let(:commit_result) { "Commit successful" }

  let(:push_result) { "Already up-to-date" }

  let(:task_options) { { message: commit_message } }

  let(:committing_occurrences) { 1 }
  let(:pushing_occurrences) { 1 }

  before do
    allow(git_proxy).to receive(:current_branch).and_return(current_branch)
  end

  def expect_git_commit
    expect_to_receive_exactly_ordered_and_return(
      committing_occurrences, git_proxy, :commit, commit_result, commit_message, commit_options
    )
  end

  def expect_git_push
    expect_to_receive_exactly_ordered_and_return(
      pushing_occurrences, git_proxy, :push, push_result, "origin", target_branch
    )
  end

  describe "#run" do
    before do
      expect_logger_info("Committing to #{target_branch} branch", committing_occurrences)
      expect_logger_info(
        "Message: #{commit_message.inspect}, options: #{commit_options.inspect}", committing_occurrences
      )
      expect_git_commit
      expect_logger_info("Result: #{commit_result}", committing_occurrences)
      expect_logger_info("Pushing to origin/#{target_branch}", pushing_occurrences)
      expect_git_push
      expect_logger_info("Result: #{push_result}", pushing_occurrences)
      expect_logger_info("Target branch upload OK", pushing_occurrences)
    end

    it_behaves_like "normal run"

    context "when current branch is not target branch" do
      let(:current_branch) { "someotherbranch" }

      let(:predefined_exception) do
        [
          Upsteem::Deploy::Errors::DeployError,
          "Expected current branch to be #{target_branch}, but it was #{current_branch}"
        ]
      end

      let(:committing_occurrences) { 0 }
      let(:pushing_occurrences) { 0 }

      it_behaves_like "error run"
    end
  end
end
