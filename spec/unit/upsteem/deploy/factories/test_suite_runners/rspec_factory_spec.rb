require "spec_helper"

describe Upsteem::Deploy::Factories::TestSuiteRunners::RspecFactory do
  let(:configuration) { instance_double("Upsteem::Deploy::ConfigurationSections::TestSuiteConfiguration") }
  let(:logger) { instance_double("Logger") }
  let(:input_service) { instance_double("Upsteem::Deploy::Services::StandardInputService") }
  let(:bundler) { instance_double("Upsteem::Deploy::Services::Bundler") }

  let(:services_container) { instance_double("Upsteem::Deploy::ServicesContainer") }

  let(:service_class) { Upsteem::Deploy::Services::TestSuiteRunners::Rspec }
  let(:service) { instance_double("Upsteem::Deploy::Services::TestSuiteRunners::Rspec") }

  def stub_logger_from_services_container
    allow(services_container).to receive(:logger).and_return(logger)
  end

  def stub_input_service_from_services_container
    allow(services_container).to receive(:input_service).and_return(input_service)
  end

  def stub_bundler_from_services_container
    allow(services_container).to receive(:bundler).and_return(bundler)
  end

  def stub_service_creation
    allow(service_class).to receive(:new).with(
      configuration, logger, input_service, bundler
    ).and_return(service)
  end

  describe ".create" do
    subject { described_class.create(configuration, services_container) }

    before do
      stub_logger_from_services_container
      stub_input_service_from_services_container
      stub_bundler_from_services_container
      stub_service_creation
    end

    it { is_expected.to eq(service) }
  end
end
