%w[
  base
  skipper
  rspec
].each do |file|
  require_relative("test_suite_runners/#{file}")
end
