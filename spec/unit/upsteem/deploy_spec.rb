require "spec_helper"

describe Upsteem::Deploy do
  let(:task_class) { class_double("Upsteem::Deploy::Tasks::Task") }
  let(:project_path) { "/path/to/project" }
  let(:environment_name) { "staging" }
  let(:feature_branch) { "DEV-123" }
  let(:options) { { some: "thing" } }

  let(:deploy_result) { "foo" }

  before do
    allow(Upsteem::Deploy::Deployer).to receive(
      :deploy
    ).with(
      task_class, project_path, environment_name, feature_branch, options
    ).once.and_return(deploy_result)
  end

  describe ".deploy_gem" do
    let(:task_class) { Upsteem::Deploy::Tasks::Deployment }

    subject do
      described_class.deploy_gem(
        project_path, environment_name, feature_branch, options
      )
    end

    it { is_expected.to eq(deploy_result) }
  end

  describe ".deploy_application" do
    let(:task_class) { Upsteem::Deploy::Tasks::ApplicationDeployment }

    subject do
      described_class.deploy_application(
        project_path, environment_name, feature_branch, options
      )
    end

    it { is_expected.to eq(deploy_result) }
  end
end
