Upsteem::Deploy::SpecHelperLoader.require_shared_contexts_for("unit/logger")

shared_context "setup for tasks" do
  let(:environment_name) { "someenv" }
  let(:feature_branch) { "DEV-123" }
  let(:target_branch) { "envtarget" }

  let(:environment) { instance_double("Upsteem::Deploy::Environment") }

  let(:task) { described_class.new(environment) }

  shared_context "no feature branch" do
    let(:feature_branch) { nil }
  end

  shared_context "task with options" do
    let(:task_options) { {} }
    let(:task) { described_class.new(environment, task_options) }
  end

  def allow_name_from_environment
    allow(environment).to receive(:name).and_return(environment_name)
  end

  def allow_target_branch_from_environment
    allow(environment).to receive(:target_branch).and_return(target_branch)
  end

  def allow_feature_branch_from_environment
    allow(environment).to receive(:feature_branch).and_return(feature_branch)
  end

  def sub_task_helper(label, name = nil)
    name ? send("#{label}_#{name}".to_sym) : send(label)
  end

  def configure_expectation_for_sub_task(label)
    sub_task = sub_task_helper(label)

    if sub_task[:error]
      expect_to_receive_exactly_ordered_and_raise(
        sub_task[:occurrences], sub_task[:task], :run, sub_task[:error]
      )
    else
      expect_to_receive_exactly_ordered_and_return(
        sub_task[:occurrences], sub_task[:task], :run, true
      )
    end
  end

  shared_context "sub-task" do |klass, label|
    let("#{label}_task".to_sym) { instance_double(klass.to_s) }
    let("#{label}_options".to_sym) { {} }
    let("#{label}_occurrences".to_sym) { 1 }
    let("#{label}_error") { nil }

    let(label) do
      {
        task: sub_task_helper(label, :task),
        options: sub_task_helper(label, :options),
        occurrences: sub_task_helper(label, :occurrences),
        error: sub_task_helper(label, :error)
      }
    end

    before do
      sub_task = sub_task_helper(label)
      allow(klass).to receive(:new).with(environment, sub_task[:options]).and_return(sub_task[:task])
    end
  end

  shared_context "logging" do
    include_context "setup for logger"

    def allow_logger_from_environment
      allow(environment).to receive(:logger).and_return(logger)
    end

    before do
      allow_logger_from_environment
    end
  end

  shared_context "project path" do
    let(:project_path) { "/path/to/something" }

    def allow_project_path_from_environment
      allow(environment).to receive(:project_path).and_return(project_path)
    end

    before do
      allow_project_path_from_environment
    end
  end

  shared_context "gems to update" do
    let(:env_gems_to_update) { %w[foo bar baz] }

    def allow_env_gems_to_update_from_environment
      allow(environment).to receive(
        :env_gems_to_update
      ).and_return(env_gems_to_update)
    end

    before do
      allow_env_gems_to_update_from_environment
    end
  end

  shared_context "bundler operations" do
    let(:bundler_proxy) { instance_double("Upsteem::Deploy::Proxies::Bundler") }

    def allow_bundler_proxy_from_environment
      allow(environment).to receive(:bundler).and_return(bundler_proxy)
    end

    before do
      allow_bundler_proxy_from_environment
    end
  end

  shared_context "capistrano operations" do
    let(:capistrano_proxy) { instance_double("Upsteem::Deploy::Proxies::Capistrano") }

    def allow_capistrano_proxy_from_environment
      allow(environment).to receive(:capistrano).and_return(capistrano_proxy)
    end

    before do
      allow_capistrano_proxy_from_environment
    end
  end

  shared_context "git operations" do
    let(:git_proxy) { instance_double("Upsteem::Deploy::Proxies::VerboseGit") }

    def allow_git_proxy_from_environment
      allow(environment).to receive(:git).and_return(git_proxy)
    end

    before do
      allow_git_proxy_from_environment
    end
  end

  before do
    allow_name_from_environment
    allow_target_branch_from_environment
    allow_feature_branch_from_environment
  end
end
