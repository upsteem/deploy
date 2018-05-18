Upsteem::Deploy::SpecHelperLoader.require_shared_examples_for("unit/tasks")

shared_context "examples for deployment tasks" do
  include_context "examples for tasks"

  shared_examples_for "run" do
    include_context "expectations for run"

    context "when feature branch given" do
      it_behaves_like "normal run"

      context "when a deploy error occurs" do
        let(:capistrano_deployment_occurrences) { 0 }
        let(:notification_occurrences) { 0 }

        include_context(
          "occurrence of exception", :feature_branch_inclusion_flow,
          Upsteem::Deploy::Errors::DeployError, "Failed to merge in feature branch"
        )

        it_behaves_like "normal run"
      end

      context "when a deploy error with a cause occurs" do
        let(:capistrano_deployment_occurrences) { 0 }
        let(:notification_occurrences) { 0 }

        include_context(
          "occurrence of exception with cause", :feature_branch_inclusion_flow,
          Upsteem::Deploy::Errors::DeployError, "Failed to merge in feature branch",
          "Merge conflict"
        )

        it_behaves_like "normal run"
      end
    end

    context "when feature branch not given" do
      include_context "gems update flow"

      it_behaves_like "normal run"

      context "when a deploy error occurs" do
        let(:capistrano_deployment_occurrences) { 0 }
        let(:notification_occurrences) { 0 }

        include_context(
          "occurrence of exception", :gems_update_flow,
          Upsteem::Deploy::Errors::DeployError, "Bundle failed"
        )

        it_behaves_like "normal run"
      end

      context "when a deploy error with a cause occurs" do
        let(:capistrano_deployment_occurrences) { 0 }
        let(:notification_occurrences) { 0 }

        include_context(
          "occurrence of exception with cause", :gems_update_flow,
          Upsteem::Deploy::Errors::DeployError, "Bundle failed",
          "Could not connect"
        )

        it_behaves_like "normal run"
      end
    end
  end
end
