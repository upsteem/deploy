shared_context "examples for tasks" do
  let(:run_result) { true }

  shared_examples_for "normal run" do
    subject { task.run }
    it { is_expected.to eq(run_result) }
  end

  shared_examples_for "error run" do |*exception|
    subject { task.run }
    it_behaves_like "exception raiser", *exception
  end
end
