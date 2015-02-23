require_relative "../step_definitions/wicked_cleanup.rb"

# Preparation before each scenario
Before do |scenario|
  SUT.test_and_drop_results "testuser", "log.sh ========================== " + %x(date) + " ======================="
  SUT.test_and_drop_results "testuser", "log.sh Preparing a clean environment"
  #
  prepareReference()
  #
  prepareSut()
  #
  fn = scenario.feature.name.split(/\n/)[0]
  sn = scenario.name
  SUT.test_and_drop_results "log.sh \"Feature: #{fn} - Scenario: #{sn}\""
  STDOUT.puts "Feature: #{fn} - Scenario: #{sn}"
  #
  @skip_when_virtual_machine = false
  @skip_when_no_hotplug = false
end

# Cleanup after each scenario
After do
end
