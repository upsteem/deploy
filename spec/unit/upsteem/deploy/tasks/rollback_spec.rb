require "spec_helper"
Upsteem::Deploy::SpecHelperLoader.require_shared_contexts_and_examples_for("unit/tasks")

describe Upsteem::Deploy::Tasks::Rollback do
  include_context "setup for tasks"
  include_context "examples for tasks"
  include_context "logging"
  include_context "rollbacker operations"
  include_context "task with options"

  let(:cause) { Upsteem::Deploy::Errors::DeployError.new("Something went wrong") }
  let(:task_options) { { cause: cause } }

  let(:service_result) { true }
  let(:run_result) { service_result }

  def expect_rollback
    expect_to_receive_exactly_ordered_and_return(
      1, rollbacker_service, :rollback, service_result, cause
    )
  end

  def expect_events_after_rollback; end

  describe "#run" do
    before do
      expect_rollback
      expect_events_after_rollback
    end

    it_behaves_like "normal run"

    context "when rollbacker service raises error" do
      let(:service_exception_class) { Upsteem::Deploy::Errors::DeployError }
      let(:service_exception_message) { "Rollback failed" }
      let(:run_result) { false }

      def expect_rollback
        expect_to_receive_exactly_ordered_and_raise(
          1, rollbacker_service, :rollback, [service_exception_class, service_exception_message], cause
        )
      end

      def expect_events_after_rollback
        expect_logger_error("#{service_exception_message} (#{service_exception_class})")
      end

      it_behaves_like "normal run"
    end
  end
end
