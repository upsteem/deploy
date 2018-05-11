%w[
  http_request
].each do |file|
  require_relative("models/#{file}")
end
