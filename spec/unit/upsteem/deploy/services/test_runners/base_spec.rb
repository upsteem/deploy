require "spec_helper"

describe Upsteem::Deploy::Services::TestRunners::Base do
  let(:runner) { described_class.new }

  describe "#run_tests" do
    subject { runner.run_tests }

    let(:predefined_exception) do
      [NotImplementedError, "Test runners must implement run_tests() instance method"]
    end

    it_behaves_like "exception raiser"
  end
end
