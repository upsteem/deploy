%w[
  test_suite_runner_factory
].each do |file|
  require_relative("factories/#{file}")
end
