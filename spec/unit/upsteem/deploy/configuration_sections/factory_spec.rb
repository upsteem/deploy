describe Upsteem::Deploy::ConfigurationSections::Factory do
  describe ".new" do
    subject { described_class.new }

    it_behaves_like "exception raiser", NoMethodError
  end

  describe ".create_from_yaml_file" do
    subject { described_class.create_from_yaml_file(section_class, project_path, file_path) }

    shared_examples_for "loader" do
      before do
        allow(utils_module).to receive(:load_yaml).with(project_path, file_path).and_return(data)
        allow(section_class).to receive(:new).with(data).and_return(section)
      end

      it { is_expected.to eq(section) }
    end

    let(:project_path) { "/path/to/project" }
    let(:file_path) { "config/something.yml" }

    let(:utils_module) { class_double("Upsteem::Deploy::Utils").as_stubbed_const }
    let(:section_class) { class_double("Upsteem::Deploy::ConfigurationSections::Section") }
    let(:section) { instance_double("Upsteem::Deploy::ConfigurationSections::Section") }

    let(:data) { { a: { b: 123 } } }

    it_behaves_like "loader"

    context "when file path missing" do
      let(:file_path) { nil }

      it { is_expected.to be_nil }
    end
  end
end
