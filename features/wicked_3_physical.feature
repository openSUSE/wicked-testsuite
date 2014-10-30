Feature: Wicked 3 physical

  In order to be able to set up network interfaces
  As a network administrator using a wide range of hardware
  I should be able to use the new Wicked network interfaces broker

  Background:
    When the reference machine is set up correctly
    And the system under test is set up correctly
    And there is no core dump
    And the wicked services are started
    And the interfaces are in a basic state
    And the routing table is empty
    And there is no virtual interface left on any machine

# all infiniband tests with dhcp
  Scenario: Create an infiniband interface from legacy ifcfg files, unreliable datagram mode

  Scenario: Create an infiniband interface from wicked XML files, unreliable datagram mode

  Scenario: Create an infiniband interface from legacy ifcfg files, connected mode

  Scenario: Create an infiniband interface from wicked XML files, connected mode

  Scenario: Create an infiniband child interface from legacy ifcfg files

  Scenario: Create an infiniband child interface from wicked XML files

  Scenario: Use infiniband bonding

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

