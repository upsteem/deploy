require "spec_helper"

describe Upsteem::Deploy::Environment do
  let(:name) { "production" }
  let(:feature_branch) { "DEV-123" }
  let(:supported) { true }
  let(:target_branch) { "master" }
  let(:project_path) { "/path/to/project" }
  let(:gemfile_overwrite_needed) { true }
  let(:gems_to_update) { %w[foo bar baz] }

  let(:logger) { instance_double("Logger") }
  let(:system) { instance_double("Upsteem::Deploy::Proxies::System") }
  let(:bundler) { instance_double("Upsteem::Deploy::Proxies::Bundler") }
  let(:capistrano) { instance_double("Upsteem::Deploy::Proxies::Capistrano") }
  let(:git) { instance_double("Upsteem::Deploy::Proxies::Git") }
  let(:notifier) { instance_double("Upsteem::Deploy::Proxies::Notifier") }

  let(:environment) do
    described_class.new
  end

  describe "#name" do
    subject { environment.name }

    before do
      environment.name = name
    end

    it { is_expected.to eq(name) }
  end

  describe "#feature_branch" do
    subject { environment.feature_branch }

    before do
      environment.feature_branch = feature_branch
    end

    it { is_expected.to eq(feature_branch) }
  end

  describe "#supported" do
    subject { environment.supported }

    before do
      environment.supported = supported
    end

    it { is_expected.to eq(supported) }
  end

  describe "#target_branch" do
    subject { environment.target_branch }

    before do
      environment.target_branch = target_branch
    end

    it { is_expected.to eq(target_branch) }
  end

  describe "#project_path" do
    subject { environment.project_path }

    before do
      environment.project_path = project_path
    end

    it { is_expected.to eq(project_path) }
  end

  describe "#gemfile_overwrite_needed" do
    subject { environment.gemfile_overwrite_needed }

    before do
      environment.gemfile_overwrite_needed = gemfile_overwrite_needed
    end

    it { is_expected.to eq(gemfile_overwrite_needed) }
  end

  describe "#gems_to_update" do
    subject { environment.gems_to_update }

    before do
      environment.gems_to_update = gems_to_update
    end

    it { is_expected.to eq(gems_to_update) }
  end

  describe "#logger" do
    subject { environment.logger }

    before do
      environment.logger = logger
    end

    it { is_expected.to eq(logger) }
  end

  describe "#system" do
    subject { environment.system }

    before do
      environment.system = system
    end

    it { is_expected.to eq(system) }
  end

  describe "#bundler" do
    subject { environment.bundler }

    before do
      environment.bundler = bundler
    end

    it { is_expected.to eq(bundler) }
  end

  describe "#capistrano" do
    subject { environment.capistrano }

    before do
      environment.capistrano = capistrano
    end

    it { is_expected.to eq(capistrano) }
  end

  describe "#git" do
    subject { environment.git }

    before do
      environment.git = git
    end

    it { is_expected.to eq(git) }
  end

  describe "#notifier" do
    subject { environment.notifier }

    before do
      environment.notifier = notifier
    end

    it { is_expected.to eq(notifier) }
  end
end
