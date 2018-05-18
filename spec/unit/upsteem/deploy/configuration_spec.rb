require "spec_helper"

describe Upsteem::Deploy::Configuration do
  let(:project_path) { "/path/to/something" }
  let(:project_path_as_arg) { project_path }
  let(:project_path_is_directory) { true }
  let(:options) { { project_path: "/something/else/not/usable" } }

  let(:logger) { instance_double("Logger") }

  let(:notifications_config_file_path) { "config/notifications.yml" }
  let(:notifications_section) { instance_double("Upsteem::Deploy::ConfigurationSections::NotificationConfiguration") }

  shared_context "default instance" do
    let(:configuration) { described_class.set_up(project_path_as_arg) }
  end

  shared_context "custom instance" do
    let(:configuration) { described_class.set_up(project_path_as_arg, options) }
  end

  before do
    allow(File).to receive(:directory?).with(project_path).and_return(project_path_is_directory)
    allow(Upsteem::Deploy::ConfigurationSections::Factory).to receive(
      :create_from_yaml_file
    ).once.with(
      Upsteem::Deploy::ConfigurationSections::NotificationConfiguration,
      project_path, notifications_config_file_path
    ).and_return(notifications_section)
  end

  describe ".new" do
    subject { described_class.new(project_path_as_arg, options) }

    it_behaves_like "exception raiser", NoMethodError
  end

  describe ".set_up" do
    subject { configuration }

    shared_examples_for "instance returner" do
      it { is_expected.to be_instance_of(described_class) }

      it "sets and exposes project path" do
        expect(subject.project_path).to eq(project_path)
      end
    end

    shared_examples_for "instance returner or error raiser" do
      it_behaves_like "instance returner"

      context "when project path needs formatting" do
        let(:project_path_as_arg) { " #{project_path}  " }
        it_behaves_like "instance returner"
      end

      context "when project path is not a directory" do
        let(:project_path_is_directory) { false }
        it_behaves_like "exception raiser", ArgumentError, "Project path must be a directory!"
      end

      context "when project path is blank string" do
        let(:project_path) { "" }
        it_behaves_like "exception raiser", ArgumentError, "Project path must be supplied!"
      end
    end

    context "when options argument not given" do
      include_context "default instance"
      it_behaves_like "instance returner or error raiser"
    end

    context "when options argument given" do
      include_context "custom instance"
      it_behaves_like "instance returner or error raiser"
    end
  end

  describe "#supported_environments" do
    subject { configuration.supported_environments }

    shared_examples_for "constant returner" do
      it { is_expected.to eq(%w[dev staging production]) }
    end

    context "when options not given" do
      include_context "default instance"
      it_behaves_like "constant returner"
    end

    context "when options given" do
      let(:options) { { supported_environments: %w[foo bar baz] } }
      include_context "custom instance"
      it_behaves_like "constant returner"
    end
  end

  describe "#environment_supported?" do
    shared_examples_for "checker" do |given_env, expected_result|
      subject { configuration.environment_supported?(given_env) }

      it { is_expected.to eq(expected_result) }
    end

    shared_examples_for "checker against constant" do
      it_behaves_like "checker", "dev", true
      it_behaves_like "checker", "staging", true
      it_behaves_like "checker", "production", true
      it_behaves_like "checker", "foo", false
    end

    context "when options not given" do
      include_context "default instance"
      it_behaves_like "checker against constant"
    end

    context "when options given" do
      let(:options) { { supported_environments: %w[foo bar baz] } }
      include_context "custom instance"
      it_behaves_like "checker against constant"
    end
  end

  describe "#find_target_branch" do
    shared_examples_for "found" do |given_env, expected_result|
      subject { configuration.find_target_branch(given_env) }

      it { is_expected.to eq(expected_result) }
    end

    shared_examples_for "not found" do |given_env|
      subject { configuration.find_target_branch(given_env) }

      it_behaves_like(
        "exception raiser", ArgumentError,
        "Target branch not found for #{given_env.inspect} environment"
      )
    end

    shared_examples_for "finder from constant" do
      it_behaves_like "found", "dev", "dev"
      it_behaves_like "found", "staging", "staging"
      it_behaves_like "found", "production", "master"
      it_behaves_like "found", "foo", "foo"
      it_behaves_like "not found", ""
      it_behaves_like "not found", nil
    end

    context "when options not given" do
      include_context "default instance"
      it_behaves_like "finder from constant"
    end

    context "when options given" do
      let(:options) { { target_branches: { "foo" => "bar" } } }
      include_context "custom instance"
      it_behaves_like "finder from constant"
    end
  end

  describe "#logger" do
    subject do
      configuration.logger
      configuration.logger
    end

    context "when options not given" do
      include_context "default instance"

      it { is_expected.to eq(nil) }
    end

    context "when options given" do
      let(:options) { { logger: logger } }
      include_context "custom instance"

      it { is_expected.to eq(logger) }
    end
  end

  describe "#shared_gems_to_update" do
    subject { configuration.shared_gems_to_update }

    context "when options not given" do
      include_context "default instance"

      it { is_expected.to eq([]) }
    end

    context "when options given" do
      let(:options) { { shared_gems_to_update: %w[gem1 gem2 gem3] } }
      include_context "custom instance"

      it { is_expected.to eq(%w[gem1 gem2 gem3]) }
    end
  end

  describe "#env_gems_to_update" do
    subject { configuration.env_gems_to_update }

    context "when options not given" do
      include_context "default instance"

      it { is_expected.to eq([]) }
    end

    context "when options given" do
      let(:options) { { env_gems_to_update: %w[gem1 gem2 gem3] } }
      include_context "custom instance"

      it { is_expected.to eq(%w[gem1 gem2 gem3]) }
    end
  end

  describe "#notifications" do
    subject do
      configuration.notifications
      configuration.notifications
    end

    context "when options not given" do
      include_context "default instance"
      let(:notifications_config_file_path) { nil }

      it { is_expected.to eq(notifications_section) }
    end

    context "when options given" do
      let(:options) { { notifications: notifications_config_file_path } }
      include_context "custom instance"

      it { is_expected.to eq(notifications_section) }
    end
  end
end
