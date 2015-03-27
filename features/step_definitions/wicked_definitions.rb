# Use configuration files for lower devices
if (ENV["CONFIGURE_LOWERDEVS"])
then
  CONFIGURE_LOWERDEVS = (ENV["CONFIGURE_LOWERDEVS"] == "true")
else
  CONFIGURE_LOWERDEVS = true
end

# Configure precisely the desired interface and not "all"
if (ENV["CONFIGURE_PRECISELY"])
then
  CONFIGURE_PRECISELY = (ENV["CONFIGURE_PRECISELY"] == "true")
else
  CONFIGURE_PRECISELY = false
end

# Target for system under test
if (ENV["TARGET_SUT"])
  TARGET_SUT = ENV["TARGET_SUT"]
else
  TARGET_SUT = "virtio:/var/run/twopence/suites-sut-SLES_12_SP0-86_64.sock"
end
puts "System under test is accessed through: " + TARGET_SUT
SUT = Twopence::init(TARGET_SUT)

# Target for reference server
if (ENV["TARGET_REF"])
  TARGET_REF = ENV["TARGET_REF"]
else
  TARGET_REF = "virtio:/var/run/twopence/suites-ref-openSUSE_13_1-x86_64.sock"
end
puts "Reference server is accessed through: " + TARGET_REF
REF = Twopence::init(TARGET_REF)

# Addresses for system under test
DHCP4_SUT0 = "10.20.30."
RADVD_SUT0 = "fd00:dead:beef:"
DHCP6_SUT0 = "fd00:c0ca:c01a:"
STAT4_SUT0 = "10.11.12.123/24"
STAT6_SUT0 = "fd00:cafe:babe::123/64"
STAT4_SUT1 = "172.16.0.123/16"
STAT6_SUT1 = "fd00:c0de:ba5e::123/48"
BOND4_SUT  = "192.168.50.123/24"
BOND6_SUT  = "fd00:deca:fbad:50::123/64"
V42_4_SUT  = "42.42.42.123/24"
V42_6_SUT  = "fd00:4242:4242::123/48"
V42_4_SUT1 = "42.42.42.223/24"
V42_6_SUT1 = "fd00:4242:4242::223/48"
BRID4_SUT1 = "172.16.100.200/16"
BRID6_SUT1 = "fd00:c0de:ba5e:100::200/48"
VTAP4_SUT1 = "172.16.17.18/16"
VTAP6_SUT1 = "fd00:c0de:ba5e:17::18/48"
OVPN4_SUT1 = "10.5.55.123/32"
OVPN6_SUT1 = "fd00:555:2368::123/128"
GRE_4_SUT1 = "2.2.2.123/32"
GRE_6_SUT1 = "fd00:222::123/128"
IPIP4_SUT1 = "3.3.3.123/32"
SIT_6_SUT1 = "fd00:333::123/128"
IBPA4_SUT  = "192.168.77.123"
IBPA6_SUT  = "fd00:deca:fbad:77::123/64"
IBCH4_SUT  = "192.168.88.123"
IBCH6_SUT  = "fd00:deca:fbad:88::123/64"
VLAN4_SUT0 = "172.16.1.123/16"
VLAN6_SUT0 = "fd00:c0de:ba5e:1::123/48"
VLAN4_SUT1 = "172.16.64.123/16"
VLAN6_SUT1 = "fd00:c0de:ba5e:1664::123/48"
V73_4_SUT  = "73.73.73.123/24"
V73_6_SUT  = "fd00:7373:7373::123/48"

# Addresses for reference server
DHCP4_REF0 = "10.20.30.1"
RADVD_REF0 = "fd00:dead:beef::1"
DHCP6_REF0 = "fd00:c0ca:c01a::1"
STAT4_REF0 = "10.11.12.1"
STAT6_REF0 = "fd00:cafe:babe::1"
STAT4_REF1 = "172.16.0.1"
STAT6_REF1 = "fd00:c0de:ba5e::1"
BOND4_REF  = "192.168.50.1"
BOND6_REF  = "fd00:deca:fbad:50::1"
V42_4_REF  = "42.42.42.1"
V42_6_REF  = "fd00:4242:4242::1"
OVPN4_REF1 = "10.5.55.1"
OVPN6_REF1 = "fd00:555:2368::1"
GRE_4_REF1 = "2.2.2.1"
GRE_6_REF1 = "fd00:222::1"
IPIP4_REF1 = "3.3.3.1"
SIT_6_REF1 = "fd00:333::1"
IBPA4_REF  = "192.168.77.1"
IBPA6_REF  = "fd00:deca:fbad:77::1"
IBCH4_REF  = "192.168.88.1"
IBCH6_REF  = "fd00:deca:fbad:88::1"
VLAN4_REF0 = "172.16.1.1"
VLAN6_REF0 = "fd00:c0de:ba5e:1::1"
VLAN4_REF1 = "172.16.64.1"
VLAN6_REF1 = "fd00:c0de:ba5e:1664::1"
V73_4_REF  = "73.73.73.1"
V73_6_REF  = "fd00:7373:7373::1"

# Addresses for outside world
STAT4_GAT = "192.168.1.1"                # Real gateway to the outside - adapt to your local setup!
STAT6_GAT = "fc00:a79:817:1::1"
STAT4_OUT = "10.161.0.1"                 # Some IP on your real network - adapt to your local setup!
STAT6_OUT = "2620:113:80c0:8000::1"

# WORKAROUND
# Prevents "systemctl stop wickedd.service" from getting stuck for 90 seconds
# (bsc#904921)
puts "Workaround against bsc#904921..."
SUT.test_and_drop_results \
  "sed -i \"/^Restart=/aKillSignal=SIGKILL\" /usr/lib/systemd/system/wickedd-nanny.service; systemctl daemon-reload"

