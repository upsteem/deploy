require "spec_helper"
Upsteem::Deploy::SpecHelperLoader.require_shared_contexts_and_examples_for("unit/tasks")

describe Upsteem::Deploy::Tasks::TargetBranchDownload do
  include_context "setup for tasks"
  include_context "examples for tasks"

  include_context "logging"
  include_context "git operations"

  let(:checkout_result) { "Switched to branch '#{target_branch}'" }
  let(:pull_result) { "Already up-to-date." }

  def expect_git_checkout
    expect_to_receive_exactly_ordered_and_return(
      1, git_proxy, :checkout, checkout_result, target_branch
    )
  end

  def expect_git_pull
    expect_to_receive_exactly_ordered_and_return(
      1, git_proxy, :pull, pull_result, "origin", target_branch
    )
  end

  describe "#run" do
    before do
      expect_logger_info("Checking out #{target_branch} branch")
      expect_git_checkout
      expect_logger_info("Result: #{checkout_result}")
      expect_logger_info("Pulling in remote changes")
      expect_git_pull
      expect_logger_info("Result: #{pull_result}")
      expect_logger_info("Target branch download OK")
    end

    it_behaves_like "normal run"
  end
end
