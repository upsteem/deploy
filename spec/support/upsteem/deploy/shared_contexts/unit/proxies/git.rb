shared_context "setup for git proxy" do
  let(:project_path) { "/path/to/project" }
  let(:git) { instance_double("Git::Base") }

  # Override according to situation:
  let(:nested_receiver) { git }
  let(:nested_method_arguments) { [] }

  let(:git_proxy) { described_class.new(project_path) }

  # Override these according to the particular situation:
  def expect_before_nested_method_call; end

  def expect_after_nested_method_call; end

  def expect_nested_method_call
    expect_to_receive_exactly_ordered_and_return(
      1, nested_receiver, nested_method, nested_result, *nested_method_arguments
    )
  end

  def configure_method_specific_before_hooks
    expect_before_nested_method_call
    expect_nested_method_call
    expect_after_nested_method_call
  end

  shared_context "setup for instance creation" do
    subject { git_proxy }
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

    subject { git_proxy.current_branch }
  end

  shared_context "setup for must_be_current_branch!" do
    let(:current_branch) { "currentbranch" }
    let(:other_branch) { "otherbranch" }
    let(:branch) { current_branch }

    let(:nested_method) { :current_branch }
    let(:nested_result) { current_branch }

    subject { git_proxy.must_be_current_branch!(branch) }
  end

  shared_context "setup for status" do
    let(:nested_method) { :status }
    let(:nested_result) { instance_double("Git::Status") }

    subject { git_proxy.status }
  end

  shared_context "setup for checkout" do
    let(:branch) { "somebranch" }
    let(:predefined_exception_message) { "Error while checking out #{branch}" }

    let(:nested_method) { :checkout }
    let(:nested_method_arguments) { [branch] }
    let(:nested_result) { "Checked out #{branch}" }

    subject { git_proxy.checkout(branch) }
  end

  shared_context "setup for pull" do
    let(:repository) { "somereponame" }
    let(:branch) { "somebranch" }
    let(:predefined_exception_message) { "Error while pulling from #{repository}/#{branch}" }

    let(:nested_method) { :pull }
    let(:nested_method_arguments) { [repository, branch] }
    let(:nested_result) { "Already up-to-date" }

    subject { git_proxy.pull(repository, branch) }
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

    subject { git_proxy.must_be_in_sync!(branch) }

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

    subject { git_proxy.commit(commit_message, commit_options) }
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

    subject { git_proxy.push(remote, branch) }
  end
end
