Gem::Specification.new do |gem|
  gem.files         = Dir["lib/**/*"]
  gem.name          = "upsteem-deploy"
  gem.summary       = "Upsteem deployment procedure"
  gem.version       = "1.1.0"

  gem.authors       = ["Kristjan Uibo"]
  gem.email         = ["kristjan.uibo@upsteem.com"]
  gem.description   = "Standardizes the deployment procedure of Upsteem applications and gems"
  gem.homepage      = "https://github.com/upsteem/deploy"
  gem.license       = "MIT"

  gem.add_dependency "activesupport", "~> 4.2"
  gem.add_dependency "faraday", ">= 0.8", "< 0.18"
  gem.add_dependency "git", "~> 1.7.0"
  gem.add_dependency "memoist", "~> 0.14.0"
  gem.add_dependency "multipart-post", "< 2.2.0" # faraday breaks with 2.2.0
end
