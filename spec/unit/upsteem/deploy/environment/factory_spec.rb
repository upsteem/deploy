require "spec_helper"

describe Upsteem::Deploy::Environment::Factory do
  let(:builder_class) do
    class_double("Upsteem::Deploy::Environment::Builder").as_stubbed_const(
      transfer_nested_constants: true
    )
  end

  let(:services_container) { instance_double("Upsteem::Deploy::ServicesContainer") }
  let(:configuration) { instance_double("Upsteem::Deploy::Configuration") }
  let(:builder) { instance_double("Upsteem::Deploy::Environment::Builder") }
  let(:environment) { instance_double("Upsteem::Deploy::Environment") }

  let(:name) { "someenv" }
  let(:feature_branch) { "somebranch" }

  describe ".create" do
    subject { described_class.create(services_container, configuration, name, feature_branch) }

    before do
      allow(builder_class).to receive(:build).and_yield(builder).and_return(environment)
      expect(builder).to receive(:services).with(services_container).once
      expect(builder).to receive(:configure).with(name, feature_branch, configuration).once
    end

    it { is_expected.to eq(environment) }
  end
end
