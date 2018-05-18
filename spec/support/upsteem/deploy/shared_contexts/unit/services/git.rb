shared_context "setup for git service" do
  let(:project_path) { "/path/to/project" }
  let(:git) { instance_double("Git::Base") }

  # Override according to situation:
  let(:nested_receiver) { git }
  let(:nested_method_arguments) { [] }

  let(:git_service) { described_class.new(project_path) }

  # Override these according to the particular situation:
  def expect_before_nested_method_call; end

  def expect_after_nested_method_call; end

  def expect_nested_method_call
    expect_to_receive_exactly_ordered_and_return(
      1, nested_receiver, nested_method, nested_result, *nested_method_arguments
    )
  end

  shared_context "nested method call error" do
    def expect_nested_method_call
      expect_to_receive_exactly_ordered_and_raise(
        1, nested_receiver, nested_method, nested_exception, *nested_method_arguments
      )
    end
  end

  def configure_method_specific_before_hooks
    expect_before_nested_method_call
    expect_nested_method_call
    expect_after_nested_method_call
  end

  shared_context "setup for instance creation" do
    subject { git_service }
    # Override to disable:
    def expect_nested_method_call; end

    def expect_before_nested_method_call; end

    def expect_after_nested_method_call; end
  end

  before do
    allow(Git).to receive(:open).with(project_path).once.and_return(git)
    configure_method_specific_before_hooks
  end

  shared_context "setup for current_branch" do
    let(:nested_method) { :current_branch }
    let(:nested_result) { "somebranch" }

    subject { git_service.current_branch }
  end

  shared_context "setup for must_be_current_branch!" do
    let(:current_branch) { "currentbranch" }
    let(:other_branch) { "otherbranch" }
    let(:branch) { current_branch }

    let(:nested_method) { :current_branch }
    let(:nested_result) { current_branch }

    subject { git_service.must_be_current_branch!(branch) }
  end

  shared_context "setup for status" do
    let(:nested_method) { :status }
    let(:nested_result) { instance_double("Git::Status") }

    subject { git_service.status }
  end

  shared_context "setup for checkout" do
    let(:branch) { "somebranch" }
    let(:predefined_exception_message) { "Error while checking out #{branch}" }

    let(:nested_method) { :checkout }
    let(:nested_method_arguments) { [branch] }
    let(:nested_result) { "Checked out #{branch}" }

    subject { git_service.checkout(branch) }
  end

  shared_context "setup for pull" do
    let(:repository) { "somereponame" }
    let(:branch) { "somebranch" }
    let(:predefined_exception_message) { "Error while pulling from #{repository}/#{branch}" }

    let(:nested_method) { :pull }
    let(:nested_method_arguments) { [repository, branch] }
    let(:nested_result) { "Already up-to-date" }

    subject { git_service.pull(repository, branch) }
  end

  shared_context "setup for must_be_in_sync!" do
    let(:git_log) { instance_double("Git::Log") }
    let(:git_log_between) { instance_double("Git::Log") }
    let(:git_log_size) { 0 }
    let(:branch) { "somebranch" }
    let(:predefined_exception_message) { "Error while comparing #{branch} with remote" }

    let(:nested_receiver) { git_log_between }
    let(:nested_method) { :size }
    let(:nested_result) { git_log_size }

    subject { git_service.must_be_in_sync!(branch) }

    before do
      allow(git).to receive(:log).and_return(git_log)
      allow(git_log).to receive(:between).with("origin/#{branch}", branch).and_return(git_log_between)
    end
  end

  shared_context "setup for commit" do
    let(:commit_message) { "Fixed some bugs" }
    let(:commit_options) { { all: true } }
    let(:predefined_exception_message) do
      "Error while committing with #{commit_message.inspect}, #{commit_options.inspect}"
    end

    let(:nested_method) { :commit }
    let(:nested_method_arguments) { [commit_message, commit_options] }
    let(:nested_result) { "Successfully committed changes" }

    subject { git_service.commit(commit_message, commit_options) }
  end

  shared_context "setup for push" do
    let(:remote) { "origin" }
    let(:branch) { "somebranch" }
    let(:predefined_exception_message) do
      "Error while pushing to #{remote}/#{branch}"
    end

    let(:nested_method) { :push }
    let(:nested_method_arguments) { [remote, branch] }
    let(:nested_result) { "Successfully pushed changes" }

    subject { git_service.push(remote, branch) }
  end

  shared_context "setup for create_merge_commit" do
    let(:git_lib) { instance_double("Git::Lib") }
    let(:branch) { "somebranch" }
    let(:current_branch) { "currentbranch" }
    let(:unmerged) { [] }
    let(:references_to_unmerged) { 1 }
    let(:predefined_exception_message) do
      "Error while creating merge commit from #{branch} to #{current_branch}"
    end

    let(:nested_receiver) { git_lib }
    let(:nested_method) { :command }
    let(:nested_method_arguments) { ["merge", [branch, "--no-commit", "--no-ff"]] }
    let(:nested_result) { "Merge went well, stopping before committing" }

    def expect_nested_method_call
      super
      expect_to_receive_exactly_ordered_and_return(
        references_to_unmerged, git_lib, :unmerged, unmerged
      )
    end

    subject { git_service.create_merge_commit(branch) }

    before do
      allow(git).to receive(:current_branch).and_return(current_branch)
      allow(git).to receive(:lib).and_return(git_lib)
    end
  end

  shared_context "setup for abort_merge" do
    let(:git_lib) { instance_double("Git::Lib") }
    let(:predefined_exception_message) { "Error while aborting the merge" }

    let(:nested_receiver) { git_lib }
    let(:nested_method) { :command }
    let(:nested_method_arguments) { ["merge", ["--abort"]] }
    let(:nested_result) { "Merge aborted" }

    subject { git_service.abort_merge }

    before do
      allow(git).to receive(:lib).and_return(git_lib)
    end
  end

  shared_context "setup for head_revision" do
    let(:predefined_exception_message) { "Error while looking up HEAD revision" }

    let(:nested_method) { :revparse }
    let(:nested_method_arguments) { ["HEAD"] }
    let(:nested_result) { "e75a24006f7fadfbc48d75d871ee299b13e90983" }

    subject { git_service.head_revision }
  end

  shared_context "setup for user_name" do
    let(:predefined_exception_message) { "Error while looking up user name" }

    let(:user_name) { "John Doe" }
    let(:config) { { "user.name" => user_name } }
    let(:nested_method) { :config }
    let(:nested_result) { config }

    subject { git_service.user_name }
  end
end
