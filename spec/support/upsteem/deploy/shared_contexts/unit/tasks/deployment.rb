Upsteem::Deploy::SpecHelperLoader.require_shared_contexts_for("unit/tasks")

shared_context "setup for deployment tasks" do
  include_context "setup for tasks"
  include_context "project path"
  include_context "logging"
  include_context "sub-task", Upsteem::Deploy::Tasks::GitStatusValidation, :git_status_validation
  include_context "sub-task", Upsteem::Deploy::Tasks::FeatureBranchInclusionFlow, :feature_branch_inclusion_flow
  include_context "sub-task", Upsteem::Deploy::Tasks::GemsUpdateFlow, :gems_update_flow
  include_context "sub-task", Upsteem::Deploy::Tasks::Notification, :notification

  let(:gems_update_flow_occurrences) { 0 }

  let(:start_message) do
    "Starting deployment of #{feature_branch} to #{environment_name} " \
    "environment in #{project_path}"
  end

  let(:end_message_action) { :info }
  let(:end_messages) { ["Deploy OK"] }

  def expect_environment_source_code_update
    configure_expectation_for_sub_task(:feature_branch_inclusion_flow)
    configure_expectation_for_sub_task(:gems_update_flow)
  end

  # Override if needed
  def expect_environment_execution; end

  def expect_notification
    configure_expectation_for_sub_task(:notification)
  end

  shared_context "gems update flow" do
    let(:start_message) { "Starting deployment to #{environment_name} environment in #{project_path}" }
    let(:feature_branch) { nil }
    let(:feature_branch_inclusion_flow_occurrences) { 0 }
    let(:gems_update_flow_occurrences) { 1 }
  end

  shared_context "failure messages" do
    let(:end_message_action) { :error }
    # failure_description must be defined in the context that depends on failure messages
    let(:end_messages) do
      [failure_description, "Deploy failed"]
    end
  end

  shared_context "occurrence of exception" do |sub_task_label, klass, msg|
    include_context "failure messages"

    let(:failure_description) { msg }
    let(:run_result) { false }

    let("#{sub_task_label}_error".to_sym) do
      [klass, msg]
    end
  end

  shared_context "occurrence of exception with cause" do |sub_task_label, klass, msg, cause|
    include_context "occurrence of exception", sub_task_label, klass, msg

    let(:failure_description) { "#{msg}. Cause: #{cause}" }

    before do
      allow_any_instance_of(klass).to receive(:cause).and_return(cause)
    end
  end

  shared_context "expectations for run" do
    before do
      expect_logger_info(start_message)
      configure_expectation_for_sub_task(:git_status_validation)
      expect_environment_source_code_update
      expect_environment_execution
      expect_notification
      end_messages.each { |msg| expect_logger_action(end_message_action, msg) }
    end
  end
end
