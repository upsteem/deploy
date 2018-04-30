shared_context "unit test setup for tasks" do
  let(:project_path) { "/path/to/something" }
  let(:environment_name) { "someenv" }
  let(:feature_branch) { "DEV-123" }
  let(:target_branch) { "envtarget" }

  let(:logger) { instance_double("Logger") }
  let(:configuration) { instance_double("Upsteem::Deploy::Configuration") }
  let(:environment) { instance_double("Upsteem::Deploy::Environment") }

  let(:task) { described_class.new(environment) }

  shared_context "no feature branch" do
    let(:feature_branch) { nil }
  end

  shared_context "customizable task" do
    let(:task_options) { {} }
    let(:task) { described_class.new(environment, task_options) }
  end

  def allow_project_path_from_configuration
    allow(configuration).to receive(:project_path).and_return(project_path)
  end

  def allow_logger_from_configuration
    allow(configuration).to receive(:logger).and_return(logger)
  end

  def allow_configuration_from_environment
    allow(environment).to receive(:configuration).and_return(configuration)
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

  def allow_methods_from_configuration
    allow_project_path_from_configuration
    allow_logger_from_configuration
  end

  def allow_methods_from_environment
    allow_configuration_from_environment
    allow_name_from_environment
    allow_target_branch_from_environment
    allow_feature_branch_from_environment
  end

  before do
    allow_methods_from_configuration
    allow_methods_from_environment
  end
end
