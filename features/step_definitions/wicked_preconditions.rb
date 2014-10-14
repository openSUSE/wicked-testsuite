# # # Preconditions # # #

Given /^nanny is enabled$/ do
  out, * = SUT.test_and_store_results_together \
    "root", "grep '<use-nanny>.*</use-nanny>' /etc/wicked/common.xml"
  if out.include? "false"
    @skip_next_steps = true
    puts "(false - will skip rest of scenario)"
  end
end

Given /^the system under tests in running on real hardware$/ do
  if ENV["TARGET_SUT"].start_with? "virtio:"
    # WORKAROUND - hotplug with bonds does not work in VMs
    @skip_ping_test = true
    puts "(false - will skip ping test)"
  end
end

