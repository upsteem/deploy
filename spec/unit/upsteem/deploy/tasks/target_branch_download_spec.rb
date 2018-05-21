require "spec_helper"
Upsteem::Deploy::SpecHelperLoader.require_shared_contexts_and_examples_for("unit/tasks")

describe Upsteem::Deploy::Tasks::TargetBranchDownload do
  include_context "setup for tasks"
  include_context "examples for tasks"

  include_context "git operations"

  def expect_git_checkout
    expect_to_receive_exactly_ordered(
      1, git_service, :checkout, target_branch
    )
  end

  def expect_git_pull
    expect_to_receive_exactly_ordered(
      1, git_service, :pull, "origin", target_branch
    )
  end

  describe "#run" do
    before do
      expect_git_checkout
      expect_git_pull
    end

    it_behaves_like "normal run"
  end
end
