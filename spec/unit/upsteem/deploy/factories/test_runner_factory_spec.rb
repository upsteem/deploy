require "spec_helper"

describe Upsteem::Deploy::Factories::TestRunnerFactory do
  let(:framework) { :rspec }
  let(:sub_factory) { Upsteem::Deploy::Factories::TestRunners::RspecFactory }
  let(:test_runner) { instance_double("Upsteem::Deploy::Services::TestRunners::Rspec") }

  let(:configuration) { instance_double("Upsteem::Deploy::ConfigurationSections::TestsConfiguration") }
  let(:services_container) { instance_double("Upsteem::Deploy::ServicesContainer") }

  def stub_framework_from_configuration
    allow(configuration).to receive(:framework).and_return(framework)
  end

  def stub_configuration_attributes
    stub_framework_from_configuration
  end

  shared_context "skipper creation" do
    let(:sub_factory) { Upsteem::Deploy::Factories::TestRunners::SkipperFactory }
    let(:test_runner) { instance_double("Upsteem::Deploy::Services::TestRunners::Skipper") }
  end

  def stub_creation_by_sub_factory
    allow(sub_factory).to receive(:create).with(
      configuration, services_container
    ).and_return(test_runner)
  end

  it_behaves_like "uninitializable"

  describe ".create" do
    subject { described_class.create(configuration, services_container) }

    before do
      stub_configuration_attributes
      stub_creation_by_sub_factory
    end

    it { is_expected.to eq(test_runner) }

    context "when test run disabled via configuration" do
      include_context "skipper creation"
      let(:framework) { :not_applicable }

      it { is_expected.to eq(test_runner) }
    end

    context "when configuration missing" do
      include_context "skipper creation"
      let(:configuration) { nil }

      def stub_configuration_attributes; end

      it { is_expected.to eq(test_runner) }
    end

    context "when unsupported framework configured" do
      let(:framework) { :minitest }
      let(:predefined_exception) do
        [Upsteem::Deploy::Errors::ConfigurationError, "Unsupported test framework: :minitest"]
      end

      it_behaves_like "exception raiser"
    end
  end
end
