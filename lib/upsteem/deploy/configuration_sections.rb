%w[
  section
  notification_configuration
  factory
].each do |file|
  require_relative("configuration_sections/#{file}")
end
