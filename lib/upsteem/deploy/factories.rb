%w[
  test_runner_factory
].each do |file|
  require_relative("factories/#{file}")
end
