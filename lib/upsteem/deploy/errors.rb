%w[
  deploy_error
  invalid_environment
].each do |file|
  require_relative("errors/#{file}")
end
