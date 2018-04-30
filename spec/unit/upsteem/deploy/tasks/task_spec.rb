require "spec_helper"
Upsteem::Deploy::SpecHelperLoader.require_shared_contexts_for("unit_test_setup_for_tasks")
Upsteem::Deploy::SpecHelperLoader.require_shared_examples_for("tasks")

describe Upsteem::Deploy::Tasks::Task do
  include_context "unit test setup for tasks"

  describe "#run" do
    subject { task.run }

    it_behaves_like(
      "exception raiser", NotImplementedError,
      "Subclasses of Task must implement 'run' instance method"
    )
  end
end
