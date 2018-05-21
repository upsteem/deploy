module Upsteem
  module Deploy
    module Tasks
      class TargetBranchUpload < Task
        extend Memoist

        def run
          git.must_be_current_branch!(target_branch)
          run_tests
          commit
          push
          true
        end

        private

        attr_reader :test_runner

        def inject(services_container)
          @test_runner = services_container.test_runner
        end

        def after_initialize
          commit_message
        end

        def commit_message
          options[:message] || raise(ArgumentError, "Commit message not supplied via :message option")
        end
        memoize :commit_message

        def run_tests
          test_runner.run_tests
        rescue Errors::FailingTestSuite => e
          handle_failing_test_suite
          raise(e)
        end

        def handle_failing_test_suite
          git.abort_merge
        end

        def commit
          git.commit(commit_message, all: true)
        end

        def push
          git.push("origin", target_branch)
        end
      end
    end
  end
end
