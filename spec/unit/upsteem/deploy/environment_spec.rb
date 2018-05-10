require "spec_helper"

describe Upsteem::Deploy::Environment do
  let(:configuration) { instance_double("Upsteem::Deploy::Configuration") }
  let(:name) { "production" }
  let(:feature_branch) { "DEV-123" }
  let(:supported) { true }
  let(:target_branch) { "master" }

  let(:project_path) { "/path/to/project" }
  let(:logger) { instance_double("Logger") }
  let(:git) { instance_double("Upsteem::Deploy::Proxies::Git") }
  let(:bundler) { instance_double("Upsteem::Deploy::Proxies::Bundler") }
  let(:capistrano) { instance_double("Upsteem::Deploy::Proxies::Capistrano") }
  let(:env_gems_to_update) { %w[foo bar baz] }

  let(:configuration_arg) { configuration }
  let(:name_arg) { name }
  let(:feature_branch_arg) { feature_branch }

  let(:environment) do
    described_class.set_up(
      configuration_arg, name_arg, feature_branch_arg
    )
  end

  shared_examples_for "delegator to configuration" do
    before do
      allow(configuration).to receive(nested_method).and_return(nested_result)
    end

    it { is_expected.to eq(nested_result) }
  end

  before do
    if configuration
      allow(configuration).to receive(
        :environment_supported?
      ).with(name).once.and_return(supported)

      allow(configuration).to receive(
        :find_target_branch
      ).with(name).once.and_return(target_branch)
    end
  end

  describe ".new" do
    subject do
      described_class.new(configuration_arg, name_arg, feature_branch_arg)
    end

    it_behaves_like "exception raiser", NoMethodError
  end

  describe ".set_up" do
    subject { environment }

    shared_examples_for "instance returner" do
      it { is_expected.to be_instance_of(described_class) }

      it "sets and exposes name" do
        expect(subject.name).to eq(name)
      end

      it "sets and exposes feature branch" do
        expect(subject.feature_branch).to eq(feature_branch)
      end
    end

    shared_examples_for "feature branchless instance returner" do |arg|
      let(:feature_branch) { nil }
      let(:feature_branch_arg) { arg }
      it_behaves_like "instance returner"
    end

    shared_examples_for "invalid environment error raiser" do
      let(:error_class) { Upsteem::Deploy::Errors::InvalidEnvironment }
      let(:predefined_exception) { [error_class, exception_message] }

      it_behaves_like "exception raiser"
    end

    shared_examples_for "invalid environment error raiser on blank name" do |name|
      let(:name) { name }
      let(:exception_message) { "Environment name cannot be blank" }
      it_behaves_like "invalid environment error raiser"
    end

    it_behaves_like "instance returner"

    context "when arguments need formatting" do
      let(:name_arg) { "  #{name}  " }
      let(:feature_branch_arg) { " #{feature_branch}  " }
      it_behaves_like "instance returner"
    end

    context "when feature branch is missing" do
      it_behaves_like "feature branchless instance returner", ""
      it_behaves_like "feature branchless instance returner", nil
    end

    context "when configuration is missing" do
      let(:configuration) { nil }
      it_behaves_like "exception raiser", ArgumentError, "Configuration must be supplied!"
    end

    context "when environment name is missing" do
      it_behaves_like "invalid environment error raiser on blank name", ""
      it_behaves_like "invalid environment error raiser on blank name", nil
    end

    context "when environment is not supported" do
      let(:supported) { false }
      let(:exception_message) { "Environment not supported: #{name.inspect}" }
      it_behaves_like "invalid environment error raiser"
    end
  end

  describe "#target_branch" do
    subject do
      # Call it twice to test if memoization works:
      environment.target_branch
      environment.target_branch
    end

    it { is_expected.to eq(target_branch) }
  end

  describe "#project_path" do
    let(:nested_method) { :project_path }
    let(:nested_result) { project_path }

    subject { environment.project_path }

    it_behaves_like "delegator to configuration"
  end

  describe "#logger" do
    let(:nested_method) { :logger }
    let(:nested_result) { logger }

    subject { environment.logger }

    it_behaves_like "delegator to configuration"
  end

  describe "#git" do
    let(:nested_method) { :git }
    let(:nested_result) { git }

    subject { environment.git }

    it_behaves_like "delegator to configuration"
  end

  describe "#bundler" do
    let(:nested_method) { :bundler }
    let(:nested_result) { bundler }

    subject { environment.bundler }

    it_behaves_like "delegator to configuration"
  end

  describe "#capistrano" do
    let(:nested_method) { :capistrano }
    let(:nested_result) { capistrano }

    subject { environment.capistrano }

    it_behaves_like "delegator to configuration"
  end

  describe "#env_gems_to_update" do
    let(:nested_method) { :env_gems_to_update }
    let(:nested_result) { env_gems_to_update }

    subject { environment.env_gems_to_update }

    it_behaves_like "delegator to configuration"
  end
end
