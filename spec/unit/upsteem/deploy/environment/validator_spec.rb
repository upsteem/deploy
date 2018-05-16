require "spec_helper"
Upsteem::Deploy::SpecHelperLoader.require_shared_contexts_and_examples_for("unit/validator_interface")
Upsteem::Deploy::SpecHelperLoader.require_spec_extension("ordered_validations")

describe Upsteem::Deploy::Environment::Validator do
  extend Upsteem::Deploy::SpecExtensions::OrderedValidations

  def self.validation_passing_order
    %w[
      name supported target_branch logger
      system bundler capistrano git notifier
    ]
  end

  let(:environment) { instance_double("Upsteem::Deploy::Environment") }

  let(:name) { nil }
  let(:supported) { false }
  let(:target_branch) { nil }

  let(:logger) { nil }
  let(:system) { nil }
  let(:bundler) { nil }
  let(:capistrano) { nil }
  let(:git) { nil }
  let(:notifier) { nil }

  shared_context "valid name" do
    let(:name) { "someenv" }
  end

  shared_context "valid supported" do
    let(:supported) { true }
  end

  shared_context "valid target_branch" do
    let(:target_branch) { "somebranch" }
  end

  shared_context "valid logger" do
    let(:logger) { instance_double("Logger") }
  end

  shared_context "valid system" do
    let(:system) { instance_double("Upsteem::Deploy::Proxies::System") }
  end

  shared_context "valid bundler" do
    let(:bundler) { instance_double("Upsteem::Deploy::Proxies::Bundler") }
  end

  shared_context "valid capistrano" do
    let(:capistrano) { instance_double("Upsteem::Deploy::Proxies::Capistrano") }
  end

  shared_context "valid git" do
    let(:git) { instance_double("Upsteem::Deploy::Proxies::Git") }
  end

  shared_context "valid notifier" do
    let(:notifier) { instance_double("Upsteem::Deploy::Proxies::Notifier") }
  end

  let(:services) do
    {
      logger: logger,
      system: system,
      bundler: bundler,
      capistrano: capistrano,
      git: git,
      notifier: notifier
    }
  end

  let(:environment_attrs) do
    {
      name: name,
      target_branch: target_branch,
      supported: supported
    }.merge(services)
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

    context "when attributes validated after target branch invalid" do
      validation_succeeds_until("target_branch")
      it_behaves_like "invalid environment raiser", "Logger is required"
    end

    context "when attributes validated after logger invalid" do
      validation_succeeds_until("logger")
      it_behaves_like "invalid environment raiser", "System is required"
    end

    context "when attributes validated after system invalid" do
      validation_succeeds_until("system")
      it_behaves_like "invalid environment raiser", "Bundler is required"
    end

    context "when attributes validated after bundler invalid" do
      validation_succeeds_until("bundler")
      it_behaves_like "invalid environment raiser", "Capistrano is required"
    end

    context "when attributes validated after capistrano invalid" do
      validation_succeeds_until("capistrano")
      it_behaves_like "invalid environment raiser", "Git is required"
    end

    context "when attributes validated after git invalid" do
      validation_succeeds_until("git")
      it_behaves_like "invalid environment raiser", "Notifier is required"
    end
  end
end
