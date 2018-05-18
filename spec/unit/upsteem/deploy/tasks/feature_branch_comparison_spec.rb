require "spec_helper"
Upsteem::Deploy::SpecHelperLoader.require_shared_contexts_and_examples_for("unit/tasks")

describe Upsteem::Deploy::Tasks::FeatureBranchComparison do
  include_context "setup for tasks"
  include_context "examples for tasks"
  include_context "git operations"

  it_behaves_like "feature branch dependent"

  let(:up_to_date) { true }

  describe "#run" do
    before do
      expect_to_receive_exactly_ordered_and_return(1, git_proxy, :must_be_in_sync!, up_to_date, feature_branch)
    end

    it_behaves_like "normal run"
  end
end
