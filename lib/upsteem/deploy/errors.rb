%w[
  deploy_error
  invalid_environment
  merge_conflict
].each do |file|
  require_relative("errors/#{file}")
end
