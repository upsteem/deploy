describe Upsteem::Deploy::Factories::ConfigurationFactory do
  describe ".create" do
    subject { described_class.create(unchecked_project_path, unchecked_config_file_path) }

    shared_context "setup until project path normalization" do
      before do
        allow(utils_module).to receive(:normalize_string).with(unchecked_project_path).and_return(project_path)
      end
    end

    let(:unchecked_project_path) { instance_double("String", "unchecked project path") }

    shared_context "setup until project path validation" do
      include_context "setup until project path normalization"

      before do
        allow(File).to receive(:directory?).with(project_path).and_return(project_path_is_directory)
      end
    end

    shared_context "setup until config file path normalization" do
      include_context "setup until project path validation"

      let(:project_path_is_directory) { true }

      before do
        allow(utils_module).to receive(:normalize_string).with(unchecked_config_file_path).and_return(config_file_path)
      end
    end

    let(:unchecked_config_file_path) { instance_double("String", "unchecked config file path") }

    shared_context "setup until config file loading" do
      include_context "setup until config file path normalization"

      before do
        allow(utils_module).to receive(:load_yaml).with(project_path, config_file_path).and_return(options)
      end
    end

    let(:utils_module) { class_double("Upsteem::Deploy::Utils").as_stubbed_const }

    let(:project_path_is_directory) { false }

    let(:config_file_path) { instance_double("String", "config file path") }

    shared_examples_for "instance returner" do
      before do
        allow(configuration_class).to receive(:new).with(project_path, options).and_return(configuration)
      end

      it { is_expected.to eq(configuration) }
    end

    shared_examples_for "ArgumentError raiser" do
      it "raises an ArgumentError" do
        expect { subject }.to raise_error(ArgumentError, error_message)
      end
    end

    let(:error_message) { "Project path must be a directory!" }

    let(:project_path) { instance_double("String", "project path") }
    let(:options) { instance_double("Hash", "options") }

    let(:configuration_class) { class_double("Upsteem::Deploy::Configuration").as_stubbed_const }
    let(:configuration) { instance_double("Upsteem::Deploy::Configuration") }

    shared_examples_for "successful setup with config file" do
      include_context "setup until config file loading"

      it_behaves_like "instance returner"
    end

    it_behaves_like "successful setup with config file"

    context "when config file path normalization returns nil" do
      include_context "setup until config file path normalization"

      let(:config_file_path) { nil }
      let(:options) { {} }

      it_behaves_like "instance returner"
    end

    context "when project path is not a directory" do
      include_context "setup until project path validation"

      it_behaves_like "ArgumentError raiser"
    end

    context "when project path normalization returns nil" do
      include_context "setup until project path normalization"

      let(:project_path) { nil }
      let(:error_message) { "Project path must be supplied!" }

      it_behaves_like "ArgumentError raiser"
    end
  end
end
