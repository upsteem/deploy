%w[
  system
  bundler
  capistrano
  git
  verbose_git
  notifier
].each do |file|
  require_relative("proxies/#{file}")
end
