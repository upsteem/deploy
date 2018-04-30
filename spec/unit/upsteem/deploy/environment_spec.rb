require "spec_helper"
Upsteem::Deploy::SpecHelperLoader.require_shared_examples_for("exception_raiser")

describe Upsteem::Deploy::Environment do
  let(:configuration) { instance_double("Upsteem::Deploy::Configuration") }
  let(:name) { "production" }
  let(:feature_branch) { "DEV-123" }
  let(:supported) { true }
  let(:target_branch) { "master" }

  let(:configuration_arg) { configuration }
  let(:name_arg) { name }
  let(:feature_branch_arg) { feature_branch }

  let(:environment) do
    described_class.set_up(
      configuration_arg, name_arg, feature_branch_arg
    )
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

      it "sets and exposes configuration" do
        expect(subject.configuration).to eq(configuration)
      end

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

      it_behaves_like "predefined exception raiser"
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
end
