%w[
  standard_input_service
  system
  bundler
  capistrano
  git
  verbose_git
  rollbacker
  test_suite_runners
  notifier
].each do |file|
  require_relative("services/#{file}")
end
