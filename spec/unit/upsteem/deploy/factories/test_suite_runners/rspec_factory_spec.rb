require "spec_helper"

describe Upsteem::Deploy::Factories::TestSuiteRunners::RspecFactory do
  let(:bundler) { instance_double("Upsteem::Deploy::Services::Bundler") }
  let(:logger) { instance_double("Logger") }

  let(:configuration) { instance_double("Upsteem::Deploy::ConfigurationSections::TestSuiteConfiguration") }
  let(:services_container) { instance_double("Upsteem::Deploy::ServicesContainer") }

  let(:service_class) { Upsteem::Deploy::Services::TestSuiteRunners::Rspec }
  let(:service) { instance_double("Upsteem::Deploy::Services::TestSuiteRunners::Rspec") }

  def stub_bundler_from_services_container
    allow(services_container).to receive(:bundler).and_return(bundler)
  end

  def stub_logger_from_services_container
    allow(services_container).to receive(:logger).and_return(logger)
  end

  def stub_service_creation
    allow(service_class).to receive(:new).with(
      configuration, bundler, logger
    ).and_return(service)
  end

  it_behaves_like "uninitializable"

  describe ".create" do
    subject { described_class.create(configuration, services_container) }

    before do
      stub_bundler_from_services_container
      stub_logger_from_services_container
      stub_service_creation
    end

    it { is_expected.to eq(service) }
  end
end
