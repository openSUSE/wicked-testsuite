# # # Cleanup before each scenario # # #

# Prepare the reference machine
def prepareReference()
  # remove all symlinks to interface declarations
  local, remote, command = REF.test_and_drop_results \
    "root", "cleanup.sh"
  local.should == 0; remote.should == 0; command.should == 0

  # stop the bonding if any
  local, remote, command = REF.test_and_drop_results \
    "testuser", "ip link show dev bond0"
  local.should == 0; remote.should == 0
  if command == 0
    local, remote, command = REF.test_and_drop_results \
      "root", "ip link delete dev bond0"
    local.should == 0; remote.should == 0; command.should == 0
  end
  local, remote, command = REF.test_and_drop_results \
    "testuser", "ip link show dev bond1"
  local.should == 0; remote.should == 0
  if command == 0
    local, remote, command = REF.test_and_drop_results \
      "root", "ip link delete dev bond1"
    local.should == 0; remote.should == 0; command.should == 0
  end

  # stop the vlans if any
  out, local, remote, command = REF.test_and_store_results_together \
    "testuser", "ip link show"
  local.should == 0; remote.should == 0; command.should == 0
  if out.include? "eth0.42@"
    local, remote, command = REF.test_and_drop_results \
      "root", "ip link delete dev eth0.42"
    local.should == 0; remote.should == 0; command.should == 0
  end
  if out.include? "eth1.42@"
    local, remote, command = REF.test_and_drop_results \
      "root", "ip link delete dev eth1.42"
    local.should == 0; remote.should == 0; command.should == 0
  end
  if out.include? "eth0.1@"
    local, remote, command = REF.test_and_drop_results \
      "root", "ip link delete dev eth0.1"
    local.should == 0; remote.should == 0; command.should == 0
  end
  if out.include? "eth1.1@"
    local, remote, command = REF.test_and_drop_results \
      "root", "ip link delete dev eth1.1"
    local.should == 0; remote.should == 0; command.should == 0
  end
  if out.include? "bond0.42@"
    local, remote, command = REF.test_and_drop_results \
      "root", "ip link delete dev bond0.42"
    local.should == 0; remote.should == 0; command.should == 0
  end
  if out.include? "bond0.73@"
    local, remote, command = REF.test_and_drop_results \
      "root", "ip link delete dev bond0.73"
    local.should == 0; remote.should == 0; command.should == 0
  end

  # stop openvpn if started
  out, local, remote, command = REF.test_and_store_results_together \
    "testuser", "ps aux"
  local.should == 0; remote.should == 0; command.should == 0
  if out.include? "openvpn"
    local, remote, command = REF.test_and_drop_results \
      "root", "systemctl stop openvpn@server"
    local.should == 0; remote.should == 0; command.should == 0
  end

  # remove tunnel interfaces if any
  out, local, remote, command = REF.test_and_store_results_together \
    "testuser", "ip link show"
  local.should == 0; remote.should == 0; command.should == 0
  if out.include? "tun1:"
    local, remote, command = REF.test_and_drop_results \
      "root", "ip link delete dev tun1"
    local.should == 0; remote.should == 0; command.should == 0
  end
  if out.include? "tap1:"
    local, remote, command = REF.test_and_drop_results \
      "root", "ip link delete dev tap1"
    local.should == 0; remote.should == 0; command.should == 0
  end
  if out.include? "gre1@"
    local, remote, command = REF.test_and_drop_results \
      "root", "ip link delete dev gre1"
    local.should == 0; remote.should == 0; command.should == 0
  end
  if out.include? "tunl1@"
    local, remote, command = REF.test_and_drop_results \
      "root", "ip link delete dev tunl1"
    local.should == 0; remote.should == 0; command.should == 0
  end
  if out.include? "sit1:"
    local, remote, command = REF.test_and_drop_results \
      "root", "ip link delete dev sit1"
    local.should == 0; remote.should == 0; command.should == 0
  end
  if out.include? "gre0:" or out.include? "tunl0:" or out.include? "sit0:"
    local, remote, command = REF.test_and_drop_results \
      "root", "modprobe -r gre ip_gre ipip sit ip_tunnel tunnel4"
    local.should == 0; remote.should == 0; command.should == 0
  end
  if out.include? "ib0.8001@"
    local, remote, command = REF.test_and_drop_results \
      "root", "ip link delete dev ib0.8001"
    local.should == 0; remote.should == 0; command.should == 0
  end

  # start the interfaces if needed
  out, local, remote, command = REF.test_and_store_results_together \
    "testuser", "ip address show dev eth0"
  local.should == 0; remote.should == 0; command.should == 0
  if !out.include? "UP" or \
     !out.include? "#{STAT4_REF0}" or \
     !out.include? "#{STAT6_REF0}" or \
     !out.include? "#{DHCP4_REF0}" or \
     !out.include? "#{RADVD_REF0}" or \
     !out.include? "#{DHCP6_REF0}"
    local, remote, command = REF.test_and_drop_results \
      "root", "ifdown eth0 && ifup eth0"
    local.should == 0; remote.should == 0; command.should == 0
  end
  #
  out, local, remote, command = REF.test_and_store_results_together \
    "testuser", "ip address show dev eth1"
  local.should == 0; remote.should == 0; command.should == 0
  if !out.include? "UP" or \
     !out.include? "#{STAT4_REF1}" or \
     !out.include? "#{STAT6_REF1}"
    local, remote, command = REF.test_and_drop_results \
      "root", "ifdown eth1 && ifup eth1"
    local.should == 0; remote.should == 0; command.should == 0
  end

  # start the dhcp services if needed
  out, local, remote, command = REF.test_and_store_results_together \
    "testuser", "ps aux | grep dhcp"
  local.should == 0; remote.should == 0
  if !out.include? "dhcpd -4"
    local, remote, command = REF.test_and_drop_results \
      "root", "ln -sf /etc/dhcpd-default.conf /etc/dhcpd.conf"
    local.should == 0; remote.should == 0; command.should == 0
    local, remote, command = REF.test_and_drop_results \
      "root", "systemctl start dhcpd.service"
    local.should == 0; remote.should == 0; command.should == 0
  end
  if !out.include? "dhcpd6 -6"
    local, remote, command = REF.test_and_drop_results \
      "root", "ln -sf /etc/dhcpd6-default.conf /etc/dhcpd6.conf"
    local.should == 0; remote.should == 0; command.should == 0
    local, remote, command = REF.test_and_drop_results \
      "root", "systemctl start dhcpd6.service"
    local.should == 0; remote.should == 0; command.should == 0
  end

  # start the radvd service if needed
  out, local, remote, command = REF.test_and_store_results_together \
    "testuser", "ps aux | grep radv"
  local.should == 0; remote.should == 0
  if !out.include? "radvd"
    local, remote, command = REF.test_and_drop_results \
      "root", "systemctl start radvd.service"
    local.should == 0; remote.should == 0; command.should == 0
  end

  # return to default DHCP configuration, if needed
  local, remote, command = REF.test_and_drop_results \
    "testuser", "grep '# Default configuration' /etc/dhcpd.conf"
  local.should == 0; remote.should == 0
  if command != 0
    local, remote, command = REF.test_and_drop_results \
      "root", "ln -sf /etc/dhcpd-default.conf /etc/dhcpd.conf"
    local.should == 0; remote.should == 0; command.should == 0
    local, remote, command = REF.test_and_drop_results \
      "root", "systemctl restart dhcpd.service"
    local.should == 0; remote.should == 0; command.should == 0
  end
  local, remote, command = REF.test_and_drop_results \
    "testuser", "grep '# Default configuration' /etc/dhcpd6.conf"
  local.should == 0; remote.should == 0
  if command != 0
    local, remote, command = REF.test_and_drop_results \
      "root", "ln -sf /etc/dhcpd-default.conf /etc/dhcpd6.conf"
    local.should == 0; remote.should == 0; command.should == 0
    local, remote, command = REF.test_and_drop_results \
      "root", "systemctl restart dhcpd6.service"
    local.should == 0; remote.should == 0; command.should == 0
  end

  # return to default NDP configuration, if needed
  local, remote, command = REF.test_and_drop_results \
    "testuser", "grep '# Default configuration' /etc/radvd.conf"
  local.should == 0; remote.should == 0
  if command != 0
    local, remote, command = REF.test_and_drop_results \
      "root", "ln -sf /etc/radvd-default.conf /etc/radvd.conf"
    local.should == 0; remote.should == 0; command.should == 0
    local, remote, command = REF.test_and_drop_results \
      "root", "systemctl restart radvd.service"
    local.should == 0; remote.should == 0; command.should == 0
  end

  # stop tcpdump, if needed
  out, local, remote, command = REF.test_and_store_results_together \
    "testuser", "ps aux"
  local.should == 0; remote.should == 0; command.should == 0
  if out.include? "tcpdump"
    local, remote, command = REF.test_and_drop_results \
      "root", "killproc /usr/sbin/tcpdump"
    local.should == 0; remote.should == 0; command.should == 0
  end
end

# Prepare the system under tests
# wicked is used to do that -- that sounds deeply wrong, but it appeared there was no way around
# besides, this code is very convoluted - again, no way around
def prepareSut()
  # stop openvpn if started
  out, local, remote, command = SUT.test_and_store_results_together \
    "testuser", "ps aux"
  local.should == 0; remote.should == 0; command.should == 0
  if out.include? "openvpn"
    local, remote, command = SUT.test_and_drop_results \
      "root", "systemctl stop openvpn@client"
    local.should == 0; remote.should == 0; command.should == 0
  end

  # stop tunnels if any
  out, local, remote, command = SUT.test_and_store_results_together \
    "testuser", "ip link show"
  local.should == 0; remote.should == 0; command.should == 0
  if out.include? "gre0@" or out.include? "tunl0@" or out.include? "sit0:"
    local, remote, command = SUT.test_and_drop_results \
      "root", "modprobe -r ip_gre gre ipip sit ip_tunnel tunnel4"
    local.should == 0; remote.should == 0; command.should == 0
  end

  # start wicked daemons
  local, remote, command = SUT.test_and_drop_results \
    "root", "systemctl start wickedd.service"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = SUT.test_and_drop_results \
    "root", "systemctl start wicked.service"
  local.should == 0; remote.should == 0; command.should == 0

  # delete bridges if any
  # not even sure it's needed
  # local, remote, command = SUT.test_and_drop_results \
  #   "root", "for bridge in \$(brctl show | sed '1d; s/\\t.*//; /^$/d'); do wicked ifdown --delete \$bridge; done"
  # local.should == 0; remote.should == 0; command.should == 0

  # ensure complete amnesia for wicked server
  local, remote, command = SUT.test_and_drop_results \
    "root", "wicked ifdown all"
# Used to be
#           "wicked ifdown --force device-down all"
  local.should == 0; remote.should == 0
  local, remote, command = SUT.test_and_drop_results \
    "root", "systemctl stop wickedd.service"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = SUT.test_and_drop_results \
    "root", "rm -rf /var/{run,lib}/wicked/*"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = SUT.test_and_drop_results \
    "root", "systemctl start wickedd.service"
  local.should == 0; remote.should == 0; command.should == 0

  # prepare tests directory and restart loopback interface
  local, remote, command = SUT.test_and_drop_results \
    "root", "rm -rf /tmp/tests"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote, command = SUT.test_and_drop_results \
    "testuser", "mkdir /tmp/tests"
  local.should == 0; remote.should == 0; command.should == 0
  local, remote = SUT.inject_file \
    "testuser", "test-files/global-config", "/tmp/tests/config", false
  local.should == 0; remote.should == 0
  local, remote = SUT.inject_file \
    "testuser", "test-files/loopback.ifcfg", "/tmp/tests/ifcfg-lo", false
  local.should == 0; remote.should == 0
  local, remote, command = SUT.test_and_drop_results \
    "root", "wicked ifup --ifconfig compat:/tmp/tests all"
  local.should == 0; remote.should == 0; command.should == 0
end
