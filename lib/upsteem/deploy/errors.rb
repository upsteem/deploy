%w[
  deploy_error
  invalid_environment
  configuration_error
  merge_conflict
  http_error
].each do |file|
  require_relative("errors/#{file}")
end
