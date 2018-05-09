require "spec_helper"
Upsteem::Deploy::SpecHelperLoader.require_shared_contexts_and_examples_for("unit/tasks")

describe Upsteem::Deploy::Tasks::GitStatusValidation do
  include_context "setup for tasks"
  include_context "examples for tasks"

  include_context "logging"
  include_context "git operations"

  let(:changed) { {} }
  let(:added) { {} }
  let(:deleted) { {} }
  let(:untracked) { {} }

  let(:changed_count) { 0 }
  let(:added_count) { 0 }
  let(:deleted_count) { 0 }
  let(:untracked_count) { 0 }

  let(:untracked_files_logging_occurrences) { 0 }

  let(:status_result_description) do
    "According to git status, there are #{changed_count} changed, #{added_count} added, " \
    "#{deleted_count} deleted and #{untracked_count} untracked files. All of these should be 0."
  end

  let(:status) { instance_double("Git::Status") }

  def expect_git_status_checking
    expect_to_receive_exactly_ordered_and_return(1, git_proxy, :status, status)
  end

  def status_item
    instance_double("Git::Status::StatusFile")
  end

  def expect_result_logging
    expect_logger_info("Git status is clean")
  end

  before do
    allow(status).to receive(:changed).and_return(changed)
    allow(status).to receive(:added).and_return(added)
    allow(status).to receive(:deleted).and_return(deleted)
    allow(status).to receive(:untracked).and_return(untracked)
  end

  describe "#run" do
    before do
      expect_logger_info("Checking git status")
      expect_git_status_checking
      expect_result_logging
    end

    shared_examples_for "error on unclean status" do
      def expect_result_logging
        expect_logger_action(:error, status_result_description)
        expect_logger_action(:error, "Untracked files:", untracked_files_logging_occurrences)
        expect_logger_action(:error, untracked.keys.sort.join("\n"), untracked_files_logging_occurrences)
      end

      let(:predefined_exception) do
        [
          Upsteem::Deploy::Errors::DeployError,
          "Please take necessary steps (e.g. commit manually) until git status is clean!"
        ]
      end

      it_behaves_like "error run"
    end

    it_behaves_like "normal run"

    context "when there are changed files" do
      let(:changed) do
        { "/path/to/changed/file" => status_item }
      end
      let(:changed_count) { 1 }

      it_behaves_like "error on unclean status"
    end

    context "when there are added files" do
      let(:added) do
        { "/path/to/added/file" => status_item }
      end
      let(:added_count) { 1 }

      it_behaves_like "error on unclean status"
    end

    context "when there are deleted files" do
      let(:deleted) do
        { "/path/to/deleted/file" => status_item }
      end
      let(:deleted_count) { 1 }

      it_behaves_like "error on unclean status"
    end

    context "when there are untracked files" do
      let(:untracked) do
        {
          "/path/to/untracked/file" => status_item,
          "/path/to/another/untracked/file" => status_item
        }
      end
      let(:untracked_count) { 2 }
      let(:untracked_files_logging_occurrences) { 1 }

      it_behaves_like "error on unclean status"
    end
  end
end
