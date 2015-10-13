Feature: Wicked 9 aggregation

  In order to be able to set up network interfaces
  As a network administrator with particular interest in teaming and bonding
  I should be able to use the new Wicked network interfaces broker

  Background:
    When the reference machine is set up correctly
    And the system under test is set up correctly
    And there is no core dump
    And the network services are started
    And the interfaces are in a basic state
    And the routing table is empty
    And there is no virtual interface left on any machine

  Scenario: Bonding, balance-rr
    When I bond together eth0 and eth1 in balance-rr mode
    Then there should be a new bond0 card
    And eth0 should be slave of bond0
    And eth1 should be slave of bond0
    And I should be able to ping the other side of the aggregated link

  Scenario: Bonding, active-backup
    When I bond together eth0 and eth1 in active-backup mode
    Then there should be a new bond0 card
    And eth0 should be slave of bond0
    And eth1 should be slave of bond0
    And I should be able to ping the other side of the aggregated link

  Scenario: Bonding, balance-xor
    When I bond together eth0 and eth1 in balance-xor mode
    Then there should be a new bond0 card
    And eth0 should be slave of bond0
    And eth1 should be slave of bond0
    And I should be able to ping the other side of the aggregated link

  Scenario: Bonding, broadcast
    When I bond together eth0 and eth1 in broadcast mode
    Then there should be a new bond0 card
    And eth0 should be slave of bond0
    And eth1 should be slave of bond0
    And I should be able to ping the other side of the aggregated link

  Scenario: Bonding, 802.3ad
    When I bond together eth0 and eth1 in 802.3ad mode
    Then there should be a new bond0 card
    And eth0 should be slave of bond0
    And eth1 should be slave of bond0
    And I should be able to ping the other side of the aggregated link

  Scenario: Bonding, balance-tlb
    When I bond together eth0 and eth1 in balance-tlb mode
    Then there should be a new bond0 card
    And eth0 should be slave of bond0
    And eth1 should be slave of bond0
  #  And I should be able to ping the other side of the aggregated link

  Scenario: Bonding, balance-alb
    When I bond together eth0 and eth1 in balance-alb mode
    Then there should be a new bond0 card
    And eth0 should be slave of bond0
    And eth1 should be slave of bond0
  #  And I should be able to ping the other side of the aggregated link

  @teams
  Scenario: Teaming, roundrobin
    When I team together eth0 and eth1 in roundrobin mode
    Then there should be a new team0 card
    And eth0 should be slave of team0
    And eth1 should be slave of team0
    And I should be able to ping the other side of the aggregated link

  @teams
  Scenario: Teaming, random
    When I team together eth0 and eth1 in random mode
    Then there should be a new team0 card
    And eth0 should be slave of team0
    And eth1 should be slave of team0
    And I should be able to ping the other side of the aggregated link

  @teams
  Scenario: Teaming, activebackup
    When I team together eth0 and eth1 in activebackup mode
    Then there should be a new team0 card
    And eth0 should be slave of team0
    And eth1 should be slave of team0
    And I should be able to ping the other side of the aggregated link

  @teams
  Scenario: Teaming, broadcast
    When I team together eth0 and eth1 in broadcast mode
    Then there should be a new team0 card
    And eth0 should be slave of team0
    And eth1 should be slave of team0
    And I should be able to ping the other side of the aggregated link

  @teams
  Scenario: Teaming, loadbalance
    When I team together eth0 and eth1 in broadcast mode
    Then there should be a new team0 card
    And eth0 should be slave of team0
    And eth1 should be slave of team0
    And I should be able to ping the other side of the aggregated link

  @teams
  Scenario: Teaming, lacp
    When I team together eth0 and eth1 in lacp mode
    Then there should be a new team0 card
    And eth0 should be slave of team0
    And eth1 should be slave of team0
    And I should be able to ping the other side of the aggregated link

  # The following tests assume eth1 is the primary interface:

  @teams
  Scenario: Teaming, activebackup, ethtool
    When I team together eth0 and eth1 with ethtool link watcher
    Then there should be a new team0 card
    And eth1 should be the active link
    #
    When I cut eth1's link
    Then eth0 should be the active link
    And I should be able to ping the other side of the aggregated link

  @teams
  Scenario: Teaming, activebackup, arp_ping
    When I team together eth0 and eth1 with arp_ping link watcher
    Then there should be a new team0 card
    And eth1 should be the active link
    #
    When I cut eth1's link
    Then eth0 should be the active link
    And I should be able to ping the other side of the aggregated link

  @teams
  Scenario: Teaming, activebackup, nsna_ping
    When I team together eth0 and eth1 with arp_ping link watcher
    Then there should be a new team0 card
    And eth1 should be the active link
    #
    When I cut eth1's link
    Then eth0 should be the active link
    And I should be able to ping the other side of the aggregated link

  @teams
  Scenario: Teaming, activebackup, all link watchers
    When I team together eth0 and eth1 with all link watchers
    Then there should be a new team0 card
    And eth1 should be the active link
    #
    When I cut eth1's link
    Then eth0 should be the active link
    And I should be able to ping the other side of the aggregated link

