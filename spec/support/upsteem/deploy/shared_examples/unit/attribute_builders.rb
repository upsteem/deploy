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
    include_context "setup for ordered attributes builder"
    it { is_expected.to eq(builder) }
  end

  shared_examples_for "ordered attributes build failure" do |*exception|
    include_context "setup for ordered attributes builder"
    it_behaves_like "exception raiser", *exception
  end

  shared_examples_for "attribute builder" do
    let(:attributes) do
      { attribute_name => attribute_value }
    end

    it_behaves_like "attributes builder"
  end
end
