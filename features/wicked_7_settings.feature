Feature: Wicked 7 settings

  In order to be able to set up network interfaces
  As a network administrator who plays with the network settings
  I should be able to use the new Wicked network interfaces broker

  Background:
    When the reference machine is set up correctly
    And the system under test is set up correctly
    And there is no core dump
    And the network services are started
    And the interfaces are in a basic state
    And the routing table is empty
    And there is no virtual interface left on any machine

  # All the tests below assume that eth0 is set by default with DHCP and RADVD

  Scenario: Set up DNS with static declaration and DHCPv4
    When I bring up eth0
    Then I should have the statically declared DNS server
    And I should obtain a DNS server by DHCPv4

  Scenario: Set up DNS only with static declaration
    When I bring up eth0
    And I bring down eth0
    Then I should have the statically declared DNS server
    But I should not obtain a DNS server by DHCPv4

  Scenario: Set up the MTU with DHCP
    When I set up the MTU on the reference server
    And I bring up eth0
    Then I should have the correct MTU on eth0

  Scenario: Release DHCP addresses when requested
    When the DHCP client has to release the leases at the end
    And I sniff DHCP on the reference machine
    And I bring up eth0
    And I bring down eth0
    Then the capture file should contain a DHCP release

  Scenario: Do not release DHCP addresses when not requested
    When the DHCP client has to keep the leases at the end
    And I sniff DHCP on the reference machine
    And I bring up eth0
    And I bring down eth0
    Then the capture file should not contain a DHCP release

  Scenario: Set up ethtool options
    Given the system under tests in running on real hardware
    When I set up the speed of eth0 to 10 Mbit/s
    Then the speed of eth0 should be 10 Mbit/s
    #
    When I set up the speed of eth0 to 100 Mbit/s
    Then the speed of eth0 should be 100 Mbit/s
    #
    When I set up the speed of eth0 to 1000 Mbit/s
    Then the speed of eth0 should be 1000 Mbit/s

#  Scenario: Use autoip option
#    When I set up eth0 with autoip option
#    Then I should obtain a link-local IPv4 address
#    But I should not obtain an address by DHCPv4

#  Scenario: Use dhcp+autoip option
#    When I set up eth0 with dhcp+autoip option
#    Then I should not obtain a link-local IPv4 address
#    But I should obtain an address by DHCPv4

#  Scenario: No dhcpd server, use dhcp+autoip option
#    When I set up eth0 with dhcp+autoip option
#    And dhcpd is switched off
#    Then I should obtain a link-local IPv4 address
#    But I should not obtain an address by DHCPv4

