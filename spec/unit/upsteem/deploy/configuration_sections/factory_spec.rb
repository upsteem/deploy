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

    before do
      allow(File).to receive(:join).with(project_path, file_path).and_return(full_path)
      allow(YAML).to receive(:load_file).with(full_path).and_return(raw_data)
      allow(section_class).to receive(:new).with(data).and_return(section)
    end

    it { is_expected.to eq(section) }
  end
end
