module Upsteem
  module Deploy
  end
end

%w[
  deploy/deployer
].each do |path|
  require_relative(path)
end
