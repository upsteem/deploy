require "spec_helper"

describe Upsteem::Deploy::ServicesContainer do
  let(:project_path) { "/path/to/project" }
  let(:test_suite_configuration) do
    instance_double("Upsteem::Deploy::ConfigurationSections::TestSuiteConfiguration")
  end
  let(:notifications_configuration) do
    instance_double("Upsteem::Deploy::ConfigurationSections::NotificationConfiguration")
  end
  let(:configuration) { instance_double("Upsteem::Deploy::Configuration") }
  let(:environment) { instance_double("Upsteem::Deploy::Environment") }

  let(:default_logger) { instance_double("Logger", "default") }
  let(:custom_logger) { instance_double("Logger", "custom") }
  let(:logger) { custom_logger }

  let(:input_service) { instance_double("Upsteem::Deploy::Services::StandardInputService") }
  let(:system) { instance_double("Upsteem::Deploy::Services::System") }
  let(:bundler) { instance_double("Upsteem::Deploy::Services::Bundler") }
  let(:capistrano) { instance_double("Upsteem::Deploy::Services::Capistrano") }
  let(:git) { instance_double("Upsteem::Deploy::Services::VerboseGit") }
  let(:rollbacker) { instance_double("Upsteem::Deploy::Services::Rollbacker") }
  let(:test_suite_runner) { instance_double("Upsteem::Deploy::Services::TestSuiteRunners::Base") }
  let(:notifier) { instance_double("Upsteem::Deploy::Services::Notifier") }

  let(:container) { described_class.new(configuration, environment) }

  def stub_project_path
    allow(configuration).to receive(:project_path).and_return(project_path)
  end

  def stub_test_suite_configuration
    allow(configuration).to receive(:test_suite).and_return(test_suite_configuration)
  end

  def stub_notifications_configuration
    allow(configuration).to receive(:notifications).and_return(notifications_configuration)
  end

  def stub_default_logger
    allow(Logger).to receive(:new).with(STDOUT).once.and_return(default_logger)
  end

  def stub_custom_logger
    allow(configuration).to receive(:logger).once.and_return(custom_logger)
  end

  def stub_input_service
    allow(Upsteem::Deploy::Services::StandardInputService).to receive(:new).once.with(
      no_args
    ).and_return(input_service)
  end

  def stub_system
    allow(Upsteem::Deploy::Services::System).to receive(:new).once.and_return(system)
  end

  def stub_bundler
    allow(Upsteem::Deploy::Services::Bundler).to receive(:new).with(system).once.and_return(bundler)
  end

  def stub_capistrano
    allow(Upsteem::Deploy::Services::Capistrano).to receive(:new).with(bundler).once.and_return(capistrano)
  end

  def stub_git
    allow(Upsteem::Deploy::Services::VerboseGit).to receive(:new).with(
      project_path, logger
    ).once.and_return(git)
  end

  def stub_rollbacker
    allow(Upsteem::Deploy::Services::Rollbacker).to receive(:new).with(
      logger, git, environment
    ).once.and_return(rollbacker)
  end

  def stub_test_suite_runner
    allow(Upsteem::Deploy::Factories::TestSuiteRunnerFactory).to receive(:create).with(
      test_suite_configuration, container
    ).once.and_return(test_suite_runner)
  end

  def stub_notifier
    allow(Upsteem::Deploy::Services::Notifier).to receive(:new).with(
      notifications_configuration, environment, logger, git
    ).once.and_return(notifier)
  end

  before do
    stub_project_path
    stub_test_suite_configuration
    stub_notifications_configuration
    stub_default_logger
    stub_custom_logger
    stub_input_service
    stub_system
    stub_bundler
    stub_capistrano
    stub_git
    stub_rollbacker
    stub_test_suite_runner
    stub_notifier
  end

  describe "#environment" do
    subject { container.environment }

    it { is_expected.to eq(environment) }
  end

  describe "#logger" do
    subject do
      container.logger
      container.logger
    end

    it { is_expected.to eq(custom_logger) }

    context "when configuration has no logger" do
      let(:custom_logger) { nil }
      it { is_expected.to eq(default_logger) }
    end
  end

  describe "#input_service" do
    subject do
      container.input_service
      container.input_service
    end

    it { is_expected.to eq(input_service) }
  end

  describe "#system" do
    subject do
      container.system
      container.system
    end

    it { is_expected.to eq(system) }
  end

  describe "#bundler" do
    subject do
      container.bundler
      container.bundler
    end

    it { is_expected.to eq(bundler) }
  end

  describe "#capistrano" do
    subject do
      container.capistrano
      container.capistrano
    end

    it { is_expected.to eq(capistrano) }
  end

  describe "#git" do
    subject do
      container.git
      container.git
    end

    it { is_expected.to eq(git) }
  end

  describe "#rollbacker" do
    subject do
      container.rollbacker
      container.rollbacker
    end

    it { is_expected.to eq(rollbacker) }
  end

  describe "#test_suite_runner" do
    subject do
      container.test_suite_runner
      container.test_suite_runner
    end

    it { is_expected.to eq(test_suite_runner) }
  end

  describe "#notifier" do
    subject do
      container.notifier
      container.notifier
    end

    it { is_expected.to eq(notifier) }
  end
end
