require "spec_helper"
Upsteem::Deploy::SpecHelperLoader.require_shared_contexts_and_examples_for("unit/validator_interface")
Upsteem::Deploy::SpecHelperLoader.require_spec_extension("ordered_validations")

describe Upsteem::Deploy::Environment::Validator do
  extend Upsteem::Deploy::SpecExtensions::OrderedValidations

  def self.validation_passing_order
    %w[name supported target_branch]
  end

  let(:environment) { instance_double("Upsteem::Deploy::Environment") }

  let(:name) { nil }
  let(:supported) { false }
  let(:target_branch) { nil }

  shared_context "valid name" do
    let(:name) { "someenv" }
  end

  shared_context "valid supported" do
    let(:supported) { true }
  end

  shared_context "valid target_branch" do
    let(:target_branch) { "somebranch" }
  end

  let(:environment_attrs) do
    {
      name: name,
      target_branch: target_branch,
      supported: supported
    }
  end

  let(:validator) { described_class.new(environment) }

  describe ".validate" do
    include_context "setup for validator interface"
    include_context "examples for validator interface"

    let(:validatable) { environment }

    it_behaves_like "validator interface"
  end

  describe "#validate" do
    subject { validator.validate }

    shared_examples_for "invalid environment raiser" do |msg|
      let(:predefined_exception) do
        [Upsteem::Deploy::Errors::InvalidEnvironment, msg || predefined_exception_message]
      end

      it_behaves_like "exception raiser"
    end

    before do
      environment_attrs.each do |name, value|
        allow(environment).to receive(name).and_return(value)
      end
    end

    context "when it succeeds" do
      validation_succeeds
      it { is_expected.to eq(true) }
    end

    context "when all attributes invalid" do
      it_behaves_like "invalid environment raiser", "Environment name is required"
    end

    context "when attributes validated after name invalid" do
      validation_succeeds_until("name")
      let(:predefined_exception_message) { "Environment not supported: #{name.inspect}" }

      it_behaves_like "invalid environment raiser"
    end

    context "when attributes validated after supported? invalid" do
      validation_succeeds_until("supported")
      it_behaves_like "invalid environment raiser", "Target branch is required"
    end
  end
end
