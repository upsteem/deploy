require "spec_helper"

describe Upsteem::Deploy::Environment do
  let(:name) { "production" }
  let(:feature_branch) { "DEV-123" }
  let(:supported) { true }
  let(:target_branch) { "master" }
  let(:project_path) { "/path/to/project" }
  let(:gemfile_overwrite_needed) { true }
  let(:gems_to_update) { %w[foo bar baz] }

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
end
