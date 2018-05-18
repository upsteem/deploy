Upsteem::Deploy::SpecHelperLoader.require_shared_contexts_for("unit/logger")

shared_context "setup for tasks" do
  let(:environment_name) { "someenv" }
  let(:feature_branch) { "DEV-123" }
  let(:target_branch) { "envtarget" }

  let(:environment) { instance_double("Upsteem::Deploy::Environment") }
  let(:logger) { instance_double("Logger") }
  let(:git_service) { instance_double("Upsteem::Deploy::Services::VerboseGit") }

  let(:services_container) { instance_double("Upsteem::Deploy::ServicesContainer") }

  let(:task) { described_class.new(services_container) }

  shared_context "no feature branch" do
    let(:feature_branch) { nil }
  end

  shared_context "task with options" do
    let(:task_options) { {} }
    let(:task) { described_class.new(services_container, task_options) }
  end

  def allow_environment_from_services_container
    allow(services_container).to receive(:environment).and_return(environment)
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

  def allow_logger_from_services_container
    allow(services_container).to receive(:logger).and_return(logger)
  end

  def allow_git_service_from_services_container
    allow(services_container).to receive(:git).and_return(git_service)
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
      allow(klass).to receive(:new).with(services_container, sub_task[:options]).and_return(sub_task[:task])
    end
  end

  shared_context "logging" do
    include_context "setup for logger"
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
    let(:gems_to_update) { %w[foo bar baz] }
    let(:gemfile_overwrite_needed) { true }

    def allow_gemfile_overwrite_necessity_checking_from_environment
      allow(environment).to receive(
        :gemfile_overwrite_needed
      ).and_return(gemfile_overwrite_needed)
    end

    def allow_gems_to_update_from_environment
      allow(environment).to receive(
        :gems_to_update
      ).and_return(gems_to_update)
    end

    before do
      allow_gems_to_update_from_environment
      allow_gemfile_overwrite_necessity_checking_from_environment
    end
  end

  shared_context "bundler operations" do
    let(:bundler_service) { instance_double("Upsteem::Deploy::Services::Bundler") }

    def allow_bundler_service_from_services_container
      allow(services_container).to receive(:bundler).and_return(bundler_service)
    end

    before do
      allow_bundler_service_from_services_container
    end
  end

  shared_context "capistrano operations" do
    let(:capistrano_service) { instance_double("Upsteem::Deploy::Services::Capistrano") }

    def allow_capistrano_service_from_services_container
      allow(services_container).to receive(:capistrano).and_return(capistrano_service)
    end

    before do
      allow_capistrano_service_from_services_container
    end
  end

  shared_context "notifier operations" do
    let(:notifier_service) { instance_double("Upsteem::Deploy::Services::Notifier") }

    def allow_notifier_service_from_services_container
      allow(services_container).to receive(:notifier).and_return(notifier_service)
    end

    before do
      allow_notifier_service_from_services_container
    end
  end

  shared_context "git operations" do
  end

  before do
    allow_environment_from_services_container
    allow_name_from_environment
    allow_target_branch_from_environment
    allow_feature_branch_from_environment
    allow_logger_from_services_container
    allow_git_service_from_services_container
  end
end
