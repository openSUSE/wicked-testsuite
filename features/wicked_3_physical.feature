Feature: Wicked 3 physical

  In order to be able to set up network interfaces
  As a network administrator using a wide range of hardware
  I should be able to use the new Wicked network interfaces broker

  Background:
#    When the reference machine is set up correctly
#    And the system under test is set up correctly
#    And there is no core dump
#    And the wicked services are started
#    And the interfaces are in a basic state
#    And the routing table is empty
#    And there is no virtual interface left on any machine

# all infiniband tests with dhcpv4 and dhcpv6
  Scenario: Create an infiniband interface from legacy ifcfg files, unreliable datagram mode
    Given infiniband is supported on both machines
    When I create an infiniband interface in datagram mode from legacy files
#    Then both machines should have a new ib0 card
    And I should be able to ping the other side of the infiniband link

  Scenario: Create an infiniband interface from wicked XML files, unreliable datagram mode
    Given infiniband is supported on both machines
    When I create an infiniband interface in datagram mode from XML files
#    Then both machines should have a new ib0 card
    And I should be able to ping the other side of the infiniband link

  Scenario: Create an infiniband interface from legacy ifcfg files, connected mode
    Given infiniband is supported on both machines
    When I create an infiniband interface in connected mode from legacy files
#    Then both machines should have a new ib0 card
    And I should be able to ping the other side of the infiniband link

  Scenario: Create an infiniband interface from wicked XML files, connected mode
    Given infiniband is supported on both machines
    When I create an infiniband interface in connected mode from XML files
#    Then both machines should have a new ib0 card
    And I should be able to ping the other side of the infiniband link

# what about the multicast flag?

  Scenario: Create an infiniband child interface from legacy ifcfg files
    Given infiniband is supported on both machines

  Scenario: Create an infiniband child interface from wicked XML files
    Given infiniband is supported on both machines

  Scenario: Use infiniband bonding
    Given infiniband is supported on both machines


# especially dhcp with ib-bond is interessting as the mac changes when bond changes to another nic.
# ask pth@suse.de -- perhaps there is a multiport one and we initialize only 1 port by default.

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
# Network boot parameters
# * ibft
#
#
# PRIORITIES
# ==========
#
# Important/supported interfaces are, in decreasing order of priority:
#     Ethernet, vlan, bridge, bond
#     ibft, infiniband + child
#     wireless, sit, gre, ipip
#     pppoe

