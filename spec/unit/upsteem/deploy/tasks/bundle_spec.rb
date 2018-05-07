require "spec_helper"
Upsteem::Deploy::SpecHelperLoader.require_shared_contexts_and_examples_for("unit/tasks")

describe Upsteem::Deploy::Tasks::Bundle do
  include_context "setup for tasks"
  include_context "examples for tasks"
  include_context "gems to update"
  include_context "logging"
  include_context "bundler operations"

  describe "#run" do
    let(:gemfile_overwrite_occurrences) { 1 }
    let(:bundle_install_occurrences) { 1 }
    let(:bundle_install_success_occurrences) { 1 }
    let(:bundle_update_occurrences) { 1 }
    let(:bundle_update_success_occurrences) { 1 }

    def expect_gemfile_overwrite
      expect_to_receive_exactly_ordered(
        gemfile_overwrite_occurrences, FileUtils, :cp, "Gemfile.#{environment_name}", "Gemfile"
      )
    end

    def expect_bundle_install
      expect_to_receive_exactly_ordered(
        bundle_install_occurrences, bundler_proxy, :install_gems
      )
    end

    def expect_bundle_update
      expect_to_receive_exactly_ordered(
        bundle_update_occurrences, bundler_proxy, :update_gems, gems_to_update
      )
    end

    before do
      expect_logger_info("Running bundle")
      expect_gemfile_overwrite
      expect_bundle_install
      expect_logger_info("Bundle install OK", bundle_install_success_occurrences)
      expect_bundle_update
      expect_logger_info("Bundle update OK", bundle_update_success_occurrences)
    end

    it_behaves_like "normal run"

    shared_examples_for "no gems to update" do |absence|
      let(:gems_to_update) { absence }
      let(:gemfile_overwrite_occurrences) { 0 }
      let(:bundle_update_occurrences) { 0 }
      let(:bundle_update_success_occurrences) { 0 }

      it_behaves_like "normal run"
    end

    it_behaves_like "no gems to update", nil
    it_behaves_like "no gems to update", []
  end
end
