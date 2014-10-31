# # # Background sanity checks # # #

When /^the reference machine is set up correctly$/ do
  out, local, remote, command = REF.test_and_store_results_together \
    "testuser", "ps aux"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "dhcpd -4"
  out.should include "dhcpd6 -6"
  out.should include "radvd"
  out.should_not include "openvpn"
  out.should_not include "tcpdump"
  #
  out, local, remote, command = REF.test_and_store_results_together \
    "root", "iptables -t nat -L"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "MASQUERADE"
  #
  out, local, remote, command = REF.test_and_store_results_together \
    "root", "ip6tables -t nat -L"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "MASQUERADE"
  #
  out, local, remote, command = REF.test_and_store_results_together \
    "testuser",  "ip address show dev eth0"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "#{DHCP4_REF0}"
  out.should include "#{STAT4_REF0}"
  out.should include "#{RADVD_REF0}"
  out.should include "#{STAT6_REF0}"
  #
  out, local, remote, command = REF.test_and_store_results_together \
    "testuser",  "ip address show dev eth1"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "#{STAT4_REF1}"
  out.should include "#{STAT6_REF1}"
  #
  out, local, remote, command = REF.test_and_store_results_together \
    "testuser",  "ip -4 route show"
  local.should == 0; remote.should == 0; command.should == 0
  out.should match /^default via .* dev eth2/
  out, local, remote, command = REF.test_and_store_results_together \
    "testuser",  "ip -6 route show"
  local.should == 0; remote.should == 0; command.should == 0
  out.should match /^default via .* dev eth2/
  #
  out, local, remote, command = REF.test_and_store_results_together \
    "testuser", "cat /etc/dhcpd.conf"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "# Default configuration"
  #
  out, local, remote, command = REF.test_and_store_results_together \
    "testuser", "cat /etc/dhcpd6.conf"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "# Default configuration"
  #
  out, local, remote, command = REF.test_and_store_results_together \
    "testuser", "cat /etc/radvd.conf"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "# Default configuration"
end

When /^there is no core dump$/ do
  out, local, remote, command = SUT.test_and_store_results_together \
    "testuser", "ls /core*"
  local.should == 0; remote.should == 0;
  command.should == 2
end

When /^the system under test is set up correctly$/ do
  out, local, remote, command = SUT.test_and_store_results_together \
    "testuser", "ls /tmp/tests/ifcfg-* | grep -v ifcfg-lo"
  local.should == 0; remote.should == 0;
  out.should == ""
  #
  local, remote, command = SUT.test_and_drop_results \
    "testuser", "ls /tmp/tests/ifroute-*"
  local.should == 0; remote.should == 0;
  command.should == 2
  #
  local, remote, command = SUT.test_and_drop_results \
    "testuser", "grep WAIT_FOR_INTERFACES /tmp/tests/config"
  local.should == 0; remote.should == 0;
  command.should == 0
end

When /^the wicked services are started$/ do
  out, local, remote, command = SUT.test_and_store_results_together \
    "testuser", "systemctl status wickedd.service"
  local.should == 0; remote.should == 0; command.should == 0
  out.should match /\s[aA]ctive/
  #
  out, local, remote, command = SUT.test_and_store_results_together \
    "testuser", "systemctl status wicked.service"
  local.should == 0; remote.should == 0; command.should == 0
  out.should match /\s[aA]ctive/
end

When /^the interfaces are in a basic state$/ do
  # lo is not DOWN
  out, local, remote, command = SUT.test_and_store_results_together \
    "testuser", "ip address show dev lo"
  local.should == 0; remote.should == 0
  out.should_not include "DOWN"
  # eth0 is DOWN
  out, local, remote, command = SUT.test_and_store_results_together \
    "testuser", "ip address show dev eth0"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "DOWN"
  # eth1 is DOWN
  out, local, remote, command = SUT.test_and_store_results_together \
    "testuser", "ip address show dev eth1"
  local.should == 0; remote.should == 0; command.should == 0
  out.should include "DOWN"
end

When /^the routing table is empty$/ do
  out, local, remote, command = SUT.test_and_store_results_together \
    "testuser", "ip -4 route show"
  local.should == 0; remote.should == 0; command.should == 0
  out.should be_empty
  #
  out, local, remote, command = SUT.test_and_store_results_together \
    "testuser", "ip -6 route show | egrep -v \"fe80:|fd00:\""
  local.should == 0; remote.should == 0
  out.should be_empty
end

When /^there is no virtual interface left on any machine$/ do
  outref, local, remote, command = REF.test_and_store_results_together \
    "testuser", "ip link show"
  local.should == 0; remote.should == 0; command.should == 0
  outsut, local, remote, command = SUT.test_and_store_results_together \
    "testuser", "ip link show"
  local.should == 0; remote.should == 0; command.should == 0
  #
  outref.should_not include "eth0.42@"
  outsut.should_not include "eth0.42@"
  #
  outref.should_not include "eth1.42@"
  outsut.should_not include "eth1.42@"
  #
  outref.should_not include "eth0.1@"
  outsut.should_not include "eth0.1@"
  #
  outref.should_not include "eth1.1@"
  outsut.should_not include "eth1.1@"
  #
  outsut.should_not include "br0:"
  #
  outsut.should_not include "br1:"
  #
  outsut.should_not include "br0.1@"
  #
  outref.should_not include "bond0:"
  outsut.should_not include "bond0:"
  #
  outref.should_not include "bond1:"
  outsut.should_not include "bond1:"
  #
  outref.should_not include "bond0.42@"
  outsut.should_not include "bond0.42@"
  #
  outref.should_not include "bond0.73@"
  outsut.should_not include "bond0.73@"
  #
  outsut.should_not include "macvtap1:"
  #
  outref.should_not include "tun1:"
  outsut.should_not include "tun1:"
  #
  outref.should_not include "tap1:"
  outsut.should_not include "tap1:"
  #
  outref.should_not include "gre0:"
  outsut.should_not include "gre0@"
  #
  outref.should_not include "gre1:"
  outsut.should_not include "gre1@"
  #
  outref.should_not include "tunl0:"
  outsut.should_not include "tunl0@"
  #
  outref.should_not include "tunl1:"
  outsut.should_not include "tunl1@"
  #
  outref.should_not include "sit0:"
  outsut.should_not include "sit0:"
  #
  outref.should_not include "sit1:"
  outsut.should_not include "sit1:"
  #
  outref.should_not include "ib0:"
  outsut.should_not include "ib1:"
  #
  outref.should_not include "ib0.8001@"
  outsut.should_not include "ib1.8001@"
end
