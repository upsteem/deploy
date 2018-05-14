require "spec_helper"

describe Upsteem::Deploy::ConfigurationSections::Factory do
  let(:section_class) { Upsteem::Deploy::ConfigurationSections::Section }
  let(:file_path) { fake_config_path_relative_to_project("example.yml") }

  describe ".create_from_yaml_file" do
    subject { described_class.create_from_yaml_file(section_class, project_path, file_path) }

    it { is_expected.to be_instance_of(section_class) }
  end
end
