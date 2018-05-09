%w[
  system
  bundler
  capistrano
  git
  verbose_git
].each do |file|
  require_relative("proxies/#{file}")
end
