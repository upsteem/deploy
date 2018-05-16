shared_context "examples for attribute builders" do
  shared_examples_for "attributes builder" do
    before do
      attributes.each do |attribute_name, attribute_value|
        expect(buildable).to receive(
          "#{attribute_name}=".to_sym
        ).with(attribute_value).and_return(attribute_value)
      end
    end

    it { is_expected.to eq(builder) }
  end

  shared_examples_for "ordered attributes builder" do
    before do
      attributes.each do |attribute_name, attribute_value|
        expect_to_receive_exactly_ordered_and_return(
          1, buildable, "#{attribute_name}=".to_sym, attribute_value, attribute_value
        )
      end
    end

    it { is_expected.to eq(builder) }
  end

  shared_examples_for "attribute builder" do
    let(:attributes) do
      { attribute_name => attribute_value }
    end

    it_behaves_like "attributes builder"
  end
end
