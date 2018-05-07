%w[
  system
  bundler
  capistrano
  git
].each do |file|
  require_relative("proxies/#{file}")
end
