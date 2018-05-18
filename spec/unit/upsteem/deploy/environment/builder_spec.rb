require "spec_helper"
Upsteem::Deploy::SpecHelperLoader.require_shared_contexts_and_examples_for("unit/builder_interface")
Upsteem::Deploy::SpecHelperLoader.require_shared_examples_for("unit/attribute_builders")

describe Upsteem::Deploy::Environment::Builder do
  include_context "examples for attribute builders"

  let(:environment_class) { Upsteem::Deploy::Environment }
  let(:validator_class) { Upsteem::Deploy::Environment::Validator }

  let(:configuration) { instance_double("Upsteem::Deploy::Configuration") }
  let(:name) { "someenv" }
  let(:name_arg) { name }
  let(:feature_branch) { "somebranch" }
  let(:feature_branch_arg) { feature_branch }

  let(:supported) { true }
  let(:target_branch) { "anotherbranch" }
  let(:project_path) { "/path/to/project" }
  let(:gemfile_overwrite_needed) { true }

  let(:shared_gems_to_update) { %w[foo] }
  let(:env_gems_to_update) { %w[bar baz] }
  let(:gems_to_update) { %w[foo bar baz] }

  let(:environment) { instance_double("Upsteem::Deploy::Environment") }
  let(:builder) { described_class.new }
  let(:buildable) { environment }

  before do
    allow(environment_class).to receive(:new).and_return(environment)
  end

  describe ".build" do
    include_context "setup for builder interface"
    include_context "examples for builder interface"

    def expect_custom_builder_events
      expect_to_receive_exactly_ordered_and_return(
        1, builder, :configure, builder, name, feature_branch, configuration
      )
    end

    def execute_custom_builder_events
      builder.configure(name, feature_branch, configuration)
    end

    it_behaves_like "builder interface"
  end

  describe "#build" do
    subject { builder.build }

    before do
      expect(validator_class).to receive(:validate).with(environment)
    end

    it { is_expected.to eq(environment) }
  end

  describe "#configure" do
    subject { builder.configure(name_arg, feature_branch_arg, configuration) }

    let(:attributes) do
      [
        [:name, name],
        [:feature_branch, feature_branch],
        [:supported, supported],
        [:target_branch, target_branch],
        [:project_path, project_path],
        [:gemfile_overwrite_needed, gemfile_overwrite_needed],
        [:gems_to_update, gems_to_update]
      ]
    end

    shared_context "attributes for missing name" do
      let(:attributes) do
        [
          [:name, name],
          [:feature_branch, feature_branch],
          [:project_path, project_path],
          [:gemfile_overwrite_needed, gemfile_overwrite_needed],
          [:gems_to_update, gems_to_update]
        ]
      end
    end

    shared_examples_for "nullifier of blank string argument" do |key, blank|
      let(key) { nil }
      let("#{key}_arg") { blank }

      it_behaves_like "ordered attributes builder"
    end

    shared_examples_for "nullifier of blank name" do |blank|
      include_context "attributes for missing name"
      it_behaves_like "nullifier of blank string argument", :name, blank
    end

    before do
      allow(environment).to receive(:name).and_return(name)
      allow(configuration).to receive(:environment_supported?).with(name).and_return(supported)
      allow(configuration).to receive(:find_target_branch).with(name).and_return(target_branch)
      allow(configuration).to receive(:project_path).and_return(project_path)
      allow(configuration).to receive(:env_gems_to_update).and_return(env_gems_to_update)
      allow(configuration).to receive(:shared_gems_to_update).and_return(shared_gems_to_update)
    end

    it_behaves_like "ordered attributes builder"

    context "when name needs formatting" do
      let(:name) { "someenv" }
      let(:name_arg) { " someenv  " }

      it_behaves_like "ordered attributes builder"
    end

    context "when feature branch needs formatting" do
      let(:feature_branch) { "somebranch" }
      let(:feature_branch_arg) { " somebranch  " }

      it_behaves_like "ordered attributes builder"
    end

    it_behaves_like "nullifier of blank name", nil
    it_behaves_like "nullifier of blank name", ""
    it_behaves_like "nullifier of blank name", "  "

    it_behaves_like "nullifier of blank string argument", :feature_branch, nil
    it_behaves_like "nullifier of blank string argument", :feature_branch, ""
    it_behaves_like "nullifier of blank string argument", :feature_branch, "  "
  end
end
