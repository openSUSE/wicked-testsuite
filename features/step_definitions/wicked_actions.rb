# # # Actions # # #

When /^I stop the wicked client service$/ do
  SUT.test_and_drop_results "log.sh step \"When I stop the wicked client service\""
  local, remote, command = SUT.test_and_drop_results \
    "systemctl stop wicked.service"
  local.should == 0; remote.should == 0; command.should == 0
end

When /^I start the wicked client service$/ do
  SUT.test_and_drop_results "log.sh step \"When I start the wicked client service\""
  local, remote, command = SUT.test_and_drop_results \
    "systemctl start wicked.service"
  local.should == 0; remote.should == 0; command.should == 0
end

When /^I stop the wicked server service$/ do
  SUT.test_and_drop_results "log.sh step \"When I stop the wicked server service\""
  local, remote, command = SUT.test_and_drop_results \
    "systemctl stop wickedd.service"
  local.should == 0; remote.should == 0; command.should == 0
end

When /^I start the wicked server service$/ do
  SUT.test_and_drop_results "log.sh step \"When I start the wicked server service\""
  local, remote, command = SUT.test_and_drop_results \
    "systemctl start wickedd.service"
  local.should == 0; remote.should == 0; command.should == 0
end

When /^I ask to see all network interfaces$/ do
  SUT.test_and_drop_results "log.sh step \"When I ask to see all network interfaces\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "wic.sh show all", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  @showall = out
  nil
end

When /^I bring up ([^ ]*)$/ do |interface|
  if @skip_when_no_hotplug
    puts "(skipped)"
    sleep 1
    next
  end
  SUT.test_and_drop_results "log.sh step \"When I bring up #{interface}\""
  local, remote, command = SUT.test_and_drop_results \
    "wic.sh ifup #{interface}"
  local.should == 0; remote.should == 0; command.should == 0
end

When /^I bring up ([^ ]*) from legacy file$/ do |interface|
  SUT.test_and_drop_results "log.sh step \"When I bring up #{interface} from legacy file\""
  local, remote, command = SUT.test_and_drop_results \
    "wic.sh ifup --ifconfig compat:/tmp/tests #{interface}"
  local.should == 0; remote.should == 0; command.should == 0
end

When /^I bring up ([^ ]*) from XML file$/ do |interface|
  SUT.test_and_drop_results "log.sh step \"When I bring up #{interface} from XML file\""
  local, remote, command = SUT.test_and_drop_results \
    "wic.sh ifup --ifconfig /tmp/tests/#{interface}.xml #{interface}"
  local.should == 0; remote.should == 0; command.should == 0
end

When /^I bring down ([^ ]*)$/ do |interface|
  SUT.test_and_drop_results "log.sh step \"When I bring down #{interface}\""
  local, remote, command = SUT.test_and_drop_results \
    "wic.sh ifdown #{interface}"
  local.should == 0; remote.should == 0; command.should == 0
end

When /^I show a brief status of ([^ ]*)$/ do |interface|
  SUT.test_and_drop_results "log.sh step \"When I show a brief status of #{interface}\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "wic.sh ifstatus --brief #{interface}"
  local.should == 0; remote.should == 0; command.should == 0
  @briefstatus = out
end

When /^I set up static IP addresses for ([^ ]*) from legacy files$/ do |interface|
  SUT.test_and_drop_results "log.sh step \"When I set up static IP addresses for #{interface} from legacy files\""
  local, remote = SUT.inject_file \
    "test-files/static-addresses/ifcfg-#{interface}", "/tmp/tests/ifcfg-#{interface}", \
    "testuser", false
  local.should == 0; remote.should == 0
  #
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests #{interface}"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I set up static IP addresses for ([^ ]*) from XML files$/ do |interface|
  SUT.test_and_drop_results "log.sh step \"When I set up static IP addresses for #{interface} from XML files\""
  local, remote = SUT.inject_file \
    "test-files/static-addresses/static-addresses.xml", "/tmp/tests/#{interface}.xml", \
    "testuser", false
  local.should == 0; remote.should == 0
  #
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/#{interface}.xml #{interface}"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/#{interface}.xml all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I ask the reference machine to advertise a default route$/ do
  SUT.test_and_drop_results "log.sh step \"When I ask the reference machine to advertise a default route\""
  local, remote, command = REF.test_and_drop_results \
    "ln -sf /etc/dhcpd-route.conf /etc/dhcpd.conf"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote, command = REF.test_and_drop_results \
    "systemctl restart dhcpd"
  local.should == 0; remote.should == 0; command.should == 0
end

When /^I set up dynamic IP addresses for ([^ ]*) from legacy files$/ do |interface|
  SUT.test_and_drop_results "log.sh step \"When I set up dynamic IP addresses for #{interface} from legacy files\""
  local, remote = SUT.inject_file \
    "test-files/dynamic-addresses/ifcfg-#{interface}", "/tmp/tests/ifcfg-#{interface}", \
    "testuser", false
  local.should == 0; remote.should == 0
  #
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests #{interface}"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I set up dynamic IP addresses for ([^ ]*) from XML files$/ do |interface|
  SUT.test_and_drop_results "log.sh step \"When I set up dynamic IP addresses for #{interface} from XML files\""
  local, remote = SUT.inject_file \
    "test-files/dynamic-addresses/dynamic-addresses.xml", "/tmp/tests/#{interface}.xml", \
    "testuser", false
  local.should == 0; remote.should == 0
  #
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/#{interface}.xml #{interface}"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/#{interface}.xml all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I deconnect violently ([^ ]*)$/ do |interface|
  if @skip_when_no_hotplug
    puts "(skipped)"
    sleep 1
    next
  end
  SUT.test_and_drop_results "log.sh step \"When I deconnect violently #{interface}\""
  local, remote, command = SUT.test_and_drop_results \
    "ifbind.sh unbind #{interface}"
  local.should == 0; remote.should == 0; command.should == 0
end

When /^I reconnect ([^ ]*)$/ do |interface|
  if @skip_when_no_hotplug
    puts "(skipped)"
    sleep 1
    next
  end
  SUT.test_and_drop_results "log.sh step \"When I reconnect #{interface}\""
  local, remote, command = SUT.test_and_drop_results \
    "ifbind.sh bind #{interface}"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = SUT.test_and_drop_results \
    "wait_for_cmd_success.sh \"ip address show dev #{interface} | grep 'state UP'\""
  local.should == 0; remote.should == 0; command.should == 0
end

When /^I set up static addresses and routes for ([^ ]*) from legacy files$/ do |interface|
  SUT.test_and_drop_results "log.sh step \"When I set up static routes for #{interface} from legacy files\""
  local, remote = SUT.inject_file \
    "test-files/static-addresses-and-routes/ifcfg-#{interface}", "/tmp/tests/ifcfg-#{interface}", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/static-addresses-and-routes/ifroute-#{interface}", "/tmp/tests/ifroute-#{interface}", \
    "testuser", false
  local.should == 0; remote.should == 0
  #
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests #{interface}"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I set up static addresses and routes for ([^ ]*) from XML files$/ do |interface|
  SUT.test_and_drop_results "log.sh step \"When I set up static routes for #{interface} from XML files\""
  local, remote = SUT.inject_file \
    "test-files/static-addresses-and-routes/static-addresses-and-routes.xml", "/tmp/tests/#{interface}.xml", \
    "testuser", false
  local.should == 0; remote.should == 0
  #
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/#{interface}.xml #{interface}"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/#{interface}.xml all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I bring down all cards at once$/ do
  SUT.test_and_drop_results "log.sh step \"When I bring down all cards at once\""
  local, remote, command = SUT.test_and_drop_results \
    "wic.sh ifdown all"
  local.should == 0; remote.should == 0; command.should == 0
end

When /^I aggregate eth0 and eth1 from legacy files$/ do
  if @skip_when_no_hotplug
    puts "(skipped)"
    sleep 1
    next
  end
  SUT.test_and_drop_results "log.sh step \"When I aggregate eth0 and eth1 from legacy files\""
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-bond0-rr /etc/sysconfig/network/ifcfg-bond0"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup bond0"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote = SUT.inject_file \
    "test-files/bonding/ifcfg-bond0", "/tmp/tests/ifcfg-bond0", \
    "testuser", false
  local.should == 0; remote.should == 0
  if (CONFIGURE_LOWERDEVS)
    local, remote = SUT.inject_file \
      "test-files/bonding/ifcfg-eth0", "/tmp/tests/ifcfg-eth0", \
      "testuser", false
    local.should == 0; remote.should == 0
    local, remote = SUT.inject_file \
      "test-files/bonding/ifcfg-eth1", "/tmp/tests/ifcfg-eth1", \
      "testuser", false
    local.should == 0; remote.should == 0
  end
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests bond0"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I aggregate eth0 and eth1 from XML files$/ do
  SUT.test_and_drop_results "log.sh step \"When I aggregate eth0 and eth1 from XML files\""
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-bond0-rr /etc/sysconfig/network/ifcfg-bond0"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup bond0"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote = SUT.inject_file \
    "test-files/bonding/bonding.xml", "/tmp/tests/bonding.xml", \
    "testuser", false
  local.should == 0; remote.should == 0
  #
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/bonding.xml bond0"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/bonding.xml all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I create a VLAN on interface ([^ ]*) from legacy files$/ do |interface|
  SUT.test_and_drop_results "log.sh step \"When I create a VLAN on interface #{interface} from legacy files\""
  vlan = interface + ".42"
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-#{vlan} /etc/sysconfig/network/"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup #{vlan}"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote = SUT.inject_file \
    "test-files/vlan/ifcfg-#{vlan}", "/tmp/tests/ifcfg-#{vlan}", \
    "testuser", false
  local.should == 0; remote.should == 0
  if (CONFIGURE_LOWERDEVS)
    local, remote = SUT.inject_file \
      "test-files/vlan/ifcfg-#{interface}", "/tmp/tests/ifcfg-#{interface}", \
      "testuser", false
    local.should == 0; remote.should == 0
  end
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests #{vlan}"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I create a VLAN on interface ([^ ]*) from XML files$/ do |interface|
  SUT.test_and_drop_results "log.sh step \"When I create a VLAN on interface #{interface} from XML files\""
  vlan = interface + ".42"
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-#{vlan} /etc/sysconfig/network/"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup #{vlan}"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote = SUT.inject_file \
    "test-files/vlan/vlan-#{interface}.xml", "/tmp/tests/vlan-#{interface}.xml", \
    "testuser", false
  local.should == 0; remote.should == 0
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/vlan-#{interface}.xml #{vlan}"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/vlan-#{interface}.xml all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I create a bridge on interface eth1 from legacy files$/ do
  SUT.test_and_drop_results "log.sh step \"When I create a bridge on interface eth1 from legacy files\""
  local, remote = SUT.inject_file \
    "test-files/bridge/ifcfg-br1", "/tmp/tests/ifcfg-br1", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/bridge/ifcfg-dummy1", "/tmp/tests/ifcfg-dummy1", \
    "testuser", false
  local.should == 0; remote.should == 0
  if (CONFIGURE_LOWERDEVS)
    local, remote = SUT.inject_file \
      "test-files/bridge/ifcfg-eth1", "/tmp/tests/ifcfg-eth1", \
      "testuser", false
    local.should == 0; remote.should == 0
  end
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests br1"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I create a bridge on interface eth1 from XML files$/ do
  SUT.test_and_drop_results "log.sh step \"When I create a bridge on interface eth1 from XML files\""
  local, remote = SUT.inject_file \
    "test-files/bridge/bridge.xml", "/tmp/tests/bridge.xml", \
    "testuser", false
  local.should == 0; remote.should == 0
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/bridge.xml br1"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/bridge.xml all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I create a macvtap interface from legacy files$/ do
  SUT.test_and_drop_results "log.sh step \"When I create a macvtap interface from legacy files\""
  local, remote = SUT.inject_file \
    "test-files/macvtap/ifcfg-macvtap1", "/tmp/tests/ifcfg-macvtap1", \
    "testuser", false
  local.should == 0; remote.should == 0
  if (CONFIGURE_LOWERDEVS)
    local, remote = SUT.inject_file \
      "test-files/macvtap/ifcfg-eth1", "/tmp/tests/ifcfg-eth1", \
      "testuser", false
    local.should == 0; remote.should == 0
  end
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests macvtap1"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I create a macvtap interface from XML files$/ do
  SUT.test_and_drop_results "log.sh step \"When I create a macvtap interface from XML files\""
  local, remote = SUT.inject_file \
    "test-files/macvtap/macvtap.xml", "/tmp/tests/macvtap.xml", \
    "testuser", false
  local.should == 0; remote.should == 0
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/macvtap.xml macvtap1"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/macvtap.xml all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I send an ARP ping to the reference machine$/ do
  SUT.test_and_drop_results "log.sh step \"When I send an ARP ping to the reference machine\""
  out, local, remote, command = SUT.test_and_store_results_together \
    "check_macvtap > /tmp/tests/macvtap_results.txt 2>&1 &"
  local.should == 0; remote.should == 0; command.should == 0
  #
  out, local, remote, command = SUT.test_and_store_results_together \
    "arping -c 1 -I macvtap1 172.16.0.1"
  local.should == 0; remote.should == 0
  #
  out, local, remote, command = SUT.test_and_store_results_together \
    "killall check_macvtap"
  local.should == 0; remote.should == 0
end

When /^I create an OVS bridge from legacy files$/ do
  SUT.test_and_drop_results "log.sh step \"When I create an OVS bridge from legacy files\""
  local, remote = SUT.inject_file \
    "test-files/ovs-bridge/ifcfg-ovsbr1", "/tmp/tests/ifcfg-ovsbr1", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/ovs-bridge/ifcfg-dummy1", "/tmp/tests/ifcfg-dummy1", \
    "testuser", false
  local.should == 0; remote.should == 0
  if (CONFIGURE_LOWERDEVS)
    local, remote = SUT.inject_file \
      "test-files/ovs-bridge/ifcfg-eth1", "/tmp/tests/ifcfg-eth1", \
      "testuser", false
    local.should == 0; remote.should == 0
  end
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests ovsbr1"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I create an OVS bridge from XML files$/ do
  SUT.test_and_drop_results "log.sh step \"When I create an OVS bridge from XML files\""
  local, remote = SUT.inject_file \
    "test-files/ovs-bridge/ovs-bridge.xml", "/tmp/tests/ovs-bridge.xml", \
    "testuser", false
  local.should == 0; remote.should == 0
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/ovs-bridge.xml ovsbr1"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/ovs-bridge.xml all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I team together eth0 and eth1 from legacy files$/ do
  SUT.test_and_drop_results "log.sh step \"When I team together eth0 and eth1 from legacy files\""
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-bond0-ab /etc/sysconfig/network/ifcfg-bond0"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup bond0"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote = SUT.inject_file \
    "test-files/teaming/ifcfg-team0", "/tmp/tests/ifcfg-team0", \
    "testuser", false
  local.should == 0; remote.should == 0
  if (CONFIGURE_LOWERDEVS)
    local, remote = SUT.inject_file \
      "test-files/teaming/ifcfg-eth0", "/tmp/tests/ifcfg-eth0", \
      "testuser", false
    local.should == 0; remote.should == 0
    local, remote = SUT.inject_file \
      "test-files/teaming/ifcfg-eth1", "/tmp/tests/ifcfg-eth1", \
      "testuser", false
    local.should == 0; remote.should == 0
  end
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests team0"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I team together eth0 and eth1 from XML files$/ do
  SUT.test_and_drop_results "log.sh step \"When I team together eth0 and eth1 from XML files\""
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-bond0-ab /etc/sysconfig/network/ifcfg-bond0"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup bond0"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote = SUT.inject_file \
    "test-files/teaming/teaming.xml", "/tmp/tests/teaming.xml", \
    "testuser", false
  local.should == 0; remote.should == 0
  #
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/teaming.xml team0"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/teaming.xml all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I create a tun interface from legacy files$/ do
  SUT.test_and_drop_results "log.sh step \"When I create a tun interface from legacy files\""
  local, remote, command = REF.test_and_drop_results \
    "ln -sf /etc/openvpn/server-tun.conf /etc/openvpn/server.conf"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "systemctl start openvpn@server"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-tun1 /etc/sysconfig/network/"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup tun1"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote = SUT.inject_file \
    "test-files/tun/openvpn.conf", "/etc/openvpn/client.conf", \
    "root", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/tun/ifcfg-tun1", "/tmp/tests/ifcfg-tun1", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/tun/ifcfg-eth1", "/tmp/tests/ifcfg-eth1", \
    "testuser", false
  local.should == 0; remote.should == 0
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests tun1"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I create a tun interface from XML files$/ do
  SUT.test_and_drop_results "log.sh step \"When I create a tun interface from XML files\""
  local, remote, command = REF.test_and_drop_results \
    "ln -sf /etc/openvpn/server-tun.conf /etc/openvpn/server.conf"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "systemctl start openvpn@server"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-tun1 /etc/sysconfig/network/"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup tun1"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote = SUT.inject_file \
    "test-files/tun/openvpn.conf", "/etc/openvpn/client.conf", \
    "root", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/tun/tun.xml", "/tmp/tests/tun.xml", \
    "testuser", false
  local.should == 0; remote.should == 0
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/tun.xml tun1"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/tun.xml all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I create a tap interface from legacy files$/ do
  SUT.test_and_drop_results "log.sh step \"When I create a tap interface from legacy files\""
  local, remote, command = REF.test_and_drop_results \
    "ln -sf /etc/openvpn/server-tap.conf /etc/openvpn/server.conf"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "systemctl start openvpn@server"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-tap1 /etc/sysconfig/network/"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup tap1"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote = SUT.inject_file \
    "test-files/tap/openvpn.conf", "/etc/openvpn/client.conf", \
    "root", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/tap/ifcfg-tap1", "/tmp/tests/ifcfg-tap1", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/tap/ifcfg-eth1", "/tmp/tests/ifcfg-eth1", \
    "testuser", false
  local.should == 0; remote.should == 0
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests tap1"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I create a tap interface from XML files$/ do
  SUT.test_and_drop_results "log.sh step \"When I create a tap interface from XML files\""
  local, remote, command = REF.test_and_drop_results \
    "ln -sf /etc/openvpn/server-tap.conf /etc/openvpn/server.conf"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "systemctl start openvpn@server"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-tap1 /etc/sysconfig/network/"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup tap1"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote = SUT.inject_file \
    "test-files/tap/openvpn.conf", "/etc/openvpn/client.conf", \
    "root", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/tap/tap.xml", "/tmp/tests/tap.xml", \
    "testuser", false
  local.should == 0; remote.should == 0
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/tap.xml tap1"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/tap.xml all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I create a gre interface from legacy files$/ do
  SUT.test_and_drop_results "log.sh step \"When I create a gre interface from legacy files\""
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-gre1 /etc/sysconfig/network/"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup gre1"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote = SUT.inject_file \
    "test-files/gre/ifcfg-gre1", "/tmp/tests/ifcfg-gre1", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/gre/ifcfg-eth1", "/tmp/tests/ifcfg-eth1", \
    "testuser", false
  local.should == 0; remote.should == 0
  if (CONFIGURE_PRECISELY)
    # this should not be needed: dependencies should be handled
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests eth1"
    local.should == 0; remote.should == 0; command.should == 0
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests gre1"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I create a gre interface from XML files$/ do
  SUT.test_and_drop_results "log.sh step \"When I create a gre interface from XML files\""
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-gre1 /etc/sysconfig/network/"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup gre1"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote = SUT.inject_file \
    "test-files/gre/gre.xml", "/tmp/tests/gre.xml", \
    "testuser", false
  local.should == 0; remote.should == 0
  if (CONFIGURE_PRECISELY)
    # this should not be needed: dependencies should be handled
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/gre.xml eth1"
    local.should == 0; remote.should == 0; command.should == 0
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/gre.xml gre1"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/gre.xml all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I establish routes for the GRE tunnel$/ do
  SUT.test_and_drop_results "log.sh step \"When I establish routes for the GRE tunnel\""
  local, remote, command = REF.test_and_drop_results \
    "ip -4 route add #{GRE_4_SUT1} dev gre1"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ip -6 route add #{GRE_6_SUT1} dev gre1"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote, command = SUT.test_and_drop_results \
    "ip -4 route add #{GRE_4_REF1}/32 dev gre1"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = SUT.test_and_drop_results \
    "ip -6 route add #{GRE_6_REF1}/128 dev gre1"
  local.should == 0; remote.should == 0; command.should == 0
end

When /^I create a tunl interface from legacy files$/ do
  SUT.test_and_drop_results "log.sh step \"When I create a tunl interface from legacy files\""
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-tunl1 /etc/sysconfig/network/"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup tunl1"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote = SUT.inject_file \
    "test-files/ipip/ifcfg-tunl1", "/tmp/tests/ifcfg-tunl1", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/ipip/ifcfg-eth1", "/tmp/tests/ifcfg-eth1", \
    "testuser", false
  local.should == 0; remote.should == 0
  if (CONFIGURE_PRECISELY)
    # this should not be needed: dependencies should be handled
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests eth1"
    local.should == 0; remote.should == 0; command.should == 0
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests tunl1"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I create a tunl interface from XML files$/ do
  SUT.test_and_drop_results "log.sh step \"When I create a tunl interface from XML files\""
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-tunl1 /etc/sysconfig/network/"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup tunl1"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote = SUT.inject_file \
    "test-files/ipip/ipip.xml", "/tmp/tests/ipip.xml", \
    "testuser", false
  local.should == 0; remote.should == 0
  if (CONFIGURE_PRECISELY)
    # this should not be needed: dependencies should be handled
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/ipip.xml eth1"
    local.should == 0; remote.should == 0; command.should == 0
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/ipip.xml tunl1"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/ipip.xml all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I establish routes for the IPIP tunnel$/ do
  SUT.test_and_drop_results "log.sh step \"When I establish routes for the IPIP tunnel\""
  local, remote, command = REF.test_and_drop_results \
    "ip -4 route add #{IPIP4_SUT1} dev tunl1"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote, command = SUT.test_and_drop_results \
    "ip -4 route add #{IPIP4_REF1}/32 dev tunl1"
  local.should == 0; remote.should == 0; command.should == 0
end

When /^I create a sit interface from legacy files$/ do
  SUT.test_and_drop_results "log.sh step \"When I create a sit interface from legacy files\""
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-sit1 /etc/sysconfig/network/"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup sit1"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote = SUT.inject_file \
    "test-files/sit/ifcfg-sit1", "/tmp/tests/ifcfg-sit1", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/sit/ifcfg-eth1", "/tmp/tests/ifcfg-eth1", \
    "testuser", false
  local.should == 0; remote.should == 0
  if (CONFIGURE_PRECISELY)
    # this should not be needed: dependencies should be handled
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests eth1"
    local.should == 0; remote.should == 0; command.should == 0
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests sit1"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I create a sit interface from XML files$/ do
  SUT.test_and_drop_results "log.sh step \"When I create a sit interface from XML files\""
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-sit1 /etc/sysconfig/network/"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup sit1"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote = SUT.inject_file \
    "test-files/sit/sit.xml", "/tmp/tests/sit.xml", \
    "testuser", false
  local.should == 0; remote.should == 0
  if (CONFIGURE_PRECISELY)
    # this should not be needed: dependencies should be handled
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/sit.xml eth1"
    local.should == 0; remote.should == 0; command.should == 0
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/sit.xml sit1"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/sit.xml all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I establish routes for the SIT tunnel$/ do
  SUT.test_and_drop_results "log.sh step \"When I establish routes for the SIT tunnel\""
  local, remote, command = REF.test_and_drop_results \
    "ip -6 route add #{SIT_6_SUT1} dev sit1"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote, command = SUT.test_and_drop_results \
    "ip -6 route add #{SIT_6_REF1}/128 dev sit1"
  local.should == 0; remote.should == 0; command.should == 0
end

When /^the reference machine is set up in infiniband ([^ ]*) mode$/ do |mode|
  if @skip_when_no_infiniband
    puts "(skipped)"
    sleep 1
    next
  end
  SUT.test_and_drop_results "log.sh step \"When the reference machine is set up in infiniband #{mode} mode\""
  local, remote, command = REF.test_and_drop_results \
    "ln -sf pool/ifcfg-ib0-#{mode} /etc/sysconfig/network/ifcfg-ib0"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup ib0"
  local.should == 0; remote.should == 0; command.should == 0
end

When /^the reference machine has an infiniband child channel$/ do
  if @skip_when_no_infiniband
    puts "(skipped)"
    sleep 1
    next
  end
  SUT.test_and_drop_results "log.sh step \"When the reference machine has an infiniband child channel\""
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-ib0.8001 /etc/sysconfig/network/"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup ib0.8001"
  local.should == 0; remote.should == 0; command.should == 0
end

When /^the reference machine provides dynamic addresses over the infiniband links$/ do
  if @skip_when_no_infiniband
    puts "(skipped)"
    sleep 1
    next
  end
  SUT.test_and_drop_results "log.sh step \"When the reference machine provides dynamic addresses over the infiniband links\""
  local, remote, command = REF.test_and_drop_results \
    "ln -sf /etc/radvd-infiniband.conf /etc/radvd.conf"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "systemctl restart radvd"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote, command = REF.test_and_drop_results \
    "ln -sf /etc/dhcpd-infiniband.conf /etc/dhcpd.conf"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "systemctl restart dhcpd"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote, command = REF.test_and_drop_results \
    "ln -sf /etc/dhcpd6-infiniband.conf /etc/dhcpd6.conf"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "systemctl restart dhcpd6"
  local.should == 0; remote.should == 0; command.should == 0
end

When /^I create an infiniband interface in ([^ ]*) mode from legacy files$/ do |mode|
  if @skip_when_no_infiniband
    puts "(skipped)"
    sleep 1
    next
  end
  SUT.test_and_drop_results "log.sh step \"When I create an infiniband interface in #{mode} mode from legacy files\""
  local, remote = SUT.inject_file \
    "test-files/infiniband/ifcfg-ib0-#{mode}", "/tmp/tests/ifcfg-ib0", \
    "testuser", false
  local.should == 0; remote.should == 0
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests ib0"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I create an infiniband interface in ([^ ]*) mode from XML files$/ do |mode|
  if @skip_when_no_infiniband
    puts "(skipped)"
    sleep 1
    next
  end
  SUT.test_and_drop_results "log.sh step \"When I create an infiniband interface in #{mode} mode from XML files\""
  local, remote = SUT.inject_file \
    "test-files/infiniband/infiniband-#{mode}.xml", "/tmp/tests/infiniband.xml", \
    "testuser", false
  local.should == 0; remote.should == 0
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/infiniband.xml ib0"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/infiniband.xml all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I create an infiniband child interface from legacy files$/ do
  if @skip_when_no_infiniband
    puts "(skipped)"
    sleep 1
    next
  end
  SUT.test_and_drop_results "log.sh step \"When I create an infiniband child interface from legacy files\""
  local, remote = SUT.inject_file \
    "test-files/infiniband/ifcfg-ib0.8001", "/tmp/tests/ifcfg-ib0.8001", \
    "testuser", false
  local.should == 0; remote.should == 0
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests ib0.8001"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I create an infiniband child interface from XML files$/ do
  if @skip_when_no_infiniband
    puts "(skipped)"
    sleep 1
    next
  end
  SUT.test_and_drop_results "log.sh step \"When I create an infiniband child interface from XML files\""
  local, remote = SUT.inject_file \
    "test-files/infiniband/infiniband-child.xml", "/tmp/tests/infiniband-child.xml", \
    "testuser", false
  local.should == 0; remote.should == 0
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/infiniband-child.xml ib0.8001"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/infiniband-child.xml all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I create br0\.1\(br0\(eth0, dummy0\), 1\) from legacy files$/ do
  SUT.test_and_drop_results "log.sh step \"When I create br0.1(br0(eth0, dummy0), 1) from legacy files\""
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-eth0.1 /etc/sysconfig/network/"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup eth0.1"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote = SUT.inject_file \
    "test-files/mix1/ifcfg-br0.1", "/tmp/tests/ifcfg-br0.1", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/mix1/ifcfg-br0", "/tmp/tests/ifcfg-br0", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/mix1/ifcfg-dummy0", "/tmp/tests/ifcfg-dummy0", \
    "testuser", false
  local.should == 0; remote.should == 0
  if (CONFIGURE_LOWERDEVS)
    local, remote = SUT.inject_file \
      "test-files/mix1/ifcfg-eth0", "/tmp/tests/ifcfg-eth0", \
      "testuser", false
    local.should == 0; remote.should == 0
  end
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests br0.1"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I create br0\.1\(br0\(eth0, dummy0\), 1\) from XML files$/ do
  SUT.test_and_drop_results "log.sh step \"When I create br0.1(br0(eth0, dummy0), 1) from XML files\""
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-eth0.1 /etc/sysconfig/network/"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup eth0.1"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote = SUT.inject_file \
    "test-files/mix1/mix1.xml", "/tmp/tests/mix1.xml", \
    "testuser", false
  local.should == 0; remote.should == 0
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/mix1.xml br0.1"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/mix1.xml all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I create br0\(eth0\.1\(eth0, 1\), eth1\) from legacy files$/ do
  SUT.test_and_drop_results "log.sh step \"When I create br0(eth0.1(eth0, 1), eth1) from legacy files\""
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-eth0.1 /etc/sysconfig/network/"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup eth0.1"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote = SUT.inject_file \
    "test-files/mix2/ifcfg-br0", "/tmp/tests/ifcfg-br0", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/mix2/ifcfg-eth0.1", "/tmp/tests/ifcfg-eth0.1", \
    "testuser", false
  local.should == 0; remote.should == 0
  if (CONFIGURE_LOWERDEVS)
    local, remote = SUT.inject_file \
      "test-files/mix2/ifcfg-eth0", "/tmp/tests/ifcfg-eth0", \
      "testuser", false
    local.should == 0; remote.should == 0
    local, remote = SUT.inject_file \
      "test-files/mix2/ifcfg-eth1", "/tmp/tests/ifcfg-eth1", \
      "testuser", false
    local.should == 0; remote.should == 0
  end
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests br0"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I create br0\(eth0\.1\(eth0, 1\), eth1\) from XML files$/ do
  SUT.test_and_drop_results "log.sh step \"When I create br0(eth0.1(eth0, 1), eth1) from XML files\""
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-eth0.1 /etc/sysconfig/network/"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup eth0.1"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote = SUT.inject_file \
    "test-files/mix2/mix2.xml", "/tmp/tests/mix2.xml", \
    "testuser", false
  local.should == 0; remote.should == 0
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/mix2.xml br0"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/mix2.xml all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I create br0\(eth0\.1\(eth0, 1\), eth1\.1\(eth1, 1\)\) from legacy files$/ do
  SUT.test_and_drop_results "log.sh step \"When I create br0(eth0.1(eth0, 1), eth1.1(eth1, 1)) from legacy files\""
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-eth0.1 /etc/sysconfig/network/"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup eth0.1"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-eth1.1 /etc/sysconfig/network/"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup eth1.1"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote = SUT.inject_file \
    "test-files/mix3/ifcfg-br0", "/tmp/tests/ifcfg-br0", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/mix3/ifcfg-eth0.1", "/tmp/tests/ifcfg-eth0.1", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/mix3/ifcfg-eth1.1", "/tmp/tests/ifcfg-eth1.1", \
    "testuser", false
  local.should == 0; remote.should == 0
  if (CONFIGURE_LOWERDEVS)
    local, remote = SUT.inject_file \
      "test-files/mix3/ifcfg-eth0", "/tmp/tests/ifcfg-eth0", \
      "testuser", false
    local.should == 0; remote.should == 0
    local, remote = SUT.inject_file \
      "test-files/mix3/ifcfg-eth1", "/tmp/tests/ifcfg-eth1", \
      "testuser", false
    local.should == 0; remote.should == 0
  end
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests br0"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I create br0\(eth0\.1\(eth0, 1\), eth1\.1\(eth1, 1\)\) from XML files$/ do
  SUT.test_and_drop_results "log.sh step \"When I create br0(eth0.1(eth0, 1), eth1.1(eth1, 1)) from XML files\""
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-eth0.1 /etc/sysconfig/network/"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup eth0.1"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-eth1.1 /etc/sysconfig/network/"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup eth1.1"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote = SUT.inject_file \
    "test-files/mix3/mix3.xml", "/tmp/tests/mix3.xml", \
    "testuser", false
  local.should == 0; remote.should == 0
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/mix3.xml br0"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/mix3.xml all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I create bond1\(eth0\.1\(eth0, 1\), eth1\.1\(eth1, 1\)\) from legacy files$/ do
  SUT.test_and_drop_results "log.sh step \"When I create bond1(eth0.1(eth0, 1), eth1.1(eth1, 1)) from legacy files\""
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-eth0.1 /etc/sysconfig/network/"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup eth0.1"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-eth1.1 /etc/sysconfig/network/"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup eth1.1"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-bond1 /etc/sysconfig/network/"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup bond1"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote = SUT.inject_file \
    "test-files/mix4/ifcfg-bond1", "/tmp/tests/ifcfg-bond1", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/mix4/ifcfg-eth0.1", "/tmp/tests/ifcfg-eth0.1", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/mix4/ifcfg-eth1.1", "/tmp/tests/ifcfg-eth1.1", \
    "testuser", false
  local.should == 0; remote.should == 0
  if (CONFIGURE_LOWERDEVS)
    local, remote = SUT.inject_file \
      "test-files/mix4/ifcfg-eth0", "/tmp/tests/ifcfg-eth0", \
      "testuser", false
    local.should == 0; remote.should == 0
    local, remote = SUT.inject_file \
      "test-files/mix4/ifcfg-eth1", "/tmp/tests/ifcfg-eth1", \
      "testuser", false
    local.should == 0; remote.should == 0
  end
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests bond1"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I create bond1\(eth0\.1\(eth0, 1\), eth1\.1\(eth1, 1\)\) from XML files$/ do
  SUT.test_and_drop_results "log.sh step \"When I create bond1(eth0.1(eth0, 1), eth1.1(eth1, 1)) from XML files\""
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-eth0.1 /etc/sysconfig/network/"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup eth0.1"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-eth1.1 /etc/sysconfig/network/"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup eth1.1"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-bond1 /etc/sysconfig/network/"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup bond1"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote = SUT.inject_file \
    "test-files/mix4/mix4.xml", "/tmp/tests/mix4.xml", \
    "testuser", false
  local.should == 0; remote.should == 0
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/mix4.xml bond1"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/mix4.xml all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I create br1\(bond0\(eth0, eth1\), dummy1\) from legacy files$/ do
  SUT.test_and_drop_results "log.sh step \"When I create br1(bond0(eth0, eth1), dummy1) from legacy files\""
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-bond0-xor /etc/sysconfig/network/ifcfg-bond0"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup bond0"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote = SUT.inject_file \
    "test-files/mix5/ifcfg-br1", "/tmp/tests/ifcfg-br1", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/mix5/ifcfg-bond0", "/tmp/tests/ifcfg-bond0", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/mix5/ifcfg-dummy1", "/tmp/tests/ifcfg-dummy1", \
    "testuser", false
  local.should == 0; remote.should == 0
  if (CONFIGURE_LOWERDEVS)
    local, remote = SUT.inject_file \
      "test-files/mix5/ifcfg-eth0", "/tmp/tests/ifcfg-eth0", \
      "testuser", false
    local.should == 0; remote.should == 0
    local, remote = SUT.inject_file \
      "test-files/mix5/ifcfg-eth1", "/tmp/tests/ifcfg-eth1", \
      "testuser", false
    local.should == 0; remote.should == 0
  end
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests br1"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I create br1\(bond0\(eth0, eth1\), dummy1\) from XML files$/ do
  SUT.test_and_drop_results "log.sh step \"When I create br1(bond0(eth0, eth1), dummy1) from XML files\""
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-bond0-xor /etc/sysconfig/network/ifcfg-bond0"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup bond0"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote = SUT.inject_file \
    "test-files/mix5/mix5.xml", "/tmp/tests/mix5.xml", \
    "testuser", false
  local.should == 0; remote.should == 0
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/mix5.xml br1"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/mix5.xml all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I create br1.42\(br1\(bond0\(eth0, eth1\), dummy1\), 42\) from legacy files$/ do
  SUT.test_and_drop_results "log.sh step \"When I create br1.42(br1(bond0(eth0, eth1), dummy1), 42) from legacy files\""
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-bond0-bc /etc/sysconfig/network/ifcfg-bond0"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup bond0"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-bond0.42 /etc/sysconfig/network/"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup bond0.42"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote = SUT.inject_file \
    "test-files/mix6/ifcfg-br1.42", "/tmp/tests/ifcfg-br1.42", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/mix6/ifcfg-br1", "/tmp/tests/ifcfg-br1", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/mix6/ifcfg-bond0", "/tmp/tests/ifcfg-bond0", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/mix6/ifcfg-dummy1", "/tmp/tests/ifcfg-dummy1", \
    "testuser", false
  local.should == 0; remote.should == 0
  if (CONFIGURE_LOWERDEVS)
    local, remote = SUT.inject_file \
      "test-files/mix6/ifcfg-eth0", "/tmp/tests/ifcfg-eth0", \
      "testuser", false
    local.should == 0; remote.should == 0
    local, remote = SUT.inject_file \
      "test-files/mix6/ifcfg-eth1", "/tmp/tests/ifcfg-eth1", \
      "testuser", false
    local.should == 0; remote.should == 0
  end
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests br1.42"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I create br1.42\(br1\(bond0\(eth0, eth1\), dummy1\), 42\) from XML files$/ do
  SUT.test_and_drop_results "log.sh step \"When I create br1.42(br1(bond0(eth0, eth1), dummy1), 42) from XML files\""
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-bond0-bc /etc/sysconfig/network/ifcfg-bond0"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup bond0"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-bond0.42 /etc/sysconfig/network/"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup bond0.42"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote = SUT.inject_file \
    "test-files/mix6/mix6.xml", "/tmp/tests/mix6.xml", \
    "testuser", false
  local.should == 0; remote.should == 0
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/mix6.xml br1.42"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/mix6.xml all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I create bond0.42\(bond0\(eth0, eth1\), 42\) and bond0.73\(bond0, 73\) from legacy files$/ do
  SUT.test_and_drop_results "log.sh step \"When I create bond0.42(bond0(eth0, eth1), 42) and bond0.73(bond0, 73) from legacy files\""
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-bond0-ieee /etc/sysconfig/network/ifcfg-bond0"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup bond0"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-bond0.42 /etc/sysconfig/network/"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup bond0.42"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-bond0.73 /etc/sysconfig/network/"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup bond0.73"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote = SUT.inject_file \
    "test-files/mix7/ifcfg-bond0.42", "/tmp/tests/ifcfg-bond0.42", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/mix7/ifcfg-bond0.73", "/tmp/tests/ifcfg-bond0.73", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/mix7/ifcfg-bond0", "/tmp/tests/ifcfg-bond0", \
    "testuser", false
  local.should == 0; remote.should == 0
  if (CONFIGURE_LOWERDEVS)
    local, remote = SUT.inject_file \
      "test-files/mix7/ifcfg-eth0", "/tmp/tests/ifcfg-eth0", \
      "testuser", false
    local.should == 0; remote.should == 0
    local, remote = SUT.inject_file \
      "test-files/mix7/ifcfg-eth1", "/tmp/tests/ifcfg-eth1", \
      "testuser", false
    local.should == 0; remote.should == 0
  end
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests bond0.42 bond0.73"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I create bond0.42\(bond0\(eth0, eth1\), 42\) and bond0.73\(bond0, 73\) from XML files$/ do
  SUT.test_and_drop_results "log.sh step \"When I create bond0.42(bond0(eth0, eth1), 42) and bond0.73(bond0, 73) from XML files\""
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-bond0-ieee /etc/sysconfig/network/ifcfg-bond0"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup bond0"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-bond0.42 /etc/sysconfig/network/"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup bond0.42"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-bond0.73 /etc/sysconfig/network/"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup bond0.73"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote = SUT.inject_file \
    "test-files/mix7/mix7.xml", "/tmp/tests/mix7.xml", \
    "testuser", false
  local.should == 0; remote.should == 0
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/mix7.xml bond0.42 bond0.73"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/mix7.xml all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I create br42\(bond0.42\(bond0\(eth0, eth1\), 42\), dummy0\) and br73\(bond0.73\(bond0, 73\), dummy1\) from legacy files$/ do
  SUT.test_and_drop_results "log.sh step \"When I create br42(bond0.42(bond0(eth0, eth1), 42), dummy0) and br73(bond0.73(bond0, 73), dummy1) from legacy files\""
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-bond0-rr /etc/sysconfig/network/ifcfg-bond0"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup bond0"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-bond0.42 /etc/sysconfig/network/"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup bond0.42"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-bond0.73 /etc/sysconfig/network/"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup bond0.73"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote = SUT.inject_file \
    "test-files/mix8/ifcfg-br42", "/tmp/tests/ifcfg-br42", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/mix8/ifcfg-br73", "/tmp/tests/ifcfg-br73", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/mix8/ifcfg-bond0.42", "/tmp/tests/ifcfg-bond0.42", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/mix8/ifcfg-bond0.73", "/tmp/tests/ifcfg-bond0.73", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/mix8/ifcfg-bond0", "/tmp/tests/ifcfg-bond0", \
    "testuser", false
  local.should == 0; remote.should == 0
  if (CONFIGURE_LOWERDEVS)
    local, remote = SUT.inject_file \
      "test-files/mix8/ifcfg-eth0", "/tmp/tests/ifcfg-eth0", \
      "testuser", false
    local.should == 0; remote.should == 0
    local, remote = SUT.inject_file \
      "test-files/mix8/ifcfg-eth1", "/tmp/tests/ifcfg-eth1", \
      "testuser", false
    local.should == 0; remote.should == 0
  end
  local, remote = SUT.inject_file \
    "test-files/mix8/ifcfg-dummy0", "/tmp/tests/ifcfg-dummy0", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/mix8/ifcfg-dummy1", "/tmp/tests/ifcfg-dummy1", \
    "testuser", false
  local.should == 0; remote.should == 0
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests br42 br73"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I create br42\(bond0.42\(bond0\(eth0, eth1\), 42\), dummy0\) and br73\(bond0.73\(bond0, 73\), dummy1\) from XML files$/ do
  SUT.test_and_drop_results "log.sh step \"When I create br42(bond0.42(bond0(eth0, eth1), 42), dummy0) and br73(bond0.73(bond0, 73), dummy1) from XML files\""
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-bond0-rr /etc/sysconfig/network/ifcfg-bond0"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup bond0"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-bond0.42 /etc/sysconfig/network/"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup bond0.42"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-bond0.73 /etc/sysconfig/network/"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup bond0.73"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote = SUT.inject_file \
    "test-files/mix8/mix8.xml", "/tmp/tests/mix8.xml", \
    "testuser", false
  local.should == 0; remote.should == 0
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/mix8.xml br42 br73"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/mix8.xml all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I create eth0\.1\(eth0, 1\) and br2\(eth0\) and eth0\.42\(eth0, 42\) from legacy files$/ do
  SUT.test_and_drop_results "log.sh step \"When I create eth0.1(eth0, 1) and br2(eth0) and eth0.42(eth0, 42) from legacy files\""
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-eth0.1 /etc/sysconfig/network/"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup eth0.1"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-eth0.42 /etc/sysconfig/network/"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup eth0.42"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote = SUT.inject_file \
    "test-files/mix9/ifcfg-eth0", "/tmp/tests/ifcfg-eth0", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/mix9/ifcfg-eth0.1", "/tmp/tests/ifcfg-eth0.1", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/mix9/ifcfg-br2", "/tmp/tests/ifcfg-br2", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/mix9/ifcfg-eth0.42", "/tmp/tests/ifcfg-eth0.42", \
    "testuser", false
  local.should == 0; remote.should == 0
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests eth0 eth0.1 br2 eth0.42"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I create eth0.1\(eth0, 1\) and br2\(eth0\) and eth0.42\(eth0, 42\) from XML files$/ do
  SUT.test_and_drop_results "log.sh step \"When I create eth0.1(eth0, 1) and br2(eth0) and eth0.42(eth0, 42) from XML files\""
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-eth0.1 /etc/sysconfig/network/"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup eth0.1"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-eth0.42 /etc/sysconfig/network/"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup eth0.42"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote = SUT.inject_file \
    "test-files/mix9/mix9.xml", "/tmp/tests/mix9.xml", \
    "testuser", false
  local.should == 0; remote.should == 0
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/mix9.xml eth0 eth0.1 br2 eth0.42"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig /tmp/tests/mix9.xml all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I create ovsbr1\(\(ovsbr0\(eth0, eth1\), 1\), dummy1\)$/ do
  SUT.test_and_drop_results "log.sh step \"When I create ovsbr1((ovsbr0(eth0, eth1), 1), dummy1)\""
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-eth0.1 /etc/sysconfig/network/"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup eth0.1"
  local.should == 0; remote.should == 0; command.should == 0
  #
  if (CONFIGURE_LOWERDEVS)
    local, remote = SUT.inject_file \
      "test-files/mix10/ifcfg-eth0", "/tmp/tests/ifcfg-eth0", \
      "testuser", false
    local.should == 0; remote.should == 0
    local, remote = SUT.inject_file \
      "test-files/mix10/ifcfg-eth1", "/tmp/tests/ifcfg-eth1", \
      "testuser", false
    local.should == 0; remote.should == 0
  end
  local, remote = SUT.inject_file \
    "test-files/mix10/ifcfg-dummy1", "/tmp/tests/ifcfg-dummy1", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/mix10/ifcfg-ovsbr0", "/tmp/tests/ifcfg-ovsbr0", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/mix10/ifcfg-ovsbr1", "/tmp/tests/ifcfg-ovsbr1", \
    "testuser", false
  local.should == 0; remote.should == 0
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests eth0 eth1 ovsbr0 ovsbr1"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I bring up ([^ ]*) by ifreload$/ do |interface|
  SUT.test_and_drop_results "log.sh step \"When I bring up #{interface} by ifreload\""
  local, remote, command = SUT.test_and_drop_results \
    "wic.sh ifreload --ifconfig compat:/tmp/tests #{interface}"
  local.should == 0; remote.should == 0; command.should == 0
end

When /^I create a bridge on interface eth1 from legacy files by ifreload$/ do
  SUT.test_and_drop_results "log.sh step \"When I create a bridge on interface eth1 from legacy files by ifreload\""
  local, remote = SUT.inject_file \
    "test-files/bridge/ifcfg-br1", "/tmp/tests/ifcfg-br1", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/bridge/ifcfg-dummy1", "/tmp/tests/ifcfg-dummy1", \
    "testuser", false
  local.should == 0; remote.should == 0
  if (CONFIGURE_LOWERDEVS)
    local, remote = SUT.inject_file \
      "test-files/bridge/ifcfg-eth1", "/tmp/tests/ifcfg-eth1", \
      "testuser", false
    local.should == 0; remote.should == 0
  end
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifreload --ifconfig compat:/tmp/tests br1"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifreload --ifconfig compat:/tmp/tests all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I delete the config file for ([^ ]*)$/ do |interface|
  SUT.test_and_drop_results "log.sh step \"When I delete the config file for #{interface}\""
  if not(CONFIGURE_LOWERDEVS)
    next if interface =~ /^eth\d/
  end
  local, remote, command = SUT.test_and_drop_results \
    "rm /tmp/tests/ifcfg-#{interface}"
  local.should == 0; remote.should == 0; command.should == 0
end

When /^I change VLAN config and ifreload$/ do
  SUT.test_and_drop_results "log.sh step \"When I change VLAN config and ifreload\""
  local, remote, command = SUT.test_and_drop_results \
    "sed -i -e 's_#{V42_4_SUT}_#{V42_4_SUT1}_; s_#{V42_6_SUT}_#{V42_6_SUT1}_' /tmp/tests/ifcfg-eth1.42", "testuser"
  local.should == 0; remote.should == 0; command.should == 0
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifreload --ifconfig compat:/tmp/tests eth1.42"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifreload --ifconfig compat:/tmp/tests all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I create ([0-9]*) bridges$/ do |number|
  SUT.test_and_drop_results "log.sh step \"When I create #{number} bridges\""
  local, remote, command = SUT.test_and_drop_results \
    "/usr/local/bin/create_many_bridges.sh #{number}"
  local.should == 0; remote.should == 0; command.should == 0
end

When /^I delete ([0-9]*) bridges$/ do |number|
  SUT.test_and_drop_results "log.sh step \"When I create #{number} bridges\""
  local, remote, command = SUT.test_and_drop_results \
    "/usr/local/bin/delete_many_bridges.sh #{number}"
  local.should == 0; remote.should == 0; command.should == 0
end

When /^I set up the MTU on the reference server$/ do
  SUT.test_and_drop_results "log.sh step \"When I set up the MTU on the reference server\""
  local, remote, command = REF.test_and_drop_results \
    "ln -sf /etc/dhcpd-mtu.conf /etc/dhcpd.conf"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote, command = REF.test_and_drop_results \
    "systemctl restart dhcpd"
  local.should == 0; remote.should == 0; command.should == 0
end

When /^the DHCP client has to ([^ ]*) the leases at the end$/ do |action|
  SUT.test_and_drop_results "log.sh step \"When the DHCP client has to #{action} the leases at the end\""
  local, remote, command = SUT.test_and_drop_results \
    "ln -sf /etc/sysconfig/network/dhcp-#{action}-leases /etc/sysconfig/network/dhcp"
  local.should == 0; remote.should == 0; command.should == 0
end

When /^I sniff DHCP on the reference machine$/ do
  SUT.test_and_drop_results "log.sh step \"When I sniff DHCP on the reference machine\""
  local, remote, command = REF.test_and_drop_results \
    "tcpdump.sh start -U -w /tmp/tcpdump -n -i any 'port 67 or port 68'"
  local.should == 0; remote.should == 0; command.should == 0
end

When /^I set up the speed of eth0 to (\d*) Mbit\/s$/ do |speed|
  if @skip_when_virtual_machine
    puts "(skipped)"
    sleep 1
    next
  end
  SUT.test_and_drop_results "log.sh step \"When I set up the speed of eth0 to #{speed} Mbit/s\""
  local, remote = SUT.inject_file \
    "test-files/ethtool-options/ifcfg-eth0-#{speed}mbps", "/tmp/tests/ifcfg-eth0", \
    "testuser", false
  local.should == 0; remote.should == 0
  #
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests eth0"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I set up eth0 with ([^ ]*) option$/ do |option|
  SUT.test_and_drop_results "log.sh step \"When I set up eth0 with #{option} option\""
  local, remote = SUT.inject_file \
    "test-files/autoip-options/ifcfg-eth0-#{option}", "/tmp/tests/ifcfg-eth0", \
    "testuser", false
  local.should == 0; remote.should == 0
  #
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests eth0"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /I let ([^ ]*) wait for a router announcement$/ do |interface|
  SUT.test_and_drop_results "log.sh step \"When I let #{interface} wait for a router announcement\""
  local, remote, command = SUT.test_and_drop_results \
    "rdisc6 #{interface}"
  local.should == 0; remote.should == 0; command.should == 0
end

When /^radvd is set to managed off, other off, prefix length != 64$/ do
  SUT.test_and_drop_results "log.sh step \"When radvd is set to managed off, other off, prefix length != 64\""
  local, remote, command = REF.test_and_drop_results \
    "ln -sf /etc/radvd-1.conf /etc/radvd.conf"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote, command = REF.test_and_drop_results \
    "systemctl restart radvd"
  local.should == 0; remote.should == 0; command.should == 0
end

When /^radvd is set to managed off, other off, prefix length != 64, RDNSS$/ do
  SUT.test_and_drop_results "log.sh step \"When radvd is set to managed off, other off, prefix length != 64, RDNSS\""
  local, remote, command = REF.test_and_drop_results \
    "ln -sf /etc/radvd-2.conf /etc/radvd.conf"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote, command = REF.test_and_drop_results \
    "systemctl restart radvd"
  local.should == 0; remote.should == 0; command.should == 0
end

When /^radvd is set to managed off, other off, prefix length == 64$/ do
  SUT.test_and_drop_results "log.sh step \"When radvd is set to managed off, other off, prefix length == 64\""
  local, remote, command = REF.test_and_drop_results \
    "ln -sf /etc/radvd-3.conf /etc/radvd.conf"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote, command = REF.test_and_drop_results \
    "systemctl restart radvd"
  local.should == 0; remote.should == 0; command.should == 0
end

When /^radvd is set to managed off, other off, prefix length == 64, RDNSS$/ do
  SUT.test_and_drop_results "log.sh step \"When radvd is set to managed off, other off, prefix length == 64, RDNSS\""
  local, remote, command = REF.test_and_drop_results \
    "ln -sf /etc/radvd-4.conf /etc/radvd.conf"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote, command = REF.test_and_drop_results \
    "systemctl restart radvd"
  local.should == 0; remote.should == 0; command.should == 0
end

When /^radvd is set to managed off, other on, prefix length != 64$/ do
  SUT.test_and_drop_results "log.sh step \"When radvd is set to managed off, other on, prefix length != 64\""
  local, remote, command = REF.test_and_drop_results \
    "ln -sf /etc/radvd-5.conf /etc/radvd.conf"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote, command = REF.test_and_drop_results \
    "systemctl restart radvd"
  local.should == 0; remote.should == 0; command.should == 0
end

When /^radvd is set to managed off, other on, prefix length != 64, RDNSS$/ do
  SUT.test_and_drop_results "log.sh step \"When radvd is set to managed off, other on, prefix length != 64, RDNSS\""
  local, remote, command = REF.test_and_drop_results \
    "ln -sf /etc/radvd-6.conf /etc/radvd.conf"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote, command = REF.test_and_drop_results \
    "systemctl restart radvd"
  local.should == 0; remote.should == 0; command.should == 0
end

When /^radvd is set to managed off, other on, prefix length == 64$/ do
  SUT.test_and_drop_results "log.sh step \"When radvd is set to managed off, other on, prefix length == 64\""
  local, remote, command = REF.test_and_drop_results \
    "ln -sf /etc/radvd-7.conf /etc/radvd.conf"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote, command = REF.test_and_drop_results \
    "systemctl restart radvd"
  local.should == 0; remote.should == 0; command.should == 0
end

When /^radvd is set to managed off, other on, prefix length == 64, RDNSS$/ do
  SUT.test_and_drop_results "log.sh step \"When radvd is set to managed off, other on, prefix length == 64, RDNSS\""
  local, remote, command = REF.test_and_drop_results \
    "ln -sf /etc/radvd-8.conf /etc/radvd.conf"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote, command = REF.test_and_drop_results \
    "systemctl restart radvd"
  local.should == 0; remote.should == 0; command.should == 0
end

When /^radvd is set to managed on, prefix length != 64$/ do
  SUT.test_and_drop_results "log.sh step \"When radvd is set to managed on, prefix length != 64\""
  local, remote, command = REF.test_and_drop_results \
    "ln -sf /etc/radvd-9.conf /etc/radvd.conf"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote, command = REF.test_and_drop_results \
    "systemctl restart radvd"
  local.should == 0; remote.should == 0; command.should == 0
end

When /^radvd is set to managed on, prefix length != 64, RDNSS$/ do
  SUT.test_and_drop_results "log.sh step \"When radvd is set to managed on, prefix length != 64, RDNSS\""
  local, remote, command = REF.test_and_drop_results \
    "ln -sf /etc/radvd-10.conf /etc/radvd.conf"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote, command = REF.test_and_drop_results \
    "systemctl restart radvd"
  local.should == 0; remote.should == 0; command.should == 0
end

When /^radvd is set to managed on, prefix length == 64$/ do
  SUT.test_and_drop_results "log.sh step \"When radvd is set to managed on, prefix length == 64\""
  local, remote, command = REF.test_and_drop_results \
    "ln -sf /etc/radvd-11.conf /etc/radvd.conf"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote, command = REF.test_and_drop_results \
    "systemctl restart radvd"
  local.should == 0; remote.should == 0; command.should == 0
end

When /^radvd is set to managed on, prefix length == 64, RDNSS$/ do
  SUT.test_and_drop_results "log.sh step \"When radvd is set to managed on, prefix length == 64, RDNSS\""
  local, remote, command = REF.test_and_drop_results \
    "ln -sf /etc/radvd-12.conf /etc/radvd.conf"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote, command = REF.test_and_drop_results \
    "systemctl restart radvd"
  local.should == 0; remote.should == 0; command.should == 0
end

When /^radvd is switched off$/ do
  SUT.test_and_drop_results "log.sh step \"When radvd is switched off\""
  local, remote, command = REF.test_and_drop_results \
    "systemctl stop radvd"
  local.should == 0; remote.should == 0; command.should == 0
end

When /^dhcpd is switched off$/ do
  SUT.test_and_drop_results "log.sh step \"When dhcpd is switched off\""
  local, remote, command = REF.test_and_drop_results \
    "systemctl stop dhcpd"
  local.should == 0; remote.should == 0; command.should == 0
end

When /^dhcpd6 is switched off$/ do
  SUT.test_and_drop_results "log.sh step \"When dhcpd6 is switched off\""
  local, remote, command = REF.test_and_drop_results \
    "systemctl stop dhcpd6"
  local.should == 0; remote.should == 0; command.should == 0
end

When /^I retrigger DHCP requests$/ do
  SUT.test_and_drop_results "log.sh step \"When I retrigger DHCP requests\""
  # We do it by power cycling eth0
  # Restart is done from legacy config files
  local, remote, command = SUT.test_and_drop_results \
    "wic.sh ifdown eth0"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote, command = SUT.test_and_drop_results \
    "wic.sh ifup --ifconfig compat:/tmp/tests eth0"
  local.should == 0; remote.should == 0
  case command
  when 0
    @setup_in_progress = false
  when 162
    @setup_in_progress = true
  else
    raise "Unexpected error code."
  end
end

When /^I try to bring up eth0$/ do
  SUT.test_and_drop_results "log.sh step \"When I try to bring up eth0\""
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifreload --ifconfig compat:/tmp/tests eth0"
    local.should == 0; remote.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifreload --ifconfig compat:/tmp/tests all"
    local.should == 0; remote.should == 0
  end
  case command
  when 0
    @setup_in_progress = false
  when 162
    @setup_in_progress = true
  else
    raise "Unexpected error code."
  end
end

When /^I bring up eth0 with BOOTPROTO="([^"]*)"$/ do |mode|
  SUT.test_and_drop_results "log.sh step \"When I bring up eth0 with BOOTPROTO=#{mode}\""
  local, remote = SUT.inject_file \
    "test-files/bootproto/ifcfg-eth0-#{mode}", "/tmp/tests/ifcfg-eth0", \
    "testuser", false
  local.should == 0; remote.should == 0
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifreload --ifconfig compat:/tmp/tests eth0"
    local.should == 0; remote.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifreload --ifconfig compat:/tmp/tests all"
    local.should == 0; remote.should == 0
  end
  case command
  when 0
    @setup_in_progress = false
  when 162
    @setup_in_progress = true
  else
    raise "Unexpected error code."
  end
end

When /^I set up systemd scripts for eth0 from legacy file$/ do
  SUT.test_and_drop_results "log.sh step \"When I set up systemd scripts for eth0 from legacy file\""
  local, remote = SUT.inject_file \
    "test-files/scripts-systemd/ifcfg-eth0", "/tmp/tests/ifcfg-eth0", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/scripts-systemd/pre@eth0.service", "/usr/lib/systemd/system/pre@eth0.service", \
    "root", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/scripts-systemd/post@eth0.service", "/usr/lib/systemd/system/post@eth0.service", \
    "root", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/scripts-systemd/pre-up.sh", "/tmp/tests/pre-up.sh", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/scripts-systemd/post-up.sh", "/tmp/tests/post-up.sh", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/scripts-systemd/pre-down.sh", "/tmp/tests/pre-down.sh", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/scripts-systemd/post-down.sh", "/tmp/tests/post-down.sh", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote, command = SUT.test_and_drop_results \
    "chmod +x /tmp/tests/*.sh"
  local.should == 0; remote.should == 0; command.should == 0
end

When /^I set up systemd scripts for eth0 from XML file$/ do
  SUT.test_and_drop_results "log.sh step \"When I set up systemd scripts for eth0 from XML file\""
  local, remote = SUT.inject_file \
    "test-files/scripts-systemd/eth0.xml", "/tmp/tests/eth0.xml", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/scripts-systemd/pre@eth0.service", "/usr/lib/systemd/system/pre@eth0.service", \
    "root", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/scripts-systemd/post@eth0.service", "/usr/lib/systemd/system/post@eth0.service", \
    "root", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/scripts-systemd/pre-up.sh", "/tmp/tests/pre-up.sh", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/scripts-systemd/post-up.sh", "/tmp/tests/post-up.sh", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/scripts-systemd/pre-down.sh", "/tmp/tests/pre-down.sh", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/scripts-systemd/post-down.sh", "/tmp/tests/post-down.sh", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote, command = SUT.test_and_drop_results \
    "chmod +x /tmp/tests/*.sh"
  local.should == 0; remote.should == 0; command.should == 0
end

When /^I set up wicked scripts for eth0 from legacy file$/ do
  SUT.test_and_drop_results "log.sh step \"When I set up wicked scripts for eth0 from legacy file\""
  local, remote = SUT.inject_file \
    "test-files/scripts-wicked/ifcfg-eth0", "/tmp/tests/ifcfg-eth0", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/scripts-wicked/pre-up.sh", "/tmp/tests/pre-up.sh", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/scripts-wicked/post-up.sh", "/tmp/tests/post-up.sh", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/scripts-wicked/pre-down.sh", "/tmp/tests/pre-down.sh", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/scripts-wicked/post-down.sh", "/tmp/tests/post-down.sh", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote, command = SUT.test_and_drop_results \
    "chmod +x /tmp/tests/*.sh"
  local.should == 0; remote.should == 0; command.should == 0
end

When /^I set up wicked scripts for eth0 from XML file$/ do
  SUT.test_and_drop_results "log.sh step \"When I set up wicked scripts for eth0 from XML file\""
  local, remote = SUT.inject_file \
    "test-files/scripts-wicked/eth0.xml", "/tmp/tests/eth0.xml", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/scripts-wicked/pre-up.sh", "/tmp/tests/pre-up.sh", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/scripts-wicked/post-up.sh", "/tmp/tests/post-up.sh", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/scripts-wicked/pre-down.sh", "/tmp/tests/pre-down.sh", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/scripts-wicked/post-down.sh", "/tmp/tests/post-down.sh", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote, command = SUT.test_and_drop_results \
    "chmod +x /tmp/tests/*.sh"
  local.should == 0; remote.should == 0; command.should == 0
end

When /^I set up compat scripts for eth0 from legacy file$/ do
  SUT.test_and_drop_results "log.sh step \"When I set up compat scripts for eth0 from legacy file\""
  local, remote = SUT.inject_file \
    "test-files/scripts-compat/ifcfg-eth0", "/tmp/tests/ifcfg-eth0", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/scripts-compat/pre-up.sh", "/tmp/tests/pre-up.sh", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/scripts-compat/post-up.sh", "/tmp/tests/post-up.sh", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/scripts-compat/pre-down.sh", "/tmp/tests/pre-down.sh", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/scripts-compat/post-down.sh", "/tmp/tests/post-down.sh", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote, command = SUT.test_and_drop_results \
    "chmod +x /tmp/tests/*.sh"
  local.should == 0; remote.should == 0; command.should == 0
end

When /^I set up compat scripts for eth0 from XML file$/ do
  SUT.test_and_drop_results "log.sh step \"When I set up compat scripts for eth0 from XML file\""
  local, remote = SUT.inject_file \
    "test-files/scripts-compat/eth0.xml", "/tmp/tests/eth0.xml", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/scripts-compat/pre-up.sh", "/tmp/tests/pre-up.sh", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/scripts-compat/post-up.sh", "/tmp/tests/post-up.sh", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/scripts-compat/pre-down.sh", "/tmp/tests/pre-down.sh", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/scripts-compat/post-down.sh", "/tmp/tests/post-down.sh", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote, command = SUT.test_and_drop_results \
    "chmod +x /tmp/tests/*.sh"
  local.should == 0; remote.should == 0; command.should == 0
end

When /^I set up scripts for eth0 with BOOTPROTO="([^"]*)"$/ do |mode|
  SUT.test_and_drop_results "log.sh step \"When I set up scripts for eth0 with BOOTPROTO=#{mode}\""
  local, remote = SUT.inject_file \
    "test-files/scripts-bootproto/ifcfg-eth0-#{mode}", "/tmp/tests/ifcfg-eth0", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/scripts-bootproto/pre-up.sh", "/tmp/tests/pre-up.sh", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "test-files/scripts-bootproto/post-up.sh", "/tmp/tests/post-up.sh", \
    "testuser", false
  local.should == 0; remote.should == 0
  local, remote, command = SUT.test_and_drop_results \
    "chmod +x /tmp/tests/*.sh"
  local.should == 0; remote.should == 0; command.should == 0
end

When /^I declare a non-matching route for eth0$/ do
  SUT.test_and_drop_results "log.sh step \"When I declare a non-matching route for eth0\""
  local, remote = SUT.inject_file \
    "test-files/scripts-bootproto/ifroute-eth0-bad", "/tmp/tests/ifroute-eth0", \
    "testuser", false
  local.should == 0; remote.should == 0
end

When /^I bond together eth0 and eth1 in ([^ ]*) mode$/ do |mode|
  SUT.test_and_drop_results "log.sh step \"When I bond together eth0 and eth1 in #{mode} mode\""
  #
  ifref = case mode
    when "balance-rr" then "bond0-rr"
    when "active-backup" then "bond0-ab"
    when "balance-xor" then "bond0-xor"
    when "broadcast" then "bond0-bc"
    when "802.3ad" then "bond0-ieee"
    when "balance-tlb" then "br0"
    when "balance-alb" then "br0"
  end
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-#{ifref} /etc/sysconfig/network/ifcfg-bond0"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup bond0"
  local.should == 0; remote.should == 0; command.should == 0
  #
  ifsut = case mode
    when "balance-rr" then "bond0-rr"
    when "active-backup" then "bond0-ab"
    when "balance-xor" then "bond0-xor"
    when "broadcast" then "bond0-bc"
    when "802.3ad" then "bond0-ieee"
    when "balance-tlb" then "bond0-tlb"
    when "balance-alb" then "bond0-alb"
  end
  local, remote = SUT.inject_file \
    "test-files/bonding/ifcfg-#{ifsut}", "/tmp/tests/ifcfg-bond0", \
    "testuser", false
  local.should == 0; remote.should == 0
  if (CONFIGURE_LOWERDEVS)
    local, remote = SUT.inject_file \
      "test-files/bonding/ifcfg-eth0", "/tmp/tests/ifcfg-eth0", \
      "testuser", false
    local.should == 0; remote.should == 0
    local, remote = SUT.inject_file \
      "test-files/bonding/ifcfg-eth1", "/tmp/tests/ifcfg-eth1", \
      "testuser", false
    local.should == 0; remote.should == 0
  end
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests bond0"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I team together eth0 and eth1 in ([^ ]*) mode$/ do |mode|
  SUT.test_and_drop_results "log.sh step \"When I team together eth0 and eth1 in #{mode} mode\""
  #
  m = case mode
    when "roundrobin" then "rr"
    when "random" then "rr"
    when "activebackup" then "ab"
    when "loadbalance" then "xor"
    when "broadcast" then "bc"
    when "lacp" then "ieee"
  end
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-bond0-#{m} /etc/sysconfig/network/ifcfg-bond0"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup bond0"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote = SUT.inject_file \
    "test-files/teaming/ifcfg-team0-#{mode}", "/tmp/tests/ifcfg-team0", \
    "testuser", false
  local.should == 0; remote.should == 0
  if (CONFIGURE_LOWERDEVS)
    local, remote = SUT.inject_file \
      "test-files/teaming/ifcfg-eth0", "/tmp/tests/ifcfg-eth0", \
      "testuser", false
    local.should == 0; remote.should == 0
    local, remote = SUT.inject_file \
      "test-files/teaming/ifcfg-eth1", "/tmp/tests/ifcfg-eth1", \
      "testuser", false
    local.should == 0; remote.should == 0
  end
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests team0"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I team together eth0 and eth1 with ([^ ]*) link watcher$/ do |lw|
  SUT.test_and_drop_results "log.sh step \"When I team together eth0 and eth1 with #{lw} link watcher\""
  #
  local, remote, command = REF.test_and_drop_results \
    "ln -s pool/ifcfg-bond0-ab /etc/sysconfig/network/ifcfg-bond0"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = REF.test_and_drop_results \
    "ifup bond0"
  local.should == 0; remote.should == 0; command.should == 0
  #
  local, remote = SUT.inject_file \
    "test-files/teaming/ifcfg-team0-ab-#{lw}", "/tmp/tests/ifcfg-team0", \
    "testuser", false
  local.should == 0; remote.should == 0
  if (CONFIGURE_LOWERDEVS)
    local, remote = SUT.inject_file \
      "test-files/teaming/ifcfg-eth0", "/tmp/tests/ifcfg-eth0", \
      "testuser", false
    local.should == 0; remote.should == 0
    local, remote = SUT.inject_file \
      "test-files/teaming/ifcfg-eth1", "/tmp/tests/ifcfg-eth1", \
      "testuser", false
    local.should == 0; remote.should == 0
  end
  if (CONFIGURE_PRECISELY)
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests team0"
    local.should == 0; remote.should == 0; command.should == 0
  else
    local, remote, command = SUT.test_and_drop_results \
      "wic.sh ifup --ifconfig compat:/tmp/tests all"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

When /^I cut ([^']*)'s link$/ do |interface|
  SUT.test_and_drop_results "log.sh step \"When I cut #{interface}'s link\""
  local, remote, command = REF.test_and_drop_results \
    "ip link set down #{interface}"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = SUT.test_and_drop_results \
    "ip link set down #{interface}"
  local.should == 0; remote.should == 0; command.should == 0
end
