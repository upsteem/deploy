require "spec_helper"
Upsteem::Deploy::SpecHelperLoader.require_shared_contexts_and_examples_for("unit/services/git")
Upsteem::Deploy::SpecHelperLoader.require_shared_contexts_for("unit/logger")

describe Upsteem::Deploy::Services::VerboseGit do
  include_context "setup for git service"
  include_context "setup for logger"
  include_context "examples for git service"

  let(:logger) { instance_double("::Logger") }
  let(:git_service) { described_class.new(project_path, logger) }

  let(:messages_before) { [] }
  let(:messages_after) { [] }

  def expect_before_nested_method_call
    messages_before.each do |msg, action|
      action ||= :info
      expect_logger_action(action, msg)
    end
  end

  def expect_after_nested_method_call
    messages_after.each do |msg, action|
      action ||= :info
      expect_logger_action(action, msg)
    end
  end

  describe ".new" do
    it_behaves_like "instance creation success"
    it_behaves_like "instance creation failure on missing project path"

    context "when logger not supplied" do
      let(:logger) { nil }
      it_behaves_like "instance creation failure", ArgumentError, "Logger not supplied"
    end
  end

  describe "#current_branch" do
    include_context "setup for current_branch"
    it_behaves_like "current_branch instance method in Services::Git"
  end

  describe "#must_be_current_branch!" do
    include_context "setup for must_be_current_branch!"
    it_behaves_like "must_be_current_branch! instance method in Services::Git"
  end

  describe "#status" do
    include_context "setup for status"
    it_behaves_like "status instance method in Services::Git"
  end

  describe "#checkout" do
    include_context "setup for checkout"

    let(:messages_before) { ["Checking out #{branch}"] }
    let(:messages_after) { ["Result (checkout): #{nested_result}"] }

    it_behaves_like "checkout instance method in Services::Git"
  end

  describe "#pull" do
    include_context "setup for pull"

    let(:messages_before) { ["Pulling in changes from #{repository}/#{branch}"] }
    let(:messages_after) { ["Result (pull): #{nested_result}"] }

    it_behaves_like "pull instance method in Services::Git"
  end

  describe "#must_be_in_sync!" do
    include_context "setup for must_be_in_sync!"
    it_behaves_like "must_be_in_sync! instance method in Services::Git"
  end

  describe "#commit" do
    include_context "setup for commit"

    let(:messages_before) do
      ["Committing with message: #{commit_message.inspect}, options: #{commit_options.inspect}"]
    end
    let(:messages_after) { ["Result (commit): #{nested_result}"] }

    it_behaves_like "commit instance method in Services::Git"
  end

  describe "#push" do
    include_context "setup for push"

    let(:messages_before) { ["Pushing to #{remote}/#{branch}"] }
    let(:messages_after) { ["Result (push): #{nested_result}"] }

    it_behaves_like "push instance method in Services::Git"
  end

  describe "#create_merge_commit" do
    include_context "setup for create_merge_commit"

    let(:messages_before) { ["Starting to create a merge commit from #{branch} to #{current_branch}"] }
    let(:messages_after) { ["Result (create_merge_commit): #{nested_result}"] }

    it_behaves_like "create_merge_commit instance method in Services::Git"
  end

  describe "#abort_merge" do
    include_context "setup for abort_merge"

    let(:messages_before) { ["Starting to abort the merge"] }
    let(:messages_after) { ["Result (abort_merge): #{nested_result}"] }

    it_behaves_like "abort_merge instance method in Services::Git"
  end

  describe "#head_revision" do
    include_context "setup for head_revision"
    it_behaves_like "head_revision instance method in Services::Git"
  end

  describe "#user_name" do
    include_context "setup for user_name"
    it_behaves_like "user_name instance method in Services::Git"
  end
end
