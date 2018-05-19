%w[
  system
  bundler
  capistrano
  git
  verbose_git
  test_runners
  notifier
].each do |file|
  require_relative("services/#{file}")
end
