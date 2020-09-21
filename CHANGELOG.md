# Version History

## 0.0.1

## 0.1.0

## 0.2.0

## 1.0.0

* **deploy_gem** and **deploy_application** methods no longer accept configuration parameters as options hash, but they now accept an optional configuration file relative path instead.
* The configuration file is in YAML format and its content will be marshalled into the options hash.
* **additional_target_branches** option has been implemented in configuration. Map additional environments into their associated branches using this configuration option.
* Fixed an issue with loading empty yml files by ensuring that an empty hash will be returned in that case.

## 1.0.1

* Updated usage instructions in README.

## 1.1.0

* Updated ruby-git from 1.3.0 to 1.7.0.
