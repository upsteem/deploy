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
        bundle_install_occurrences, bundler_service, :install_gems
      )
    end

    def expect_bundle_update
      expect_to_receive_exactly_ordered(
        bundle_update_occurrences, bundler_service, :update_gems, gems_to_update
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

    context "when gemfile overwrite is not needed" do
      let(:gemfile_overwrite_needed) { false }
      let(:gemfile_overwrite_occurrences) { 0 }

      it_behaves_like "normal run"
    end

    context "when there are no gems to update" do
      let(:gems_to_update) { [] }
      let(:bundle_update_occurrences) { 0 }
      let(:bundle_update_success_occurrences) { 0 }

      it_behaves_like "normal run"
    end
  end
end
