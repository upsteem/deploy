require "spec_helper"
Upsteem::Deploy::SpecHelperLoader.require_shared_contexts_and_examples_for("unit/tasks/deployment")

describe Upsteem::Deploy::Tasks::ApplicationDeployment do
  include_context "setup for deployment tasks"
  include_context "examples for deployment tasks"

  include_context "sub-task", Upsteem::Deploy::Tasks::CapistranoDeployment, :capistrano_deployment

  def expect_environment_execution
    configure_expectation_for_sub_task(:capistrano_deployment)
  end

  describe "#run" do
    it_behaves_like "run"
  end
end
