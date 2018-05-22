require "spec_helper"
Upsteem::Deploy::SpecHelperLoader.require_shared_contexts_for("unit/logger")

describe Upsteem::Deploy::Services::Rollbacker do
  include_context "setup for logger"

  let(:reason_class) { Upsteem::Deploy::Errors::DeployError }
  let(:reason_message) { "Something went wrong" }
  let(:reason) { reason_class.new(reason_message) }
  let(:feature_branch) { "somefeaturebranch" }

  let(:logger) { instance_double("Logger") }
  let(:git) { instance_double("Upsteem::Deploy::Services::Git") }
  let(:environment) { instance_double("Upsteem::Deploy::Environment") }

  let(:rollbacker) { described_class.new(logger, git, environment) }

  def stub_feature_branch_from_environment
    allow(environment).to receive(:feature_branch).and_return(feature_branch)
  end

  def expect_rollback_reason_logging
    expect_logger_info("Rollback reason: #{reason_message} (#{reason_class})")
  end

  def expect_events_before_rollback_actions
    expect_rollback_reason_logging
    expect_logger_info("Trying to roll back pending changes for the local repository")
  end

  def expect_abort_merge
    expect_to_receive_exactly_ordered(1, git, :abort_merge)
  end

  def expect_feature_branch_checkout
    expect_to_receive_exactly_ordered(1, git, :checkout, feature_branch)
  end

  def expect_events_after_rollback_actions
    expect_logger_info("Rollback done")
  end

  def expect_pending_changes_disclaimer
    expect_logger_info(
      "If there are any pending changes for the local repository, you'll have to revert them manually!"
    )
    expect_logger_info(
      "Also you might need to check your current branch as well before you continue investigation!"
    )
  end

  def expect_rollback_events
    expect_events_before_rollback_actions
    expect_abort_merge
    expect_feature_branch_checkout
    expect_events_after_rollback_actions
  end

  describe "#rollback" do
    subject { rollbacker.rollback(reason) }

    before do
      stub_feature_branch_from_environment
      expect_rollback_events
    end

    shared_examples_for "success" do
      it { is_expected.to eq(true) }
    end

    shared_examples_for "failure at merge abortion" do
      let(:merge_abortion_error_class) { Upsteem::Deploy::Errors::DeployError }
      let(:merge_abortion_error_message) { "There is no merge in process" }
      let(:merge_abortion_error) { [merge_abortion_error_class, merge_abortion_error_message] }

      let(:predefined_exception) do
        [Upsteem::Deploy::Errors::DeployError, "Rollback failed"]
      end

      def expect_abort_merge
        expect_to_receive_exactly_ordered_and_raise(
          1, git, :abort_merge, merge_abortion_error
        )
      end

      def expect_feature_branch_checkout; end

      def expect_events_after_rollback_actions
        expect_logger_error("#{merge_abortion_error_message} (#{merge_abortion_error_class})")
        expect_pending_changes_disclaimer
      end

      it_behaves_like "exception raiser"
    end

    it_behaves_like "success"
    it_behaves_like "failure at merge abortion"

    context "when there is no feature branch" do
      let(:feature_branch) { nil }

      def expect_rollback_events
        expect_rollback_reason_logging
        expect_logger_info("Not able to rollback anything, since there is no feature branch")
        expect_pending_changes_disclaimer
      end

      it { is_expected.to eq(false) }
    end
  end
end
