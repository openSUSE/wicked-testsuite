Feature: Wicked 5 start and stop

  In order to be able to set up network interfaces
  As a network administrator who starts and stops interfaces
  I should be able to use the new Wicked network interfaces broker

  Background:
    When the reference machine is set up correctly
    And the system under test is set up correctly
    And there is no core dump
    And the wicked services are started
    And the interfaces are in a basic state
    And the routing table is empty
    And there is no virtual interface left on any machine

  Scenario: Ethernet - legacy file calling systemd scripts
    When I set up systemd scripts for eth0 from legacy file
    And I bring up eth0 from legacy file
    And I bring down eth0
    Then the scripts output should be as expected

  Scenario: Ethernet - XML file calling systemd scripts
    When I set up systemd scripts for eth0 from XML file
    And I bring up eth0 from XML file
    And I bring down eth0
    Then the scripts output should be as expected

  Scenario: Ethernet - legacy file calling wicked scripts
    When I set up wicked scripts for eth0 from legacy file
    And I bring up eth0 from legacy file
    And I bring down eth0
    Then the scripts output should be as expected

  Scenario: Ethernet - XML file calling wicked scripts
    When I set up wicked scripts for eth0 from XML file
    And I bring up eth0 from XML file
    And I bring down eth0
    Then the scripts output should be as expected

  Scenario: Ethernet - legacy file calling compat scripts
    When I set up compat scripts for eth0 from legacy file
    And I bring up eth0 from legacy file
    And I bring down eth0
    Then the scripts output should be as expected

  Scenario: Ethernet - XML file calling compat scripts
    When I set up compat scripts for eth0 from XML file
    And I bring up eth0 from XML file
    And I bring down eth0
    Then the scripts output should be as expected

  Scenario: Bridge - ifreload
    When I create a bridge on interface eth1 from legacy files by ifreload
    Then there should be a new br1 card
    And there should be a new dummy1 card
    And the bridge should have the correct address
    And I should be able to ping through the bridge

  Scenario: Bridge - ifup, ifreload
    When I create a bridge on interface eth1 from legacy files
    And I bring up all by ifreload
    Then there should be a new br1 card
    And there should be a new dummy1 card
    And the bridge should have the correct address
    And I should be able to ping through the bridge

  Scenario: Bridge - ifup, remove all config, ifreload
    When I create a bridge on interface eth1 from legacy files
    Then I delete the config file for br1
    And I delete the config file for dummy1
    And I delete the config file for eth1
    #
    When I bring up all by ifreload
    Then there should not be the br1 card anymore
    And there should not be the dummy1 card anymore

  Scenario: Bridge - ifup, remove one config, ifreload
    When I create a bridge on interface eth1 from legacy files
    Then I delete the config file for br1
    #
    When I bring up all by ifreload
    Then there should not be the br1 card anymore
    But the dummy1 card should still be there
    And the eth1 card should still be there

  Scenario: Standalone card - ifdown, ifreload
    When I set up dynamic IP addresses for eth0 from legacy files
    And I bring down eth0
    And I bring up eth0 by ifreload
    Then eth0 should use the dynamic addresses
    But eth0 should not use the static addresses
    And I should be able to ping a reference machine from my dynamic address

  Scenario: VLAN - ifdown, modify config, ifreload
    When I create a VLAN on interface eth1 from legacy files
    And I bring down eth1.42
    And I change VLAN config and ifreload
    Then both machines should have a new eth1.42 card
    And I should be able to ping the other side of the VLAN

  Scenario: Bridge - ifdown, create new config, ifreload, ifdown, ifup
    When I create a bridge on interface eth1 from legacy files
    And I bring down br1
    And I bring down dummy1
    Then there should not be the br1 card anymore
    And there should not be the dummy1 card anymore
    #
    When I create a bridge on interface eth1 from legacy files by ifreload
    Then there should be a new br1 card
    And there should be a new dummy1 card
    And the bridge should have the correct address
    And I should be able to ping through the bridge
    #
    When I bring down all
    And I bring up all
    Then I should be able to ping a reference machine from my dynamic address

  Scenario: Bridge - ifdown, remove one config, ifreload, ifdown, ifup
    When I create a bridge on interface eth1 from legacy files
    And I bring down br1
    And I bring down dummy1
    Then there should not be the br1 card anymore
    And there should not be the dummy1 card anymore
    #
    When I delete the config file for br1
    And I bring up all by ifreload
    Then there should not be the br1 card anymore
    But the dummy1 card should still be there
    And the eth1 card should still be there
    #
    When I bring down all
    And I bring up all
    And I should be able to ping a reference machine from my dynamic address

  Scenario: VLAN - ifdown, modify one config, ifreload, ifdown, ifup
    When I create a VLAN on interface eth1 from legacy files
    And I bring down eth1.42
    Then there should not be the eth1.42 card anymore
    #
    When I change VLAN config and ifreload
    Then both machines should have a new eth1.42 card
    And I should be able to ping the other side of the VLAN
    #
    When I bring down all
    Then I bring up all
    And I should be able to ping a reference machine from my dynamic address

  Scenario: VLAN - ifup all, ifdown one card
    When I create a VLAN on interface eth0 from legacy files
    And I bring up all
    Then I bring down eth0.42
    And there should not be the eth0.42 card anymore
    But the eth0 card should still be there

  Scenario: Complex layout - ifup twice
    When I create br1.42(br1(bond0(eth0, eth1), dummy1), 42) from legacy files
    And I bring up br1.42 from legacy file
    Then br1.42 should have the correct address
    And I should be able to ping bond0.42 on the other side

  Scenario: Complex layout - ifup 3 times
    When I create br1.42(br1(bond0(eth0, eth1), dummy1), 42) from legacy files
    And I bring up br1.42 from legacy file
    And I bring up br1.42 from legacy file
    Then br1.42 should have the correct address
    And I should be able to ping bond0.42 on the other side

  Scenario: Complex layout - ifdown
    When I create br1.42(br1(bond0(eth0, eth1), dummy1), 42) from legacy files
    And I bring down br1.42
    Then there should not be the br1.42 card anymore
    But the br1 card should still be there
    And the bond0 card should still be there
    And the dummy1 card should still be there

  Scenario: Complex layout - ifdown twice
    When I create br1.42(br1(bond0(eth0, eth1), dummy1), 42) from legacy files
    And I bring down br1.42
    And I bring down br1.42
    Then there should not be the br1.42 card anymore
    But the br1 card should still be there
    And the bond0 card should still be there
    And the dummy1 card should still be there

  Scenario: Complex layout - ifdown 3 times
    When I create br1.42(br1(bond0(eth0, eth1), dummy1), 42) from legacy files
    And I bring down br1.42
    And I bring down br1.42
    And I bring down br1.42
    Then there should not be the br1.42 card anymore
    But the br1 card should still be there
    And the bond0 card should still be there
    And the dummy1 card should still be there

  Scenario: Complex layout - ifreload
    When I create br1.42(br1(bond0(eth0, eth1), dummy1), 42) from legacy files
    And I bring up br1.42 by ifreload
    Then br1.42 should have the correct address
    And I should be able to ping bond0.42 on the other side

  Scenario: Complex layout - ifreload twice
    When I create br1.42(br1(bond0(eth0, eth1), dummy1), 42) from legacy files
    And I bring up br1.42 by ifreload
    And I bring up br1.42 by ifreload
    Then br1.42 should have the correct address
    And I should be able to ping bond0.42 on the other side

  Scenario: Complex layout - ifreload, config change, ifreload
    When I create br1.42(br1(bond0(eth0, eth1), dummy1), 42) from legacy files
    And I bring up br1.42 by ifreload
    Then I delete the config file for br1.42
    And I bring up br1.42 by ifreload
    Then there should not be the br1.42 card anymore
    But the br1 card should still be there
    And the bond0 card should still be there
    And the dummy1 card should still be there

  Scenario: Complex layout - ifup, ifstatus
    When I create br1.42(br1(bond0(eth0, eth1), dummy1), 42) from legacy files
    And I show a brief status of all
    Then the brief status of br1.42 should be "up"
    And the brief status of br1 should be "up"
    And the brief status of bond0 should be "enslaved"
    And the brief status of dummy1 should be "enslaved"
    And the brief status of eth0 should be "enslaved"
    And the brief status of eth1 should be "enslaved"

  Scenario: Complex layout - ifup, ifstatus, ifdown, ifstatus
    When I create br1.42(br1(bond0(eth0, eth1), dummy1), 42) from legacy files
    And I show a brief status of all
    Then the brief status of br1.42 should be "up"
    And the brief status of br1 should be "up"
    And the brief status of bond0 should be "enslaved"
    And the brief status of dummy1 should be "enslaved"
    And the brief status of eth0 should be "enslaved"
    And the brief status of eth1 should be "enslaved"
    #
    When I bring down br1.42
    And I show a brief status of all 
    Then the brief status of br1 should be "up"
    And the brief status of bond0 should be "enslaved"
    And the brief status of dummy1 should be "enslaved"
    And the brief status of eth0 should be "enslaved"
    And the brief status of eth1 should be "enslaved"
    But the brief status of br1.42 should not be "up"

  Scenario: SIT tunnel - ifdown
    When I create a sit interface from legacy files
    Then both machines should have a new sit1 card
    #
    When I bring down sit1
    Then there should not be the sit1 card anymore

#  Scenario: Create many bridges and remove them
#    When I create 512 bridges
#    Then all 512 bridges should be UP
#    And netlink messages should not contain "No buffer space"
#    #
#    When I delete 512 bridges
#    Then all 512 bridges should be deleted

