shared_context "examples for git service" do
  shared_examples_for "instance creation success" do
    include_context "setup for instance creation"
    it { is_expected.to eq(git_service) }
  end

  shared_examples_for "instance creation failure" do |*exception|
    include_context "setup for instance creation"
    it_behaves_like "exception raiser", *exception
  end

  shared_examples_for "instance creation failure on missing project path" do
    let(:project_path) { nil }
    it_behaves_like "instance creation failure", ArgumentError, "Project path not supplied"
  end

  shared_examples_for "nested result returner" do
    it { is_expected.to eq(nested_result) }
  end

  shared_examples_for "nested error re-raiser" do |re_raised_message|
    let(:nested_exception) { [Git::GitExecuteError, "Something went wrong during git execute"] }

    let(:predefined_exception) do
      [Upsteem::Deploy::Errors::DeployError, re_raised_message || predefined_exception_message]
    end

    include_context "nested method call error"

    # Anything after the failing call should not run.
    def expect_after_nested_method_call; end

    it_behaves_like "exception raiser"
  end

  shared_examples_for "current_branch instance method in Services::Git" do
    it_behaves_like "nested result returner"
    it_behaves_like "nested error re-raiser", "Error while looking up current branch"
  end

  shared_examples_for "must_be_current_branch! instance method in Services::Git" do
    it { is_expected.to eq(true) }

    it_behaves_like "nested error re-raiser", "Error while looking up current branch"

    context "when given branch is not current branch" do
      let(:branch) { other_branch }

      let(:predefined_exception) do
        [
          Upsteem::Deploy::Errors::DeployError,
          "Expected current branch to be #{other_branch}, but it was #{current_branch}"
        ]
      end

      it_behaves_like "exception raiser"
    end
  end

  shared_examples_for "status instance method in Services::Git" do
    it_behaves_like "nested result returner"
    it_behaves_like "nested error re-raiser", "Error while checking git status"
  end

  shared_examples_for "checkout instance method in Services::Git" do
    it_behaves_like "nested result returner"
    it_behaves_like "nested error re-raiser"
  end

  shared_examples_for "pull instance method in Services::Git" do
    it_behaves_like "nested result returner"
    it_behaves_like "nested error re-raiser"
  end

  shared_examples_for "must_be_in_sync! instance method in Services::Git" do
    it { is_expected.to eq(true) }

    context "when log size is nil" do
      let(:git_log_size) { nil }
      let(:predefined_exception) do
        [
          Upsteem::Deploy::Errors::DeployError,
          "No information found"
        ]
      end

      it_behaves_like "exception raiser"
    end

    context "when log size is not zero" do
      let(:git_log_size) { 1 }
      let(:predefined_exception) do
        [
          Upsteem::Deploy::Errors::DeployError,
          "#{branch} in local repository is not in sync with remote repository!"
        ]
      end

      it_behaves_like "exception raiser"
    end

    it_behaves_like "nested error re-raiser"
  end

  shared_examples_for "commit instance method in Services::Git" do
    shared_examples_for "result returner or error raiser" do
      it_behaves_like "nested result returner"
      it_behaves_like "nested error re-raiser"

      context "when nested error contains 'nothing to commit' message" do
        let(:nested_exception) do
          [Git::GitExecuteError, " Nothing to commit. Working directory clean."]
        end
        let(:nested_result) { nested_exception[1] }

        it_behaves_like "nested result returner"
      end
    end

    it_behaves_like "result returner or error raiser"

    context "when called without options argument" do
      let(:commit_options) { {} }
      subject { git_service.commit(commit_message) }
      it_behaves_like "result returner or error raiser"
    end
  end

  shared_examples_for "push instance method in Services::Git" do
    it_behaves_like "nested result returner"
    it_behaves_like "nested error re-raiser"
  end

  shared_examples_for "create_merge_commit instance method in Services::Git" do
    it_behaves_like "nested result returner"
    it_behaves_like "nested error re-raiser"

    context "when unmerged files left after merge" do
      let(:unmerged) { ["/path/to/something"] }
      let(:predefined_exception) do
        [Upsteem::Deploy::Errors::MergeConflict, "Unmerged changes detected: #{unmerged.inspect}"]
      end

      def expect_after_nested_method_call; end

      it_behaves_like "exception raiser"
    end

    context "when nested error contains 'conflict' message" do
      include_context "nested method call error"

      let(:nested_exception) do
        [Git::GitExecuteError, "CONFLICT."]
      end

      let(:predefined_exception) do
        [Upsteem::Deploy::Errors::MergeConflict, "Merge commit creation failed due to conflicts"]
      end

      def expect_after_nested_method_call; end

      it_behaves_like "exception raiser"
    end
  end

  shared_examples_for "abort_merge instance method in Services::Git" do
    it_behaves_like "nested result returner"
    it_behaves_like "nested error re-raiser"
  end

  shared_examples_for "head_revision instance method in Services::Git" do
    it_behaves_like "nested result returner"
    it_behaves_like "nested error re-raiser"
  end

  shared_examples_for "user_name instance method in Services::Git" do
    it { is_expected.to eq(user_name) }

    it_behaves_like "nested error re-raiser"
  end
end
