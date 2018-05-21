require "spec_helper"

describe Upsteem::Deploy::Services::TestSuiteRunners::Base do
  let(:runner) { described_class.new }

  describe "#run_test_suite" do
    subject { runner.run_test_suite }

    let(:predefined_exception) do
      [NotImplementedError, "Test runners must implement run_test_suite() instance method"]
    end

    it_behaves_like "exception raiser"
  end
end
