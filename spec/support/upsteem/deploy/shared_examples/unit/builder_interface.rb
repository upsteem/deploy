shared_context "examples for builder interface" do
  shared_examples_for "builder interface" do
    context "when block not given" do
      subject { described_class.build(*builder_initialization_args) }

      before do
        expect_builder_initialization
        expect_builder_result
      end

      it { is_expected.to eq(build_result) }
    end

    context "when block given" do
      subject do
        described_class.build(*builder_initialization_args) do |_|
          execute_custom_builder_events
        end
      end

      before do
        expect_builder_initialization
        expect_custom_builder_events
        expect_builder_result
      end

      it { is_expected.to eq(build_result) }
    end
  end
end
