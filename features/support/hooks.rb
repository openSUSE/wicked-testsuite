require_relative "../step_definitions/wicked_cleanup.rb"
require_relative "../step_definitions/wicked_ref_support.rb"

# Copying ifcg and other cfg files to REF
copyRefFiles()

# Initial preparation
AfterConfiguration do
  SUT.test_and_drop_results "log.sh reset"
end

# Preparation before each scenario
Before do |scenario|
  fn = scenario.feature.name.split(/\n/)[0]
  sn = scenario.name
  SUT.test_and_drop_results "log.sh scenario \"Feature: #{fn} - Scenario: #{sn}\""
  SUT.test_and_drop_results "log.sh step \"Cleanup (#{sn})\""
  #
  prepareReference()
  #
  prepareSut()
  #
  STDOUT.puts "Feature: #{fn} - Scenario: #{sn}"
  #
  @skip_when_virtual_machine = false
  @skip_when_no_hotplug = false
end

# Cleanup after each scenario
After do
  STDOUT.flush
end
