Feature: Wicked 4 combinations

  In order to be able to set up network interfaces
  As a network administrator doing weird combinations
  I should be able to use the new Wicked network interfaces broker

  Background:
    When the reference machine is set up correctly
    And the system under test is set up correctly
    And there is no core dump
    And the wicked services are started
    And the interfaces are in a basic state
    And the routing table is empty
    And there is no virtual interface left on any machine

  Scenario: vlan{bridge{Ethernet, dummy}} from legacy ifcfg files
    When I create br0.1(br0(eth0, dummy0), 1) from legacy files
    Then br0.1 should have the correct address
    And I should be able to ping eth0.1 on the other side

  Scenario: vlan{bridge{Ethernet}, dummy}} from wicked XML files
    When I create br0.1(br0(eth0, dummy0), 1) from XML files
    Then br0.1 should have the correct address
    And I should be able to ping eth0.1 on the other side

  Scenario: bridge{vlan{Ethernet}, Ethernet} from legacy ifcfg files
    When I create br0(eth0.1(eth0, 1), eth1) from legacy files
    Then br0 should have the correct address
    And I should be able to ping eth0.1 on the other side
    And I should be able to ping eth1 on the other side

  Scenario: bridge{vlan{Ethernet}, Ethernet} from wicked XML files
    When I create br0(eth0.1(eth0, 1), eth1) from XML files
    Then br0 should have the correct address
    And I should be able to ping eth0.1 on the other side
    And I should be able to ping eth1 on the other side

  Scenario: bridge{vlan{Ethernet}, vlan{Ethernet}} from legacy ifcfg files
    When I create br0(eth0.1(eth0, 1), eth1.1(eth1, 1)) from legacy files
    Then br0 should have the correct address
    And I should be able to ping eth0.1 on the other side
    And I should be able to ping eth1.1 on the other side

  Scenario: bridge{vlan{Ethernet}, vlan{Ethernet}} from wicked XML files
    When I create br0(eth0.1(eth0, 1), eth1.1(eth1, 1)) from XML files
    Then br0 should have the correct address
    And I should be able to ping eth0.1 on the other side
    And I should be able to ping eth1.1 on the other side

#  Scenario: bond{vlan{Ethernet}, vlan{Ethernet}} from legacy ifcfg files
#    When I create bond1(eth0.1(eth0, 1), eth1.1(eth1, 1)) from legacy files
#    Then bond1 should have the correct address
#    And I should be able to ping bond1 on the other side
#
#  Scenario: bond{vlan{Ethernet}, vlan{Ethernet}} from wicked XML files
#    When I create bond1(eth0.1(eth0, 1), eth1.1(eth1, 1)) from XML files
#    Then bond1 should have the correct address
#    And I should be able to ping bond1 on the other side

  Scenario: bridge{bond{Ethernet, Ethernet}, dummy} from legacy ifcfg files
    When I create br1(bond0(eth0, eth1), dummy1) from legacy files
    Then br1 should have the correct address
    And I should be able to ping bond0 on the other side

  Scenario: bridge{bond{Ethernet, Ethernet}, dummy} from wicked XML files
    When I create br1(bond0(eth0, eth1), dummy1) from XML files
    Then br1 should have the correct address
    And I should be able to ping bond0 on the other side

  Scenario: vlan{bridge{bond{Ethernet, Ethernet}, dummy}} from legacy ifcfg files
    When I create br1.42(br1(bond0(eth0, eth1), dummy1), 42) from legacy files
    Then br1.42 should have the correct address
    And I should be able to ping bond0.42 on the other side

  Scenario: vlan{bridge{bond{Ethernet, Ethernet}, dummy}} from wicked XML files
    When I create br1.42(br1(bond0(eth0, eth1), dummy1), 42) from XML files
    Then br1.42 should have the correct address
    And I should be able to ping bond0.42 on the other side

  Scenario: vlan{bond{Ethernet, Ethernet}}, vlan{same bond} from legacy ifcfg files
    When I create bond0.42(bond0(eth0, eth1), 42) and bond0.73(bond0, 73) from legacy files
    Then bond0.42 should have the correct address
    And bond0.73 should have the correct address
    And I should be able to ping bond0.42 on the other side
    And I should be able to ping bond0.73 on the other side

  Scenario: vlan{bond{Ethernet, Ethernet}}, vlan{same bond} from wicked XML files
    When I create bond0.42(bond0(eth0, eth1), 42) and bond0.73(bond0, 73) from XML files
    Then bond0.42 should have the correct address
    And bond0.73 should have the correct address
    And I should be able to ping bond0.42 on the other side
    And I should be able to ping bond0.73 on the other side

  Scenario: bridge{vlan{bond{Ethernet, Ethernet}}, dummy}, bridge{vlan{same bond}, dummy} from legacy ifcfg files
    When I create br42(bond0.42(bond0(eth0, eth1), 42), dummy0) and br73(bond0.73(bond0, 73), dummy1) from legacy files
    Then br42 should have the correct address
    And br73 should have the correct address
    And I should be able to ping bond0.42 on the other side
    And I should be able to ping bond0.73 on the other side

  Scenario: bridge{vlan{bond{Ethernet, Ethernet}}, dummy}, bridge{vlan{same bond}, dummy} from wicked XML files
    When I create br42(bond0.42(bond0(eth0, eth1), 42), dummy0) and br73(bond0.73(bond0, 73), dummy1) from XML files
    Then br42 should have the correct address
    And br73 should have the correct address
    And I should be able to ping bond0.42 on the other side
    And I should be able to ping bond0.73 on the other side

  Scenario: vlan{Ethernet}, bridge{same nic}, vlan{same nic} from legacy ifcfg files
    When I create eth0.1(eth0, 1) and br2(eth0) and eth0.42(eth0, 42) from legacy files
    Then eth0.1 should have the correct address
    And br2 should have the correct address
    And eth0.42 should have the correct address
    And I should be able to ping eth0.1 on the other side
    And I should be able to ping br2 on the other side
    And I should be able to ping eth0.42 on the other side

  Scenario: vlan{Ethernet}, bridge{same nic}, vlan{same nic} from wicked XML files
    When I create eth0.1(eth0, 1) and br2(eth0) and eth0.42(eth0, 42) from XML files
    Then eth0.1 should have the correct address
    And br2 should have the correct address
    And eth0.42 should have the correct address
    And I should be able to ping eth0.1 on the other side
    And I should be able to ping br2 on the other side
    And I should be able to ping eth0.42 on the other side

  Scenario: ovsbridge{ovsbridge{Ethernet, Ethernet} tagged, dummy}
    When I create ovsbr1((ovsbr0(eth0, eth1), 1), dummy1)
    Then ovsbr1 should have the correct address
    And I should be able to ping eth0.1 on the other side

