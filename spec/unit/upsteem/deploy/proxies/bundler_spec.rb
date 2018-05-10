require "spec_helper"
Upsteem::Deploy::SpecHelperLoader.require_shared_contexts_for("unit/proxies/system")

describe Upsteem::Deploy::Proxies::Bundler do
  include_context "setup for system proxy"

  let(:bundler) { described_class.new(system) }

  describe "#execute_command" do
    let(:command) { "some command" }
    let(:result) { true }

    subject { bundler.execute_command(command) }

    before do
      expect_system_call_and_return("bundle exec #{command}", result)
    end

    it { is_expected.to eq(result) }
  end

  describe "#install_gems" do
    let(:error) { nil }
    let(:result) { true }

    subject { bundler.install_gems }

    before do
      if error
        expect_system_call_and_raise("bundle", error)
      else
        expect_system_call_and_return("bundle", result)
      end
    end

    it { is_expected.to eq(result) }

    context "when error occurs during system call" do
      let(:error) { [Upsteem::Deploy::Errors::DeployError, "Exit status 2"] }
      let(:predefined_exception) do
        [Upsteem::Deploy::Errors::DeployError, "Bundle install failed: Exit status 2"]
      end

      it_behaves_like "exception raiser"
    end
  end

  describe "#update_gems" do
    let(:gem_names) { %w[foo bar baz] }
    let(:errors) { [nil, nil, nil] }
    let(:results) { [true, true, true] }

    subject { bundler.update_gems(gem_names) }

    before do
      times = 1
      gem_names.each_with_index do |name, i|
        error = errors[i]
        if error
          expect_system_call_and_raise("bundle update --source #{name}", error, times)
          # All other commands after the failing one should not run.
          times = 0
        else
          result = results[i]
          expect_system_call_and_return("bundle update --source #{name}", result, times)
        end
      end
    end

    it { is_expected.to eq(results.last) }

    shared_examples_for "error re-raiser" do |index|
      context "when update of gem ##{index} raises an exception" do
        let(:predefined_exception) do
          [Upsteem::Deploy::Errors::DeployError, "Bundle update failed: System exit status 3"]
        end

        let(:errors) do
          Array.new(gem_names.size).tap do |a|
            a[index] = [Upsteem::Deploy::Errors::DeployError, "System exit status 3"]
          end
        end

        it_behaves_like "exception raiser"
      end
    end

    it_behaves_like "error re-raiser", 0
    it_behaves_like "error re-raiser", 1
    it_behaves_like "error re-raiser", 2
  end
end
