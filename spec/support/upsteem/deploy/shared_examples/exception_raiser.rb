# Examples of usage:
# let(:predefined_exception) { [RuntimeError, "Something bad happened"] }
# it_behaves_like "exception raiser"
# or:
# it_behaves_like "exception raiser", NoMethodError
# it_behaves_like "exception raiser", RuntimeError, "Something went wrong"
shared_examples_for "exception raiser" do |*args|
  let(:predefined_exception) { args } if args.present?

  it "raises an exception" do
    expect { subject }.to raise_error(*predefined_exception)
  end
end
