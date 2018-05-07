require "spec_helper"
Upsteem::Deploy::SpecHelperLoader.require_shared_contexts_and_examples_for("unit/tasks")

describe Upsteem::Deploy::Tasks::Task do
  include_context "setup for tasks"
  include_context "examples for tasks"

  describe "#run" do
    it_behaves_like(
      "error run", NotImplementedError,
      "Subclasses of Task must implement 'run' instance method"
    )
  end
end
