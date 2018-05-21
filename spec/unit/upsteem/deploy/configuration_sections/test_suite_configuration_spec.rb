require "spec_helper"

describe Upsteem::Deploy::ConfigurationSections::TestSuiteConfiguration do
  let(:framework) { "sometestframework" }

  let(:data) do
    {
      framework: framework
    }
  end

  let(:section) { described_class.new(data) }

  describe "#framework" do
    subject { section.framework }

    it { is_expected.to eq(:sometestframework) }

    context "when framework not given in data" do
      let(:framework) { nil }

      it { is_expected.to eq(:rspec) }
    end
  end
end
