# Examples of usage:
# it_behaves_like "exception raiser", NoMethodError
# it_behaves_like "exception raiser", RuntimeError, "Something went wrong"
shared_examples_for "exception raiser" do |*args|
  it "raises an exception" do
    expect { subject }.to raise_error(*args)
  end
end

# Assuming that
# let(:predefined_exception) { ... }
# has been declared, the example of usage is:
# it_behaves_like "predefined exception raiser"
shared_examples_for "predefined exception raiser" do
  it "raises an exception" do
    expect { subject }.to raise_error(*predefined_exception)
  end
end
