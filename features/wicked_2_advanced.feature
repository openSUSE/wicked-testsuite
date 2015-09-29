Feature: Wicked 2 advanced

  In order to be able to set up network interfaces
  As a SLES 12 advanced user
  I should be able to use the new Wicked network interfaces broker

  Background:
    When the reference machine is set up correctly
    And the system under test is set up correctly
    And there is no core dump
    And the network services are started
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
    # WORKAROUND to problem with virtualization
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

  Scenario: Create an OVS bridge from legacy ifcfg files
    When I create an OVS bridge from legacy files
    Then there should be a new ovsbr1 card
    And eth1 should be part of the OVS bridge
    And dummy1 should be part of the OVS bridge
    And the OVS bridge should have the correct address
    And I should be able to ping through the OVS bridge

  Scenario: Create an OVS bridge from wicked XML files
    When I create an OVS bridge from XML files
    Then there should be a new ovsbr1 card
    And eth1 should be part of the OVS bridge
    And dummy1 should be part of the OVS bridge
    And the OVS bridge should have the correct address
    And I should be able to ping through the OVS bridge

  Scenario: Create a team interface from legacy ifcfg files
    When I team together eth0 and eth1 from legacy files
    Then there should be a new team0 card
    And eth0 should be part of the team
    And eth1 should be part of the team
    And I should be able to ping the other side of the aggregated link

  Scenario: Create a team interface from wicked XML files
    When I team together eth0 and eth1 from XML files
    Then there should be a new team0 card
    And eth0 should be part of the team
    And eth1 should be part of the team
    And I should be able to ping the other side of the aggregated link

  Scenario: Create a tun interface from legacy ifcfg files
    When I create a tun interface from legacy files
    Then both machines should have a new tun1 card
    And I should be able to ping the other side of the layer 3 tunnel

  Scenario: Create a tun interface from wicked XML files
    When I create a tun interface from XML files
    Then both machines should have a new tun1 card
    And I should be able to ping the other side of the layer 3 tunnel

#TODO: test for tun owner and group (boo#899985)

  Scenario: Create a tap interface from legacy ifcfg files
    When I create a tap interface from legacy files
    Then both machines should have a new tap1 card
    And I should be able to ping the other side of the layer 2 tunnel

  Scenario: Create a tap interface from wicked XML files
    When I create a tap interface from XML files
    Then both machines should have a new tap1 card
    And I should be able to ping the other side of the layer 2 tunnel

#TODO: test for tap owner and group (boo#899985)

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

  Scenario: Create a sit interface from legacy ifcfg files
    When I create a sit interface from legacy files
    And I establish routes for the SIT tunnel
    Then both machines should have a new sit1 card
    And I should be able to ping the other side of the SIT tunnel

  Scenario: Create a sit interface from wicked XML files
    When I create a sit interface from XML files
    And I establish routes for the SIT tunnel
    Then both machines should have a new sit1 card
    And I should be able to ping the other side of the SIT tunnel

# TODO
# ====
#
# Point to point
# * ppp with null-modem serial line (not written)
# * ppp with plain old serial modems (not written)
# * ppp with 3G usb sticks and newer modems (not testable with QEmu)
# * pppoe
# * slip
#
# Tunnel
# * ip6ip6 IPv6 in IPv6 tunnel
