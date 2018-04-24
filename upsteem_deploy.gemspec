Gem::Specification.new do |gem|
  gem.files         = Dir["lib/**/*"]
  gem.name          = "upsteem-deploy"
  gem.summary       = "Upsteem deployment procedure"
  gem.version       = "0.0.1"

  gem.authors       = ["Kristjan Uibo"]
  gem.email         = ["kristjan.uibo@upsteem.com"]
  gem.description   = "Standardizes the deployment procedure of Upsteem applications and gems"
  gem.homepage      = "https://github.com/upsteem/deploy"
  gem.license       = "MIT"

  gem.add_dependency "git", "~> 1.3.0"
end
