require "spec_helper"

describe Upsteem::Deploy::ConfigurationSections::Section do
  let(:data) { { some: "thing" } }

  let(:section) { described_class.new(data) }

  describe ".new" do
    subject { section }

    it { is_expected.to be_instance_of(described_class) }

    shared_examples_for "when data missing" do
      shared_examples_for "error on missing data" do |blank_data|
        let(:data) { blank_data }
        it_behaves_like "exception raiser", ArgumentError, "Configuration data not supplied"
      end

      it_behaves_like "error on missing data", nil
    end
  end
end
