shared_context "setup for attribute builders" do
  shared_context "setup for ordered attributes builder" do
    def expect_buildable_attribute_in_order_and_return(attribute_name, attribute_value)
      expect_to_receive_exactly_ordered_and_return(
        1, buildable, "#{attribute_name}=".to_sym, attribute_value, attribute_value
      )
    end

    def expect_buildable_attributes_in_order
      attributes.each do |attribute_name, attribute_value|
        expect_buildable_attribute_in_order_and_return(attribute_name, attribute_value)
      end
    end

    before do
      expect_buildable_attributes_in_order
    end
  end
end
