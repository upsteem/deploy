%w[
  usage
  http_request
].each do |file|
  require_relative("builders/#{file}")
end
