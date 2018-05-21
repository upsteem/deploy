%w[
  base
  skipper
  rspec
].each do |file|
  require_relative("test_runners/#{file}")
end
