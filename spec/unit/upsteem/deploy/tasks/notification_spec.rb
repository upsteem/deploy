require "spec_helper"
Upsteem::Deploy::SpecHelperLoader.require_shared_contexts_and_examples_for("unit/tasks")

describe Upsteem::Deploy::Tasks::Notification do
  include_context "setup for tasks"
  include_context "examples for tasks"
  include_context "notifier operations"

  describe "#run" do
    let(:notification_occurrences) { 1 }

    def expect_notify
      expect_to_receive_exactly_ordered(
        notification_occurrences, notifier_service, :notify
      )
    end

    before do
      expect_notify
    end

    it_behaves_like "normal run"
  end
end
