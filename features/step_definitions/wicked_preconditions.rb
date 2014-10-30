# # # Preconditions # # #

Given /^nanny is enabled$/ do
  out, * = SUT.test_and_store_results_together \
    "root", "grep '<use-nanny>.*</use-nanny>' /etc/wicked/common.xml"
  if out.include? "false"
    @skip_when_no_hotplug = true
    puts "(false - will skip some steps)"
  end
end

Given /^the system under tests in running on real hardware$/ do
  if TARGET_SUT.start_with? "virtio:"
    @skip_when_virtual_machine = true
    puts "(false - will skip some steps)"
  end
end

Given /^infiniband is supported on both machines$/ do
# Hack
# TODO: ALT_SUT => SUT
#       ALT_REF => REF
  out_sut, * = ALT_SUT.test_and_store_results_together \
    "root", "lsmod"
  out_ref, * = ALT_REF.test_and_store_results_together \
    "root", "lsmod"
  if not(/^ib_ipoib/.match(out_sut) and /^ib_ipoib/.match(out_ref))
    @skip_when_no_infiniband = true
    puts "(false - will skip some steps)"
  end
end
