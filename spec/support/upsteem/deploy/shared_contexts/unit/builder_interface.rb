shared_context "setup for builder interface" do
  let(:builder_initialization_args) { [] }
  let(:builder) { instance_double(described_class.to_s) }
  let(:build_result) { double("a result of build") }

  def expect_builder_initialization
    expect_to_receive_exactly_ordered_and_return(
      1, described_class, :new, builder, *builder_initialization_args
    )
  end

  # Override if necessary:
  def expect_custom_builder_events; end

  def expect_builder_result
    expect_to_receive_exactly_ordered_and_return(1, builder, :build, build_result)
  end

  def execute_custom_builder_events
    raise NotImplementedError, "execute_builder_custom_events must be implemented"
  end
end
