require "spec_helper"
Upsteem::Deploy::SpecHelperLoader.require_shared_contexts_and_examples_for("unit/tasks")

describe Upsteem::Deploy::Tasks::CapistranoDeployment do
  include_context "setup for tasks"
  include_context "examples for tasks"
  include_context "logging"
  include_context "capistrano operations"

  describe "#run" do
    let(:capistrano_deploy_occurrences) { 1 }
    let(:capistrano_deploy_success_occurrences) { 1 }

    def expect_capistrano_deploy
      expect_to_receive_exactly_ordered(
        capistrano_deploy_occurrences, capistrano_service, :deploy, environment
      )
    end

    before do
      expect_logger_info("Starting capistrano deploy")
      expect_capistrano_deploy
      expect_logger_info("Capistrano deploy OK", capistrano_deploy_success_occurrences)
    end

    it_behaves_like "normal run"
  end
end
