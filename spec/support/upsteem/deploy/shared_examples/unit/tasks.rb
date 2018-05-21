shared_context "examples for tasks" do
  let(:run_result) { true }

  shared_examples_for "feature branch dependent" do
    describe ".new" do
      subject { described_class.new(services_container) }

      it { is_expected.to be_instance_of(described_class) }

      context "when feature branch missing" do
        let(:feature_branch) { nil }
        it_behaves_like "exception raiser", ArgumentError, "Feature branch not supplied with environment"
      end
    end
  end

  shared_examples_for "normal run" do
    subject { task.run }
    it { is_expected.to eq(run_result) }
  end

  shared_examples_for "error run" do |*exception|
    subject { task.run }
    it_behaves_like "exception raiser", *exception
  end
end
