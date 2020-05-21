describe Upsteem::Deploy::Configuration do
  let(:configuration) { described_class.new(project_path, options) }

  let(:project_path) { "/path/to/something" }
  let(:options) { { project_path: "/something/else/not/usable" } }

  let(:logger) { instance_double("Logger") }

  let(:test_suite_config_file_path) { "config/test_suite.yml" }
  let(:test_suite_section) { instance_double("Upsteem::Deploy::ConfigurationSections::TestSuiteConfiguration") }

  let(:notifications_config_file_path) { "config/notifications.yml" }
  let(:notifications_section) { instance_double("Upsteem::Deploy::ConfigurationSections::NotificationConfiguration") }

  def stub_configuration_section_creation(section_class, config_file_path, section)
    allow(Upsteem::Deploy::ConfigurationSections::Factory).to receive(
      :create_from_yaml_file
    ).once.with(
      section_class, project_path, config_file_path
    ).and_return(section)
  end

  def stub_notifications_configuration_creation
    stub_configuration_section_creation(
      Upsteem::Deploy::ConfigurationSections::NotificationConfiguration,
      notifications_config_file_path, notifications_section
    )
  end

  def stub_test_suite_configuration_creation
    stub_configuration_section_creation(
      Upsteem::Deploy::ConfigurationSections::TestSuiteConfiguration,
      test_suite_config_file_path, test_suite_section
    )
  end

  before do
    stub_notifications_configuration_creation
    stub_test_suite_configuration_creation
  end

  describe ".new" do
    subject { configuration }

    it { is_expected.to eq(configuration) }
  end

  describe "#supported_environments" do
    subject { configuration.supported_environments }

    shared_examples_for "constant returner" do
      it { is_expected.to eq(%w[dev staging production]) }
    end

    context "when option with the same name given" do
      let(:options) { { supported_environments: %w[foo bar baz] } }

      it_behaves_like "constant returner"
    end

    context "when target_branches option given" do
      let(:options) { { target_branches: { "foo" => "bar", baz: "etc" } } }

      it_behaves_like "constant returner"
    end

    context "when additional_target_branches option given" do
      let(:options) { { additional_target_branches: { "foo" => "bar", baz: "etc" } } }

      it { is_expected.to eq(%w[dev staging production foo baz]) }
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
      it_behaves_like "checker", "master", false
      it_behaves_like "checker", "foo", false
    end

    it_behaves_like "checker against constant"

    context "when supported_environments option given" do
      let(:options) { { supported_environments: %w[foo bar baz] } }

      it_behaves_like "checker against constant"
    end

    context "when target_branches option given" do
      let(:options) { { target_branches: { "foo" => "bar", baz: "etc" } } }

      it_behaves_like "checker against constant"
    end

    context "when additional_target_branches option given" do
      let(:options) { { additional_target_branches: { "foo" => "bar", baz: "etc" } } }

      it_behaves_like "checker", "dev", true
      it_behaves_like "checker", "staging", true
      it_behaves_like "checker", "production", true
      it_behaves_like "checker", "foo", true
      it_behaves_like "checker", "bar", false
      it_behaves_like "checker", "baz", true
      it_behaves_like "checker", "etc", false
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
      it_behaves_like "not found", "foo"
      it_behaves_like "not found", ""
      it_behaves_like "not found", nil
    end

    it_behaves_like "finder from constant"

    context "when target_branches option given" do
      let(:options) { { target_branches: { "foo" => "bar" } } }

      it_behaves_like "finder from constant"
    end

    context "when additional_target_branches option given" do
      let(:options) { { additional_target_branches: { "foo" => "bar", baz: "etc" } } }

      it_behaves_like "found", "dev", "dev"
      it_behaves_like "found", "staging", "staging"
      it_behaves_like "found", "production", "master"
      it_behaves_like "found", "foo", "bar"
      it_behaves_like "found", "baz", "etc"
      it_behaves_like "not found", "bar"
      it_behaves_like "not found", "etc"
      it_behaves_like "not found", ""
      it_behaves_like "not found", nil
    end
  end

  describe "#logger" do
    subject do
      configuration.logger
      configuration.logger
    end

    it { is_expected.to eq(nil) }

    context "when option given" do
      let(:options) { { logger: logger } }

      it { is_expected.to eq(logger) }
    end
  end

  describe "#shared_gems_to_update" do
    subject { configuration.shared_gems_to_update }

    it { is_expected.to eq([]) }

    context "when option given" do
      let(:options) { { shared_gems_to_update: %w[gem1 gem2 gem3] } }

      it { is_expected.to eq(%w[gem1 gem2 gem3]) }
    end
  end

  describe "#env_gems_to_update" do
    subject { configuration.env_gems_to_update }

    it { is_expected.to eq([]) }

    context "when option given" do
      let(:options) { { env_gems_to_update: %w[gem1 gem2 gem3] } }

      it { is_expected.to eq(%w[gem1 gem2 gem3]) }
    end
  end

  describe "#test_suite" do
    subject do
      configuration.test_suite
      configuration.test_suite
    end

    let(:test_suite_config_file_path) { nil }

    it { is_expected.to eq(test_suite_section) }

    context "when option given" do
      let(:options) { { test_suite: test_suite_config_file_path } }

      it { is_expected.to eq(test_suite_section) }
    end
  end

  describe "#notifications" do
    subject do
      configuration.notifications
      configuration.notifications
    end

    let(:notifications_config_file_path) { nil }

    it { is_expected.to eq(notifications_section) }

    context "when option given" do
      let(:options) { { notifications: notifications_config_file_path } }

      it { is_expected.to eq(notifications_section) }
    end
  end
end
