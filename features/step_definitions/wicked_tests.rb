# # # Tests # # #

Then /^I should be able to bring up interface ([^ ]*)$/ do |interface|
  SUT.test_and_drop_results "log.sh step \"Then I should be able to bring up interface #{interface}\""
  local, remote, command = SUT.test_and_drop_results \
    "wic.sh ifup #{interface}"
  local.should == 0; remote.should == 0
  command.should == 0
end

Then /^I should not be able to bring up interface ([^ ]*)$/ do |interface|
  SUT.test_and_drop_results "log.sh step \"Then I should not be able to bring up interface #{interface}\""
  local, remote, command = SUT.test_and_drop_results \
    "wic.sh ifup #{interface}"
  local.should == 0; remote.should == 0
  command.should_not == 0
end

Then /^all server daemons should be up and running$/ do
  SUT.test_and_drop_results "log.sh step \"Then all server daemons should be up and running\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "ps aux | grep wicked", "testuser"
  local.should == 0; remote.should == 0
  out.should include "wickedd-dhcp4 "
  out.should include "wickedd-dhcp6 "
  out.should include "wickedd-auto4 "
  out.should include "wickedd "
  out.should include "wickedd-nanny "
end

Then /^no more server daemon should be left$/ do
  SUT.test_and_drop_results "log.sh step \"Then no more server daemon should be left\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "ps aux | grep wicked", "testuser"
  local.should == 0; remote.should == 0
  out.should_not include "wickedd"
end

Then /^the interface ([^ ]*) should be up and running$/ do |interface|
  SUT.test_and_drop_results "log.sh step \"Then the interface #{interface} should be up and running\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "ip link show dev #{interface}", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "state UP"
end

Then /^the interface ([^ ]*) should be down$/ do |interface|
  SUT.test_and_drop_results "log.sh step \"Then the interface #{interface} should be down\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "ip link show dev #{interface}", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "state DOWN"
end

Then /^the brief status of ([^ ]*) should be "([^"]*)"$/ do |interface, state|
  SUT.test_and_drop_results "log.sh step \"Then the brief status of #{interface} should be #{state}\""
  @briefstatus.should match /#{interface}\s+#{state}/
end

Then /^the brief status of ([^ ]*) should not be "([^"]*)"$/ do |interface, state|
  SUT.test_and_drop_results "log.sh step \"Then the brief status of #{interface} should be #{state}\""
  @briefstatus.should_not match /#{interface}\s+#{state}/
end

Then /^all ([0-9]*) bridges should be (UP|deleted)$/ do |number, state|
  SUT.test_and_drop_results "log.sh step \"Then all #{number} bridges should be #{state}\""
  local, remote, command = SUT.test_and_drop_results \
    "/usr/local/bin/check_many_bridges.sh #{number} #{state}", "testuser"
end

Then /^netlink messages should not contain "([^"]*)"$/ do |text|
  SUT.test_and_drop_results "log.sh step \"Then netlink messages should not contain #{text}\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "journalctl -b -u wickedd -u wickedd-dhcp4 | grep netlink"
  out.should_not include "#{text}"
end

Then /^I should see all network interfaces$/ do
  SUT.test_and_drop_results "log.sh step \"Then I should see all network interfaces\""
  @showall.should match /^lo/
  @showall.should match /^eth0/
  @showall.should match /^eth1/
end

Then /^I should be able to ping (?:a |the )reference machine from my static address$/ do
  SUT.test_and_drop_results "log.sh step \"Then I should be able to ping a reference machine from my static address\""
  local, remote, command = SUT.test_and_drop_results \
    "ping -q -c1 -W1 #{STAT4_REF0}", "testuser"
  local.should == 0; remote.should == 0
  command.should == 0
  #
  local, remote, command = SUT.test_and_drop_results \
    "ping6 -q -c1 -W1 #{STAT6_REF0}", "testuser"
  local.should == 0; remote.should == 0
  command.should == 0
end

Then /^I should not be able to ping (?:a |the )reference machine from my static address$/ do
  SUT.test_and_drop_results "log.sh step \"Then I should not be able to ping a reference machine from my static address\""
  local, remote, command = SUT.test_and_drop_results \
    "ping -q -c1 -W1 #{STAT4_REF0}", "testuser"
  local.should == 0; remote.should == 0
  command.should_not == 0
  #
  local, remote, command = SUT.test_and_drop_results \
    "ping6 -q -c1 -W1 #{STAT6_REF0}", "testuser"
  local.should == 0; remote.should == 0
  command.should_not == 0
end

Then /^I should be able to ping (?:a |the )reference machine from my dynamic address$/ do
  SUT.test_and_drop_results "log.sh step \"Then I should be able to ping a reference machine from my dynamic address\""
  local, remote, command = SUT.test_and_drop_results \
    "ping -q -c1 -W1 #{DHCP4_REF0}", "testuser"
  local.should == 0; remote.should == 0
  command.should == 0
  #
  local, remote, command = SUT.test_and_drop_results \
    "ping6 -q -c1 -W1 #{RADVD_REF0}", "testuser"
  local.should == 0; remote.should == 0
  command.should == 0
  #
  # DHCPv6 cannot be used to distribute a route (at least without hacks)
end

Then /^I should not be able to ping (?:a |the )reference machine from my dynamic address$/ do
  SUT.test_and_drop_results "log.sh step \"Then I should not be able to ping a reference machine from my dynamic address\""
  local, remote, command = SUT.test_and_drop_results \
    "ping -q -c1 -W1 #{DHCP4_REF0}", "testuser"
  local.should == 0; remote.should == 0
  command.should_not == 0
  #
  local, remote, command = SUT.test_and_drop_results \
    "ping6 -q -c1 -W1 #{RADVD_REF0}", "testuser"
  local.should == 0; remote.should == 0
  command.should_not == 0
  #
  # DHCPv6 cannot be used to distribute a route (at least without hacks)
end

Then /^I should be able to ping a host in the outside World$/ do
  SUT.test_and_drop_results "log.sh step \"Then I should be able to ping a host in the outside World\""
  local, remote, command = SUT.test_and_drop_results \
    "ping -q -c1 -W1 #{STAT4_OUT}", "testuser"
  local.should == 0; remote.should == 0
  command.should == 0
  #
  # Ugly hack to make sure ping6 works from reference to the outside
  local, remote, command = REF.test_and_drop_results "ping6 -q -c1 -w10 #{STAT6_OUT}", "testuser"
  local.should == 0; remote.should == 0
  command.should == 0
  #
  local, remote, command = SUT.test_and_drop_results \
    "ping6 -q -c1 -W1 #{STAT6_OUT}", "testuser"
  local.should == 0; remote.should == 0
  command.should == 0
end

Then /^I should not be able to ping a host in the outside World$/ do
  SUT.test_and_drop_results "log.sh step \"Then I should not be able to ping a host in the outside World\""
  local, remote, command = SUT.test_and_drop_results \
    "ping -q -c1 -W1 #{STAT4_OUT}", "testuser"
  local.should == 0; remote.should == 0
  command.should_not == 0
  #
  # Ugly hack to make sure ping6 works from reference to the outside
  local, remote, command = REF.test_and_drop_results "ping6 -q -c1 -w10 #{STAT6_OUT}", "testuser"
  local.should == 0; remote.should == 0
  command.should_not == 0
  #
  local, remote, command = SUT.test_and_drop_results \
    "ping6 -q -c1 -W1 #{STAT6_OUT}", "testuser"
  local.should == 0; remote.should == 0
  command.should_not == 0
end

Then /^([^ ]*) should use the static addresses$/ do |interface|
  SUT.test_and_drop_results "log.sh step \"Then #{interface} should use the static addresses\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "ip address show dev #{interface}", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  case interface
    when "eth0"
      out.should include "inet #{STAT4_SUT0}"
      out.should include "inet6 #{STAT6_SUT0}"
    when "eth1"
      out.should include "inet #{STAT4_SUT1}"
      out.should include "inet6 #{STAT6_SUT1}"
    else
      raise "unknown interface"
  end
end

Then /^([^ ]*) should not use the static addresses$/ do |interface|
  SUT.test_and_drop_results "log.sh step \"Then #{interface} should not use the static addresses\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "ip address show dev #{interface}", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  case interface
    when "eth0"
      out.should_not include "inet #{STAT4_SUT0}"
      out.should_not include "inet6 #{STAT6_SUT0}"
    when "eth1"
      out.should_not include "inet #{STAT4_SUT1}"
      out.should_not include "inet6 #{STAT6_SUT1}"
    else
      raise "unknown interface"
  end
end

Then /^([^ ]*) should use the dynamic addresses$/ do |interface|
  SUT.test_and_drop_results "log.sh step \"Then #{interface} should use the dynamic addresses\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "ip address show dev #{interface}", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "inet #{DHCP4_SUT0}"
  out.should include "inet6 #{RADVD_SUT0}"
  out.should include "inet6 #{DHCP6_SUT0}"
end

Then /^([^ ]*) should not use the dynamic addresses$/ do |interface|
  SUT.test_and_drop_results "log.sh step \"Then #{interface} should not use the dynamic addresses\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "ip address show dev #{interface}", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should_not include "inet #{DHCP4_SUT0}"
  # out.should_not include "inet6 #{RADVD_SUT0}"
  # There's little we can do to prevent from receiving RAs and setting addresses and routes accordingly
  out.should_not include "inet6 #{DHCP6_SUT0}"
end

Then /^([^ ]*) should not use any address$/ do |interface|
  SUT.test_and_drop_results "log.sh step \"Then #{interface} should not use any address\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "ip address show dev #{interface} | grep -v fe80:", "testuser"
  local.should == 0; remote.should == 0
  out.should_not include "inet"
end

Then /^I should have the correct MTU on eth0$/  do
  SUT.test_and_drop_results "log.sh step \"Then I should have the correct MTU on eth0\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "ip address show dev eth0", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "mtu 1418"
end

Then /^I should have static routes to the outside World$/ do
  SUT.test_and_drop_results "log.sh step \"Then I should have static routes to the outside World\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "ip -4 route show", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "default via #{STAT4_REF0}"
  #
  out, local, remote, command = SUT.test_and_store_results_together \
    "ip -6 route show", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "default via #{STAT6_REF0}"
end

Then /^I should not have static routes to the outside World$/ do
  SUT.test_and_drop_results "log.sh step \"Then I should not have static routes to the outside World\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "ip -4 route show", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should_not include "default via #{STAT4_REF0}"
  #
  out, local, remote, command = SUT.test_and_store_results_together \
    "ip -6 route show", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should_not include "default via #{STAT6_REF0}"
end

Then /^I should have dynamic routes to the outside World$/ do
  SUT.test_and_drop_results "log.sh step \"Then I should have dynamic routes to the outside World\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "ip -4 route show", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "default via #{DHCP4_REF0}"
  #
  out, * = REF.test_and_store_results_together \
    "ip -6 address show dev eth0 | grep \"scope link\"", "testuser"
  ref_link_local = out.strip.sub /^inet6 ([0-9a-f:]*)\/64 scope link$/, '\1'
  out, local, remote, command = SUT.test_and_store_results_together \
    "ip -6 route show", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "default via #{ref_link_local} dev eth0  proto ra"
  #
  # DHCPv6 cannot be used to distribute a route (at least without hacks)
end

Then /^I should not have dynamic routes to the outside World$/ do
  SUT.test_and_drop_results "log.sh step \"Then I should not have dynamic routes to the outside World\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "ip -4 route show", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should_not include "default via #{DHCP4_REF0}"
  #
  # out.should_not include "default via #{ref_link_local} dev eth0  proto ra"
  # There's little we can do to prevent from receiving RAs and setting addresses and routes accordingly
  #
  # DHCPv6 cannot be used to distribute a route (at least without hacks)
end

Then /^eth0 should have a dynamic address after a while$/ do
  if @skip_when_no_hotplug
    puts "(skipped)"
    sleep 1
    next
  end
  SUT.test_and_drop_results "log.sh step \"Then eth0 should have a dynamic address after a while\""
  local, remote, command = SUT.test_and_drop_results \
    "wait_for_cmd_success.sh \"ip address show dev eth0 | grep #{DHCP4_SUT0}\"", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
end

Then /^I should follow the correct IPv4 route to a reference machine from eth1$/ do
  SUT.test_and_drop_results "log.sh step \"Then I should follow the correct IPv4 route to a reference machine from eth1\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "tracepath -n #{STAT4_GAT}", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "#{STAT4_REF1}"
end

Then /^I should follow the correct IPv6 route to a reference machine from eth1$/ do
  SUT.test_and_drop_results "log.sh step \"Then I should follow the correct IPv6 route to a reference machine from eth1\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "tracepath6 -l 64 -n #{STAT6_GAT}", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "#{STAT6_REF1}"
end

Then /^both machines should have a new ([^ ]*) card$/ do |interface|
  SUT.test_and_drop_results "log.sh step \"Then both machines should have a new #{interface} card\""
  out, local, remote, command = REF.test_and_store_results_together \
    "ip address show", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include ": #{interface}"
  out, local, remote, command = SUT.test_and_store_results_together \
    "ip address show", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include ": #{interface}"
end

Then /^([^ ]*) should be enslaved$/ do |interface|
  if @skip_when_no_hotplug
    puts "(skipped)"
    sleep 1
    next
  end
  SUT.test_and_drop_results "log.sh step \"Then #{interface} should be enslaved\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "ip address show dev #{interface}", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "SLAVE"
end

Then /^both cards should be enslaved to ([^ ]*)$/ do |master|
  if @skip_when_no_hotplug
    puts "(skipped)"
    sleep 1
    next
  end
  SUT.test_and_drop_results "log.sh step \"Then both cards should be enslaved to #{master}\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "ip address show dev eth0", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "master #{master}"
  out, local, remote, command = SUT.test_and_store_results_together \
    "ip address show dev eth1", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "master #{master}"
end

Then /^I should be able to ping the other side of the aggregated link$/ do
  # WORKAROUND (the @skip_when_virtual_machine part)
  if @skip_when_no_hotplug or @skip_when_virtual_machine
    puts "(skipped)"
    sleep 1
    next
  end
  SUT.test_and_drop_results "log.sh step \"Then I should be able to ping the other side of the aggregated link\""
  local, remote, command = SUT.test_and_drop_results \
    "ping -q -c1 -W1 #{BOND4_REF} -I #{BOND4_SUT[/[^\/]*/]}", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = SUT.test_and_drop_results \
    "ping6 -q -c1 -W1 #{BOND6_REF} -I #{BOND6_SUT[/[^\/]*/]}", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
end

Then /^I should be able to ping the other side of the VLAN$/ do
  SUT.test_and_drop_results "log.sh step \"Then I should be able to ping the other side of the VLAN\""
  local, remote, command = SUT.test_and_drop_results \
    "ping -q -c1 -W1 #{V42_4_REF}", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = SUT.test_and_drop_results \
    "ping6 -q -c1 -W1 #{V42_6_REF}", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
end

Then /^the scripts output should be as expected$/ do
  SUT.test_and_drop_results "log.sh step \"Then the scripts output should be as expected\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "cat /tmp/tests/results", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should match /^pre-up eth0
post-up eth0
    inet #{DHCP4_SUT0}.* scope global eth0
pre-down eth0
    inet #{DHCP4_SUT0}.* scope global eth0
post-down eth0$/
end

Then /^the post-up script should be called$/ do
  SUT.test_and_drop_results "log.sh step \"Then the post-up script should not be called\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "cat /tmp/tests/results", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "post-up"
end

Then /^the post-up script should not be called$/ do
  SUT.test_and_drop_results "log.sh step \"Then the post-up script should not be called\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "cat /tmp/tests/results", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should_not include "post-up"
end

Then /^there should be a new ([^ ]*) card$/ do |interface|
  SUT.test_and_drop_results "log.sh step \"Then there should be a new #{interface} card\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "ip address show", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include ": #{interface}"
end

Then /^there should not be the ([^ ]*) card anymore$/ do |interface|
  SUT.test_and_drop_results "log.sh step \"Then there should not be the #{interface} card anymore\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "ip address show", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should_not include ": #{interface}"
end

Then /^the ([^ ]*) card should still be there$/ do |interface|
  # almost the same as "there should be a new ([^ ]*) card"
  # only the log message differs
  SUT.test_and_drop_results "log.sh step \"Then the #{interface} card should still be there\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "ip address show", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include ": #{interface}"
end

Then /^the ([^ ]*) daemon should not be running anymore$/ do |process|
  SUT.test_and_drop_results "log.sh step \"Then the #{process} daemon should not be running anymore\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "ps aux | grep -v grep | grep #{process}", "testuser"
  local.should == 0; remote.should == 0
  out.should_not include "#{process}"
end

Then /^the bridge should have the correct address$/ do
  SUT.test_and_drop_results "log.sh step \"Then the bridge should have the correct address\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "ip address show dev br1", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "inet #{BRID4_SUT1}"
  out.should include "inet6 #{BRID6_SUT1}"
end

Then /^I should be able to ping through the bridge$/ do
  SUT.test_and_drop_results "log.sh step \"Then I should be able to ping through the bridge\""
  local, remote, command = SUT.test_and_drop_results \
    "ping -q -c1 -W1 #{STAT4_REF1} -I br1", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = SUT.test_and_drop_results \
    "ping6 -q -c1 -W1 #{STAT6_REF1} -I br1", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
end

Then /^the macvtap interface should have the correct address$/ do
  SUT.test_and_drop_results "log.sh step \"Then the macvtap interface should have the correct address\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "ip address show dev macvtap1", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "inet #{VTAP4_SUT1}"
  out.should include "inet6 #{VTAP6_SUT1}"
end

Then /^I should receive the answer of the ARP ping on \/dev\/tapX$/ do
  out, local, remote, command = SUT.test_and_store_results_together \
    "cat /tmp/tests/macvtap_results.txt", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "Success listening to tap device"
end

Then /^([^ ]*) should be part of the OVS bridge$/ do |interface|
  SUT.test_and_drop_results "log.sh step \"Then #{interface} should be part of the OVS bridge\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "ip address show dev #{interface}", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "master ovs-system"
end

Then /^the OVS bridge should have the correct address$/ do
  SUT.test_and_drop_results "log.sh step \"Then the OVS bridge should have the correct address\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "ip address show dev ovsbr1", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "inet #{OVS_4_SUT1}"
  out.should include "inet6 #{OVS_6_SUT1}"
end

Then /^I should be able to ping through the OVS bridge$/ do
  SUT.test_and_drop_results "log.sh step \"Then I should be able to ping through the OVS bridge\""
  local, remote, command = SUT.test_and_drop_results \
    "ping -q -c1 -W1 #{STAT4_REF1} -I ovsbr1", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = SUT.test_and_drop_results \
    "ping6 -q -c1 -W1 #{STAT6_REF1} -I ovsbr1", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
end

Then /^([^ ]*) should be part of the team$/ do |interface|
  SUT.test_and_drop_results "log.sh step \"Then #{interface} should be part of the team\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "ip address show dev #{interface}", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "master team0"
end

Then /^I should be able to ping the other side of the layer 3 tunnel$/ do
  SUT.test_and_drop_results "log.sh step \"Then I should be able to ping the other side of the layer 3 tunnel\""
  local, remote, command = SUT.test_and_drop_results \
    "ping -q -c1 -W1 #{OVPN4_REF1} -I tun1", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = SUT.test_and_drop_results \
    "ping6 -q -c1 -W1 #{OVPN6_REF1} -I tun1", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
end

Then /^the layer 3 tunnel owner and group are correct$/ do
  SUT.test_and_drop_results "log.sh step \"Then the layer 3 tunnel owner and group are correct\""
 owner, local, remote, command = SUT.test_and_store_results_together \
   "cat /sys/class/net/tun1/owner"
 local.should == 0; remote.should == 0; command.should == 0
 owner.strip.should == "#{OWNER_UID}"
 group, local, remote, command = SUT.test_and_store_results_together \
   "cat /sys/class/net/tun1/group"
 local.should == 0; remote.should == 0; command.should == 0
 group.strip.should == "#{GROUP_GID}"
end

Then /^I should be able to ping the other side of the layer 2 tunnel$/ do
  SUT.test_and_drop_results "log.sh step \"Then I should be able to ping the other side of the layer 2 tunnel\""
  local, remote, command = SUT.test_and_drop_results \
    "ping -q -c1 -W1 #{OVPN4_REF1} -I tap1", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = SUT.test_and_drop_results \
    "ping6 -q -c1 -W1 #{OVPN6_REF1} -I tap1", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
end

Then /^the layer 2 tunnel owner and group are correct$/ do
  SUT.test_and_drop_results "log.sh step \"Then the layer 2 tunnel owner and group are correct\""
 owner, local, remote, command = SUT.test_and_store_results_together \
   "cat /sys/class/net/tap1/owner"
 local.should == 0; remote.should == 0; command.should == 0
 owner.strip.should == "#{OWNER_UID}"
 group, local, remote, command = SUT.test_and_store_results_together \
   "cat /sys/class/net/tap1/group"
 local.should == 0; remote.should == 0; command.should == 0
 group.strip.should == "#{GROUP_GID}"
end


Then /^I should be able to ping the other side of the GRE tunnel$/ do
  SUT.test_and_drop_results "log.sh step \"Then I should be able to ping the other side of the GRE tunnel\""
  local, remote, command = SUT.test_and_drop_results \
    "ping -q -c1 -W1 #{GRE_4_REF1} -I gre1", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = SUT.test_and_drop_results \
    "ping6 -q -c1 -W1 #{GRE_6_REF1} -I gre1", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
end

Then /^I should be able to ping the other side of the IPIP tunnel$/ do
  SUT.test_and_drop_results "log.sh step \"Then I should be able to ping the other side of the IPIP tunnel\""
  local, remote, command = SUT.test_and_drop_results \
    "ping -q -c1 -W1 #{IPIP4_REF1} -I tunl1", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
end

Then /^I should be able to ping the other side of the SIT tunnel$/ do
  SUT.test_and_drop_results "log.sh step \"Then I should be able to ping the other side of the SIT tunnel\""
  local, remote, command = SUT.test_and_drop_results \
    "ping6 -q -c1 -W1 #{SIT_6_REF1} -I sit1", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
end

Then /^I should be able to ping the other side of the infiniband link$/ do
  if @skip_when_no_infiniband
    puts "(skipped)"
    sleep 1
    next
  end
  SUT.test_and_drop_results "log.sh step \"Then I should be able to ping the other side of the infiniband link\""
  local, remote, command = SUT.test_and_drop_results \
    "ping -q -c1 -W1 #{IBPA4_REF} -I ib0", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = SUT.test_and_drop_results \
    "ping6 -q -c1 -W1 #{IBPA6_REF} -I ib0", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
end

Then /^I should be able to ping the other side of the infiniband child link$/ do
  if @skip_when_no_infiniband
    puts "(skipped)"
    sleep 1
    next
  end
  SUT.test_and_drop_results "log.sh step \"Then I should be able to ping the other side of the infiniband child link\""
  local, remote, command = SUT.test_and_drop_results \
    "ping -q -c1 -W1 #{IBCH4_REF} -I ib0.8001", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = SUT.test_and_drop_results \
    "ping6 -q -c1 -W1 #{IBCH6_REF} -I ib0.8001", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
end

Then /^br0\.1 should have the correct address$/ do
  SUT.test_and_drop_results "log.sh step \"Then br0.1 should have the correct address\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "ip address show dev br0.1", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "inet #{VLAN4_SUT0}"
  out.should include "inet6 #{VLAN6_SUT0}"
end

Then /^eth0\.1 should have the correct address$/ do
  SUT.test_and_drop_results "log.sh step \"Then eth0.1 should have the correct address\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "ip address show dev eth0.1", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "inet #{VLAN4_SUT0}"
  out.should include "inet6 #{VLAN6_SUT0}"
end

Then /^I should be able to ping eth0\.1 on the other side$/ do
  SUT.test_and_drop_results "log.sh step \"Then I should be able to ping eth0.1 on the other side\""
  local, remote, command = SUT.test_and_drop_results \
    "ping -q -c1 -W1 #{VLAN4_REF0}", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = SUT.test_and_drop_results \
    "ping6 -q -c1 -W1 #{VLAN6_REF0}", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
end

Then /^eth0\.42 should have the correct address$/ do
  SUT.test_and_drop_results "log.sh step \"Then eth0.42 should have the correct address\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "ip address show dev eth0.42", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "inet #{V42_4_SUT}"
  out.should include "inet6 #{V42_6_SUT}"
end

Then /^I should be able to ping eth0\.42 on the other side$/ do
  SUT.test_and_drop_results "log.sh step \"Then I should be able to ping eth0.42 on the other side\""
  local, remote, command = SUT.test_and_drop_results \
    "ping -q -c1 -W1 #{V42_4_REF}", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = SUT.test_and_drop_results \
    "ping6 -q -c1 -W1 #{V42_6_REF}", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
end

Then /^br0 should have the correct address$/ do
  SUT.test_and_drop_results "log.sh step \"Then br0 should have the correct address\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "ip address show dev br0", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "inet #{VLAN4_SUT0}"
  out.should include "inet6 #{VLAN6_SUT0}"
end

Then /^br2 should have the correct address$/ do
  SUT.test_and_drop_results "log.sh step \"Then br2 should have the correct address\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "ip address show dev br2", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "inet #{STAT4_SUT0}"
  out.should include "inet6 #{STAT6_SUT0}"
end

Then /^I should be able to ping br2 on the other side$/ do
  SUT.test_and_drop_results "log.sh step \"Then I should be able to ping br2 on the other side\""
  local, remote, command = SUT.test_and_drop_results \
    "ping -q -c1 -W1 #{STAT4_REF0}", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = SUT.test_and_drop_results \
    "ping6 -q -c1 -W1 #{STAT6_REF0}", "testuser"
end

Then /^I should be able to ping eth1 on the other side$/ do
  SUT.test_and_drop_results "log.sh step \"Then I should be able to ping eth1 on the other side\""
  local, remote, command = SUT.test_and_drop_results \
    "ping -q -c1 -W1 #{STAT4_REF1}", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = SUT.test_and_drop_results \
    "ping6 -q -c1 -W1 #{STAT6_REF1}", "testuser"
end

Then /^I should be able to ping eth1\.1 on the other side$/ do
  SUT.test_and_drop_results "log.sh step \"Then I should be able to ping eth1.1 on the other side\""
  local, remote, command = SUT.test_and_drop_results \
    "ping -q -c1 -W1 #{VLAN4_REF1}", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = SUT.test_and_drop_results \
    "ping6 -q -c1 -W1 #{VLAN6_REF1}", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
end

Then /^bond1 should have the correct address$/ do
  SUT.test_and_drop_results "log.sh step \"Then bond1 should have the correct address\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "ip address show dev bond1", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "inet #{BOND4_SUT}"
  out.should include "inet6 #{BOND6_SUT}"
end

Then /^I should be able to ping bond(\d) on the other side$/ do |x|
  SUT.test_and_drop_results "log.sh step \"Then I should be able to ping bond#{x} on the other side\""
  # Almost the same as "I should be able to ping the other side of the aggregated link"
  # Only the log message changes
  local, remote, command = SUT.test_and_drop_results \
    "ping -q -c1 -W1 #{BOND4_REF}", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = SUT.test_and_drop_results \
    "ping6 -q -c1 -W1 #{BOND6_REF}", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
end

Then /^br1 should have the correct address$/ do
  SUT.test_and_drop_results "log.sh step \"Then br1 should have the correct address\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "ip address show dev br1", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "inet #{BOND4_SUT}"
  out.should include "inet6 #{BOND6_SUT}"
end

Then /^br1.42 should have the correct address$/ do
  SUT.test_and_drop_results "log.sh step \"Then br1.42 should have the correct address\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "ip address show dev br1.42", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "inet #{V42_4_SUT}"
  out.should include "inet6 #{V42_6_SUT}"
end

Then /^I should be able to ping bond0.42 on the other side$/ do
  SUT.test_and_drop_results "log.sh step \"Then I should be able to ping bond0.42 on the other side\""
  # Almost the same as "I should be able to ping the other side of the VLAN"
  # Only the log message changes
  local, remote, command = SUT.test_and_drop_results \
    "ping -q -c1 -W1 #{V42_4_REF}", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = SUT.test_and_drop_results \
    "ping6 -q -c1 -W1 #{V42_6_REF}", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
end

Then /^I should be able to ping bond0.73 on the other side$/ do
  SUT.test_and_drop_results "log.sh step \"Then I should be able to ping bond0.73 on the other side\""
  local, remote, command = SUT.test_and_drop_results \
    "ping -q -c1 -W1 #{V73_4_REF}", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = SUT.test_and_drop_results \
    "ping6 -q -c1 -W1 #{V73_6_REF}", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
end

Then /^bond0.42 should have the correct address$/ do
  SUT.test_and_drop_results "log.sh step \"Then bond0.42 should have the correct address\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "ip address show dev bond0.42", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "inet #{V42_4_SUT}"
  out.should include "inet6 #{V42_6_SUT}"
end

Then /^bond0.73 should have the correct address$/ do
  SUT.test_and_drop_results "log.sh step \"Then bond0.73 should have the correct address\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "ip address show dev bond0.73", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "inet #{V73_4_SUT}"
  out.should include "inet6 #{V73_6_SUT}"
end

Then /^br42 should have the correct address$/ do
  SUT.test_and_drop_results "log.sh step \"Then br42 should have the correct address\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "ip address show dev br42", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "inet #{V42_4_SUT}"
  out.should include "inet6 #{V42_6_SUT}"
end

Then /^br73 should have the correct address$/ do
  SUT.test_and_drop_results "log.sh step \"Then br73 should have the correct address\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "ip address show dev br73", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "inet #{V73_4_SUT}"
  out.should include "inet6 #{V73_6_SUT}"
end

Then /^ovsbr1 should have the correct address$/ do
  SUT.test_and_drop_results "log.sh step \"Then ovsbr1 should have the correct address\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "ip address show dev ovsbr1", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "inet #{VLAN4_SUT0}"
  out.should include "inet6 #{VLAN6_SUT0}"
end

Then /^I should have the statically declared DNS server$/ do
  SUT.test_and_drop_results "log.sh step \"Then I should have the statically declared DNS server\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "cat /etc/resolv.conf", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "nameserver #{STAT4_GAT}"
end

Then /^I should obtain a DNS server by DHCPv4$/ do
  SUT.test_and_drop_results "log.sh step \"Then I should obtain a DNS server by DHCPv4\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "cat /etc/resolv.conf", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "nameserver #{DHCP4_REF0}"
end

Then /^I should not obtain a DNS server by DHCPv4$/ do
  SUT.test_and_drop_results "log.sh step \"Then I should not obtain a DNS server by DHCPv4\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "cat /etc/resolv.conf", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should_not include "nameserver #{DHCP4_REF0}"
end

Then /^the capture file should contain a DHCP release$/ do
  SUT.test_and_drop_results "log.sh step \"Then the capture file should contain a DHCP release\""
  #
  sleep 2 # let time for DHCP release to arrive
  #
  local, remote, command = REF.test_and_drop_results \
    "tcpdump.sh stop"
  local.should == 0; remote.should == 0; command.should == 0
  out, local, remote, command = REF.test_and_store_results_together \
    "tcpdump.sh read -r /tmp/tcpdump -v"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "DHCP-Message Option 53, length 1: Release"
end

Then /^the capture file should not contain a DHCP release$/ do
  SUT.test_and_drop_results "log.sh step \"Then the capture file should contain a DHCP release\""
  local, remote, command = REF.test_and_drop_results \
    "tcpdump.sh stop"
  local.should == 0; remote.should == 0; command.should == 0
  out, local, remote, command = REF.test_and_store_results_together \
    "tcpdump.sh read -r /tmp/tcpdump -v"
  local.should == 0; remote.should == 0; command.should == 0
  out.should_not include "DHCP-Message Option 53, length 1: Release"
end

Then /^the speed of eth0 should be (\d*) Mbit\/s$/ do |speed|
  if @skip_when_virtual_machine
    puts "(skipped)"
    sleep 1
    next
  end
  SUT.test_and_drop_results "log.sh step \"Then the speed of eth0 should be #{speed} Mbit/s\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "ethtool eth0", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "Speed: #{speed}Mb/s"
end

Then /^I should obtain a link-local IPv4 address$/ do
  SUT.test_and_drop_results "log.sh step \"Then I should obtain a link-local IPv4 address\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "ip address show dev eth0", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "inet 169.254."
end

Then /^I should not obtain a link-local IPv4 address$/ do
  SUT.test_and_drop_results "log.sh step \"Then I should not obtain a link-local IPv4 address\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "ip address show dev eth0", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should_not include "inet 169.254."
end

Then /^I should obtain an autonomous IPv6 address$/ do
  SUT.test_and_drop_results "log.sh step \"Then I should obtain an autonomous IPv6 address\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "ip -6 address show dev eth0", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "inet6 #{RADVD_SUT0}"
end

Then /^I should not obtain an autonomous IPv6 address$/ do
  SUT.test_and_drop_results "log.sh step \"Then I should not obtain an autonomous IPv6 address\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "ip -6 address show dev eth0", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should_not include "inet6 #{RADVD_SUT0}"
end

Then /^I should obtain an address by DHCPv4$/ do
  SUT.test_and_drop_results "log.sh step \"Then I should obtain an address by DHCPv4\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "ip address show dev eth0", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "inet #{DHCP4_SUT0}"
end

Then /^I should not obtain an address by DHCPv4$/ do
  SUT.test_and_drop_results "log.sh step \"Then I should not obtain an address by DHCPv4\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "ip address show dev eth0", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should_not include "inet #{DHCP4_SUT0}"
end

Then /^I should obtain an address by DHCPv6$/ do
  SUT.test_and_drop_results "log.sh step \"Then I should obtain an address by DHCPv6\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "ip -6 address show dev eth0", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "inet6 #{DHCP6_SUT0}"
end

Then /^I should not obtain an address by DHCPv6$/ do
  SUT.test_and_drop_results "log.sh step \"Then I should not obtain an address by DHCPv6\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "ip -6 address show dev eth0", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should_not include "inet6 #{DHCP6_SUT0}"
end

Then /^no address should be tentative$/ do
  SUT.test_and_drop_results "log.sh step \"Then no address should be tentative\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "ip -6 address show dev eth0", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should_not include "tentative"
end

Then /^I should obtain a default IPv6 route$/ do
  SUT.test_and_drop_results "log.sh step \"Then I should obtain a default IPv6 route\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "ip -6 route show dev eth0", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should match "^#{RADVD_SUT0}"
end

Then /^I should not obtain a default IPv6 route$/ do
  SUT.test_and_drop_results "log.sh step \"Then I should not obtain a default IPv6 route\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "ip -6 route show dev eth0", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should_not match "^#{RADVD_SUT0}"
end

Then /^I should obtain a DNS server by RDNSS$/ do
  SUT.test_and_drop_results "log.sh step \"Then I should obtain a DNS server by RDNSS\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "cat /etc/resolv.conf", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "nameserver #{STAT6_OUT}"
end

Then /^I should not obtain a DNS server by RDNSS$/ do
  SUT.test_and_drop_results "log.sh step \"Then I should not obtain a DNS server by RDNSS\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "cat /etc/resolv.conf", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should_not include "nameserver #{STAT6_OUT}"
end

Then /^I should obtain a DNS server by DHCPv6$/ do
  SUT.test_and_drop_results "log.sh step \"Then I should obtain a DNS server by DHCPv6\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "cat /etc/resolv.conf", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "nameserver #{DHCP6_REF0}"
end

Then /^I should not obtain a DNS server by DHCPv6$/ do
  SUT.test_and_drop_results "log.sh step \"Then I should not obtain a DNS server by DHCPv6\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "cat /etc/resolv.conf", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  out.should_not include "nameserver #{DHCP6_REF0}"
end

Then /^the setup should be finished$/ do
  SUT.test_and_drop_results "log.sh step \"Then the setup should be finished\""
  @setup_in_progress.should be false
end

Then /^the setup should still be in progress$/ do
  SUT.test_and_drop_results "log.sh step \"Then the setup should still be in progress\""
  @setup_in_progress.should be true
end

Then /^([^ ]*) should be the active link$/ do |interface|
  SUT.test_and_drop_results "log.sh step \"Then #{interface} should be the active link\""

  # Then check for active port
  out, local, remote, command = SUT.test_and_store_results_together \
    "teamdctl team0 state view"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "active port: #{interface}"
end
