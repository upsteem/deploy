require "spec_helper"

describe Upsteem::Deploy::ConfigurationSections::Factory do
  let(:section_class) { class_double("Upsteem::Deploy::ConfigurationSections::Section") }
  let(:section) { instance_double("Upsteem::Deploy::ConfigurationSections::Section") }

  let(:project_path) { "/path/to/project" }
  let(:file_path) { "config/something.yml" }
  let(:full_path) { "#{project_path}/#{file_path}" }

  let(:raw_data) { { "a" => { "b" => 123 } } }
  let(:data) { { a: { b: 123 } } }

  describe ".new" do
    subject { described_class.new }

    it_behaves_like "exception raiser", NoMethodError
  end

  describe ".create_from_yaml_file" do
    subject { described_class.create_from_yaml_file(section_class, project_path, file_path) }

    def allow_file_join
      allow(File).to receive(:join).with(project_path, file_path).and_return(full_path)
    end

    def allow_yaml_load
      allow(YAML).to receive(:load_file).with(full_path).and_return(raw_data)
    end

    def stub_loading_from_file
      allow_file_join
      allow_yaml_load
      allow(section_class).to receive(:new).with(data).and_return(section)
    end

    shared_context "no loading from file" do
      def stub_loading_from_file
        expect(File).to receive(:join).never
        expect(YAML).to receive(:load_file).never
      end
    end

    before do
      stub_loading_from_file
    end

    it { is_expected.to eq(section) }

    context "when file path missing" do
      include_context "no loading from file"
      let(:file_path) { nil }

      it { is_expected.to be_nil }
    end
  end
end
