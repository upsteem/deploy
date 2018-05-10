require "spec_helper"
Upsteem::Deploy::SpecHelperLoader.require_shared_contexts_and_examples_for("unit/tasks/deployment")

describe Upsteem::Deploy::Tasks::Deployment do
  include_context "setup for deployment tasks"
  include_context "examples for deployment tasks"

  describe "#run" do
    it_behaves_like "run"
  end
end
