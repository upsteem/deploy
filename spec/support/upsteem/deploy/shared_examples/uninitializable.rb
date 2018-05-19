shared_examples_for "uninitializable" do |*args|
  describe "#new" do
    subject { described_class.new(*args) }

    it_behaves_like "exception raiser", NoMethodError
  end
end
