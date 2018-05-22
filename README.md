# Purpose
To simplify the deploy procedure of Upsteem applications and gems.

# How to use in a project?
Create an executable ruby script at the project root.

## The simplest usage in an application
```ruby
Upsteem::Deploy.deploy_application(
  File.dirname(__FILE__), ARGV[0], ARGV[1]
)
```

## The simplest usage in a gem

```ruby
Upsteem::Deploy.deploy_gem(
  File.dirname(__FILE__), ARGV[0], ARGV[1]
)
```

## When application (or gem) depends on other gems
Use configuration parameters:

```ruby
Upsteem::Deploy.deploy_application(
  File.dirname(__FILE__), ARGV[0], ARGV[1],
  shared_gems_to_update: %w(gem1),
  env_gems_to_update: %w(gem2)
)
```

The gems listed in `:env_gems_to_update` are defined in environment-specific Gemfile (e.g. Gemfile.dev)
while the ones listed in `:shared_gems_to_update` do not depend on environment.

## When deploy notifications need to be sent
Notification URL and parameters should be defined in a configuration file which path should be passed
as an option:

```ruby
Upsteem::Deploy.deploy_application(
  File.dirname(__FILE__), ARGV[0], ARGV[1],
  notifications: "config/deploy/notifications.yml"
)
```

## When test suite needs to be run during deploy
YAML configuration file path should be supplied via `:test_suite` option:

```ruby
Upsteem::Deploy.deploy_application(
  File.dirname(__FILE__), ARGV[0], ARGV[1],
  test_suite: "config/deploy/test_suite.yml"
)
```

### Sample data in configuration file:

```
framework: rspec
```
