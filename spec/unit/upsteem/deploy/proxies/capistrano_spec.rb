require "spec_helper"
Upsteem::Deploy::SpecHelperLoader.require_shared_contexts_for("unit/proxies/bundler")

describe Upsteem::Deploy::Proxies::Capistrano do
  include_context "setup for bundler proxy"

  let(:environment_name) { "myenv" }
  let(:environment) { instance_double("Upsteem::Deploy::Environment") }

  let(:capistrano) { described_class.new(bundler) }

  before do
    allow(environment).to receive(:name).and_return(environment_name)
  end

  describe "#deploy" do
    let(:error) { nil }
    let(:result) { true }

    subject { capistrano.deploy(environment) }

    before do
      if error
        expect_bundle_exec_and_raise("cap #{environment_name} deploy", error)
      else
        expect_bundle_exec_and_return("cap #{environment_name} deploy", result)
      end
    end

    it { is_expected.to eq(result) }

    context "when error occurs during bundler command execution" do
      let(:error) { [Upsteem::Deploy::Errors::DeployError, "Exit status 2"] }
      let(:predefined_exception) do
        [Upsteem::Deploy::Errors::DeployError, "Capistrano deploy failed: Exit status 2"]
      end

      it_behaves_like "exception raiser"
    end
  end
end
