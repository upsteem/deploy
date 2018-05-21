%w[
  deploy_error
  invalid_environment
  configuration_error
  merge_conflict
  failing_test_suite
  http_error
].each do |file|
  require_relative("errors/#{file}")
end
