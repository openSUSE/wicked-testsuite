Feature: Wicked 2 advanced

  In order to be able to set up network interfaces
  As a SLES 12 advanced user
  I should be able to use the new Wicked network interfaces broker

  Background:
    When the reference machine is set up correctly
    And the system under test is set up correctly
    And there is no core dump
    And the wicked services are started
    And the interfaces are in a basic state
    And the routing table is empty
    And there is no virtual interface left on any machine

  Scenario: Aggregate both cards from legacy ifcfg files
    When I aggregate eth0 and eth1 from legacy files
    Then both machines should have a new bond0 card
    And eth0 should be enslaved
    And eth1 should be enslaved
    And I should be able to ping the other side of the aggregated link

  Scenario: Aggregate both cards from wicked XML files
    When I aggregate eth0 and eth1 from XML files
    Then both machines should have a new bond0 card
    And eth0 should be enslaved
    And eth1 should be enslaved
    And I should be able to ping the other side of the aggregated link

  Scenario: Hotplug constituants of aggregated links
    Given nanny is enabled
    # WORKAROUND
    And the system under tests in running on real hardware
    When I aggregate eth0 and eth1 from legacy files
    And I deconnect violently eth1
    And I reconnect eth1
    Then eth1 should be enslaved
    And I should be able to ping the other side of the aggregated link

  Scenario: Create a VLAN from legacy ifcfg files
    When I create a VLAN on interface eth1 from legacy files
    Then both machines should have a new eth1.42 card
    And I should be able to ping the other side of the VLAN

  Scenario: Create a VLAN from wicked XML files
    When I create a VLAN on interface eth1 from XML files
    Then both machines should have a new eth1.42 card
    And I should be able to ping the other side of the VLAN

  Scenario: Create a bridge from legacy ifcfg files
    When I create a bridge on interface eth1 from legacy files
    Then there should be a new br1 card
    And there should be a new dummy1 card
    And the bridge should have the correct address
    And I should be able to ping through the bridge

  Scenario: Create a bridge from wicked XML files
    When I create a bridge on interface eth1 from XML files
    Then there should be a new br1 card
    And there should be a new dummy1 card
    And the bridge should have the correct address
    And I should be able to ping through the bridge

  Scenario: Create a macvtap interface from legacy ifcfg files
    When I create a macvtap interface from legacy files
    And I send an ARP ping to the reference machine
    Then there should be a new macvtap1 card
    And the macvtap interface should have the correct address
    And I should receive the answer of the ARP ping on /dev/tapX

  Scenario: Create a macvtap interface from wicked XML files
    When I create a macvtap interface from XML files
    And I send an ARP ping to the reference machine
    Then there should be a new macvtap1 card
    And the macvtap interface should have the correct address
    And I should receive the answer of the ARP ping on /dev/tapX

  Scenario: Create a tun interface from legacy ifcfg files
    When I create a tun interface from legacy files
    And I start openvpn in tun mode on both machines
    Then both machines should have a new tun1 card
    And I should be able to ping the other side of the layer 3 tunnel

  Scenario: Create a tun interface from wicked XML files
    When I create a tun interface from XML files
    And I start openvpn in tun mode on both machines
    Then both machines should have a new tun1 card
    And I should be able to ping the other side of the layer 3 tunnel

  Scenario: Create a tap interface from legacy ifcfg files
    When I create a tap interface from legacy files
    And I start openvpn in tap mode on both machines
    Then both machines should have a new tap1 card
    And I should be able to ping the other side of the layer 2 tunnel

  Scenario: Create a tap interface from wicked XML files
    When I create a tap interface from XML files
    And I start openvpn in tap mode on both machines
    Then both machines should have a new tap1 card
    And I should be able to ping the other side of the layer 2 tunnel

  Scenario: Create a gre interface from legacy ifcfg files
    When I create a gre interface from legacy files
    And I establish routes for the GRE tunnel
    Then both machines should have a new gre1 card
    And I should be able to ping the other side of the GRE tunnel

  Scenario: Create a gre interface from wicked XML files
    When I create a gre interface from XML files
    And I establish routes for the GRE tunnel
    Then both machines should have a new gre1 card
    And I should be able to ping the other side of the GRE tunnel

  Scenario: Create a tunl interface from legacy ifcfg files
    When I create a tunl interface from legacy files
    And I establish routes for the IPIP tunnel
    Then both machines should have a new tunl1 card
    And I should be able to ping the other side of the IPIP tunnel

  Scenario: Create a tunl interface from wicked XML files
    When I create a tunl interface from XML files
    And I establish routes for the IPIP tunnel
    Then both machines should have a new tunl1 card
    And I should be able to ping the other side of the IPIP tunnel

# TODO
# ====
#
# Physical (not testable with QEmu)
# * wlan WiFi interfaces
# * isdn telephone interfaces
# * infiniband
# * token ring
# * firewire
# * ctcm s390 mainframes
# * iucv s390 mainframes
#
# Point to point
# * ppp with null-modem serial line (not written)
# * ppp with plain old serial modems (not written)
# * ppp with 3G usb sticks and newer modems (not testable with QEmu)
# * pppoe
# * slip
#
# Tunnels
# * ip6ip6 ip6 in ip6
# * sit ip4 in ip6
#
# Other virtual
# * macvlan several MAC addresses on same card
#
# Important/supported interfaces are, in decreasing order of priority:
#     Ethernet, vlan, bridge, bond
#     ibft, infiniband + child
#     wireless, sit, gre, ipip
#     pppoe

