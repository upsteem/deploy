shared_context "examples for validator interface" do
  shared_examples_for "validator interface" do
    subject { described_class.validate(validatable, *validator_initialization_args) }

    before do
      expect_validator_initialization
      expect_validation
    end

    it { is_expected.to eq(true) }
  end
end
