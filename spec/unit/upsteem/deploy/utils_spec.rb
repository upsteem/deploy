describe Upsteem::Deploy::Utils do
  describe ".generate_numeric_code" do
    subject { described_class.generate_numeric_code(number_of_digits) }

    let!(:number_of_digits) { 5 }

    before do
      allow(described_class).to receive(:rand).with(scope_for_random).and_return(random_code)
    end

    let(:scope_for_random) { 100_000 }
    let(:random_code) { 35_718 }

    shared_examples_for "generator" do
      it { is_expected.to eq(expected_result) }
    end

    let(:expected_result) { "35718" }

    it_behaves_like "generator"

    context "when generated random code has less digits than expected" do
      let(:random_code) { 674 }
      let(:expected_result) { "00674" }

      it_behaves_like "generator"
    end
  end

  describe ".load_yaml" do
    subject { described_class.load_yaml(project_path, relative_file_path) }

    before do
      allow(File).to receive(:join).with(project_path, relative_file_path).and_return(absolute_file_path)
      allow(YAML).to receive(:load_file).with(absolute_file_path).and_return(loaded_yaml)
    end

    let(:project_path) { instance_double("String", "project path") }
    let(:relative_file_path) { instance_double("String", "relative file path") }
    let(:absolute_file_path) { instance_double("String", "absolute file path") }

    let(:loaded_yaml) do
      {
        "foo" => "bar",
        "baz" => {
          "a" => 1,
          "b" => 2,
          "c" => { "some" => "thing" }
        }
      }
    end

    let(:expected_result) do
      {
        foo: "bar",
        baz: {
          a: 1,
          b: 2,
          c: { some: "thing" }
        }
      }
    end

    shared_examples_for "loader" do
      it { is_expected.to eq(expected_result) }
    end

    it_behaves_like "loader"

    context "when loading returns false" do
      let(:loaded_yaml) { false }
      let(:expected_result) { {} }

      it_behaves_like "loader"
    end
  end

  describe ".normalize_string" do
    subject { described_class.normalize_string(input) }

    shared_examples_for "normalizer" do |given_input, expected_output|
      let!(:input) { given_input }

      it { is_expected.to eq(expected_output) }
    end

    it_behaves_like "normalizer", "foo", "foo"
    it_behaves_like "normalizer", "  bar   ", "bar"
    it_behaves_like "normalizer", :baz, "baz"
    it_behaves_like "normalizer", 6, "6"
    it_behaves_like "normalizer", true, "true"
    it_behaves_like "normalizer", false, "false"
    it_behaves_like "normalizer", "  ", nil
    it_behaves_like "normalizer", nil, nil
  end
end
