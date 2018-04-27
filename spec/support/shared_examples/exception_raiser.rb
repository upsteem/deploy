shared_examples_for "exception raiser" do |*args|
  it "raises an exception" do
    expect { subject }.to raise_error(*args)
  end
end
