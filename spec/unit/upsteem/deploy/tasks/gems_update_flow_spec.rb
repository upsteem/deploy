require "spec_helper"
Upsteem::Deploy::SpecHelperLoader.require_shared_contexts_and_examples_for("unit/tasks")

describe Upsteem::Deploy::Tasks::GemsUpdateFlow do
  include_context "setup for tasks"
  include_context "examples for tasks"

  include_context "sub-task", Upsteem::Deploy::Tasks::TargetBranchDownload, :target_branch_download
  include_context "sub-task", Upsteem::Deploy::Tasks::Bundle, :bundle
  include_context "sub-task", Upsteem::Deploy::Tasks::TargetBranchUpload, :target_branch_upload

  let(:target_branch_upload_options) do
    { message: "Deploy: update gems" }
  end

  describe "#run" do
    before do
      configure_expectation_for_sub_task(:target_branch_download)
      configure_expectation_for_sub_task(:bundle)
      configure_expectation_for_sub_task(:target_branch_upload)
    end

    it_behaves_like "normal run"
  end
end
