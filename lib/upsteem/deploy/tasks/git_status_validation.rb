module Upsteem
  module Deploy
    module Tasks
      class GitStatusValidation < Task
        extend Memoist

        def run
          logger.info("Checking git status")
          report.clean? ? validation_successful : validation_failed
        end

        private

        def status
          git.status
        end
        memoize :status

        def report
          StatusReport.create(status)
        end
        memoize :report

        def validation_successful
          logger.info("Git status is clean")
          true
        end

        def validation_failed
          logger.error(report.description)
          log_untracked_files
          raise Errors::DeployError, "Please take necessary steps (e.g. commit manually) until git status is clean!"
        end

        def log_untracked_files
          return if report.untracked.zero?
          logger.error("Untracked files:")
          logger.error(status.untracked.keys.sort.join("\n"))
        end

        class StatusReport
          private_class_method :new

          attr_reader :changed, :added, :deleted, :untracked

          def self.create(status)
            new(
              status.changed.size,
              status.added.size,
              status.deleted.size,
              status.untracked.size
            )
          end

          def clean?
            changed.zero? && added.zero? && deleted.zero? && untracked.zero?
          end

          def description
            "According to git status, there are #{changed} changed, #{added} added, " \
            "#{deleted} deleted and #{untracked} untracked files. All of these should be 0."
          end

          private

          def initialize(changed, added, deleted, untracked)
            @changed = changed
            @added = added
            @deleted = deleted
            @untracked = untracked
          end
        end
      end
    end
  end
end
