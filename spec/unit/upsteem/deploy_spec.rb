describe Upsteem::Deploy do
  let(:arguments) do
    [project_path, environment_name, feature_branch, config_file_path]
  end

  before do
    allow(Upsteem::Deploy::Deployer).to receive(
      :deploy
    ).with(
      task_class, project_path, environment_name, feature_branch, config_file_path
    ).once.and_return(deploy_result)
  end

  let(:task_class) { class_double("Upsteem::Deploy::Tasks::Task") }
  let(:project_path) { "/path/to/project" }
  let(:environment_name) { "staging" }
  let(:feature_branch) { "DEV-123" }
  let(:config_file_path) { instance_double("String") }

  let(:deploy_result) { "foo" }

  shared_examples_for "deployer" do
    it { is_expected.to eq(deploy_result) }

    context "when config file path not given" do
      let(:arguments) { [project_path, environment_name, feature_branch] }
      let(:config_file_path) { nil }

      it { is_expected.to eq(deploy_result) }
    end
  end

  describe ".deploy_gem" do
    subject { described_class.deploy_gem(*arguments) }

    let(:task_class) { Upsteem::Deploy::Tasks::Deployment }

    it_behaves_like "deployer"
  end

  describe ".deploy_application" do
    let(:task_class) { Upsteem::Deploy::Tasks::ApplicationDeployment }

    subject { described_class.deploy_application(*arguments) }

    it_behaves_like "deployer"
  end
end
