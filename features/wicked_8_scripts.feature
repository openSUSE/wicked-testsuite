Feature: Wicked 8 scripts

  In order to be able to set up network interfaces
  As a network administrator who needs to write networking scripts
  I should be able to use the new Wicked network interfaces broker

  Background:
    When the reference machine is set up correctly
    And the system under test is set up correctly
    And there is no core dump
    And the wicked services are started
    And the interfaces are in a basic state
    And the routing table is empty
    And there is no virtual interface left on any machine

  Scenario: Legacy ifcfg file calling systemd scripts
    When I set up systemd scripts for eth0 from legacy file
    And I bring up eth0 from legacy file
    And I bring down eth0
    Then the scripts output should be as expected

  Scenario: Wicked XML file calling systemd scripts
    When I set up systemd scripts for eth0 from XML file
    And I bring up eth0 from XML file
    And I bring down eth0
    Then the scripts output should be as expected

  Scenario: Legacy ifcfg file calling wicked scripts
    When I set up wicked scripts for eth0 from legacy file
    And I bring up eth0 from legacy file
    And I bring down eth0
    Then the scripts output should be as expected

  Scenario: Wicked XML file calling wicked scripts
    When I set up wicked scripts for eth0 from XML file
    And I bring up eth0 from XML file
    And I bring down eth0
    Then the scripts output should be as expected

  Scenario: Legacy ifcfg file calling compat scripts
    When I set up compat scripts for eth0 from legacy file
    And I bring up eth0 from legacy file
    And I bring down eth0
    Then the scripts output should be as expected

  Scenario: Wicked XML file calling compat scripts
    When I set up compat scripts for eth0 from XML file
    And I bring up eth0 from XML file
    And I bring down eth0
    Then the scripts output should be as expected

  Scenario: BOOTPROTO="static", scripts
    When I set up scripts for eth0 with BOOTPROTO="static"
    And I try to bring up eth0
    Then the post-up script should be called

 Scenario: BOOTPROTO="static", bad route, scripts
    When I set up scripts for eth0 with BOOTPROTO="static"
    And I declare a non-matching route for eth0
    And I try to bring up eth0
    Then the post-up script should not be called

  Scenario: No dhcp server, BOOTPROTO="dhcp4", scripts
    When I set up scripts for eth0 with BOOTPROTO="dhcp4"
    And dhcpd is switched off
    And I try to bring up eth0
    Then the post-up script should not be called

  Scenario: No dhcp6 server, BOOTPROTO="dhcp6", scripts
    When I set up scripts for eth0 with BOOTPROTO="dhcp6"
    And dhcpd6 is switched off
    And I try to bring up eth0
    Then the post-up script should not be called

  Scenario: No dhcp server, BOOTPROTO="dhcp", scripts
    When I set up scripts for eth0 with BOOTPROTO="dhcp"
    And dhcpd is switched off
    And I try to bring up eth0
    Then the post-up script should be called

  Scenario: No dhcp6 server, BOOTPROTO="dhcp", scripts
    When I set up scripts for eth0 with BOOTPROTO="dhcp"
    And dhcpd6 is switched off
    And I try to bring up eth0
    Then the post-up script should be called

  Scenario: No dhcp server, no dhcp6 server, BOOTPROTO="dhcp", scripts
    When I set up scripts for eth0 with BOOTPROTO="dhcp"
    And dhcpd is switched off
    And dhcpd6 is switched off
    And I try to bring up eth0
    Then the post-up script should not be called

