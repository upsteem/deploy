require "spec_helper"

describe Upsteem::Deploy::Deployer do
  let(:task_class) { class_double("Upsteem::Deploy::Tasks::Task") }
  let(:project_path) { "/path/to/project" }
  let(:environment_name) { "staging" }
  let(:feature_branch) { "DEV-123" }
  let(:options) { { some: "thing" } }

  let(:supported_environments) { %w[foo bar baz] }
  let(:task_run_result) { "foo" }
  let(:environment_error_message) { "Environment setup failed" }
  let(:deploy_error_message) { "Git merge conflict" }

  let(:configuration) { instance_double("Upsteem::Deploy::Configuration") }
  let(:services_container) { instance_double("Upsteem::Deploy::ServicesContainer") }
  let(:environment) { instance_double("Upsteem::Deploy::Environment") }
  let(:task) { instance_double("Upsteem::Deploy::Tasks::Task") }

  def allow_configuration_setup
    allow(Upsteem::Deploy::Configuration).to receive(
      :set_up
    ).with(project_path, options).once.and_return(configuration)
  end

  def allow_services_container_setup
    allow(Upsteem::Deploy::ServicesContainer).to receive(
      :new
    ).with(configuration).once.and_return(services_container)
  end

  def allow_supported_environments_lookup
    allow(configuration).to receive(
      :supported_environments
    ).once.and_return(supported_environments)
  end

  def allow_environment_setup_without_specifying_outcome
    allow(Upsteem::Deploy::Environment::Factory).to receive(
      :create
    ).with(services_container, configuration, environment_name, feature_branch).once
  end

  def allow_environment_setup
    allow_environment_setup_without_specifying_outcome.and_return(environment)
  end

  shared_context "invalid environment error situation" do
    def allow_environment_setup
      allow_environment_setup_without_specifying_outcome.and_raise(
        Upsteem::Deploy::Errors::InvalidEnvironment, environment_error_message
      )
    end
  end

  def allow_task_setup
    allow(task_class).to receive(
      :new
    ).with(environment).once.and_return(task)
  end

  def allow_task_to_run_without_specifying_outcome
    allow(task).to receive(:run).once
  end

  def allow_task_to_run
    allow_task_to_run_without_specifying_outcome.and_return(task_run_result)
  end

  shared_context "deploy error situation" do
    def allow_task_to_run
      allow_task_to_run_without_specifying_outcome.and_raise(
        Upsteem::Deploy::Errors::DeployError, deploy_error_message
      )
    end
  end

  def allow_stdout_logging
    allow_any_instance_of(Upsteem::Deploy::Deployer).to receive(:puts)
  end

  before do
    allow_configuration_setup
    allow_services_container_setup
    allow_supported_environments_lookup
    allow_environment_setup
    allow_task_setup
    allow_task_to_run
    allow_stdout_logging
  end

  describe ".new" do
    subject do
      described_class.new(
        task_class, project_path, environment_name, feature_branch, options
      )
    end

    it_behaves_like "exception raiser", NoMethodError
  end

  describe ".deploy" do
    subject do
      described_class.deploy(
        task_class, project_path, environment_name, feature_branch, options
      )
    end

    it { is_expected.to eq(task_run_result) }

    context "when invalid environment error occurs" do
      include_context "invalid environment error situation"

      it { is_expected.to eq(nil) }
    end

    context "when generic deploy error occurs" do
      include_context "deploy error situation"

      it "does not catch it" do
        expect { subject }.to raise_error(
          Upsteem::Deploy::Errors::DeployError, deploy_error_message
        )
      end
    end
  end
end
