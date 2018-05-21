%w[
  base
  skipper
  runner
  rspec
].each do |file|
  require_relative("test_suite_runners/#{file}")
end
