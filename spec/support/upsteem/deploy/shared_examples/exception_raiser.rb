# Examples of usage:
# let(:predefined_exception) { [RuntimeError, "Something bad happened"] }
# it_behaves_like "exception raiser"
# or:
# it_behaves_like "exception raiser", NoMethodError
# it_behaves_like "exception raiser", RuntimeError, "Something went wrong"
shared_examples_for "exception raiser" do |*args|
  if args.present?
    let(:predefined_exception) { args }
  end

  it "raises an exception" do
    expect { subject }.to raise_error(*predefined_exception)
  end
end
