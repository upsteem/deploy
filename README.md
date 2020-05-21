# Purpose
To simplify the deploy procedure of Upsteem applications and gems.

# How to use in a project?
Create an executable ruby script at the project root.

## Usage in an application
```ruby
Upsteem::Deploy.deploy_application(
  File.dirname(__FILE__), ARGV[0], ARGV[1]
)
```
With YAML configuration file:

```ruby
Upsteem::Deploy.deploy_application(
  File.dirname(__FILE__), ARGV[0], ARGV[1], "config/deploy.yml"
)
```

## Usage in a gem

```ruby
Upsteem::Deploy.deploy_gem(
  File.dirname(__FILE__), ARGV[0], ARGV[1]
)
```
With YAML configuration file:

```ruby
Upsteem::Deploy.deploy_gem(
  File.dirname(__FILE__), ARGV[0], ARGV[1], "config/deploy.yml"
)
```

## When application (or gem) depends on other gems
In the configuration file used in the examples above, declare:

```yaml
shared_gems_to_update:
  - gem1
env_gems_to_update:
  - gem2
  - gem3
```

The gems listed in `:env_gems_to_update` are defined in environment-specific Gemfile (e.g. Gemfile.dev)
while the ones listed in `:shared_gems_to_update` do not depend on environment.

## When deploy notifications need to be sent
In the main configuration file (e.g. config/deploy.yml), declare `:notifications` parameter which should point to another configuration file specific to the notification API you're using:

```yaml
notifications: config/deploy/notifications.yml
```

## When test suite needs to be run during deploy
Test suite YAML configuration file path should be supplied via `:test_suite` configuration parameter:

```yaml
test_suite: config/deploy/test_suite.yml
```

### Sample data in test suite configuration file:

```yaml
framework: rspec
```
