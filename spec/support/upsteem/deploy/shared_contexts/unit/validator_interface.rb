shared_context "setup for validator interface" do
  let(:validatable) do
    raise(
      NotImplementedError,
      "let(:validatable) { ... } must be defined in order to use features from shared context 'setup for validator interface'"
    )
  end
  let(:validator_initialization_args) { [] }

  let(:validator) { instance_double(described_class.to_s) }

  def expect_validator_initialization
    args = [validatable].concat(validator_initialization_args)
    expect_to_receive_exactly_ordered_and_return(
      1, described_class, :new, validator, *args
    )
  end

  def expect_validation
    expect_to_receive_exactly_ordered(1, validator, :validate)
  end
end
