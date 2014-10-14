Feature: Wicked 1 basic

  In order to be able to set up network interfaces
  As a SLES 12 basic user
  I should be able to use the new Wicked network interfaces broker

  Background:
    When the reference machine is set up correctly
    And the system under test is set up correctly
    And there is no core dump
    And the wicked services are started
    And the interfaces are in a basic state
    And the routing table is empty
    And there is no virtual interface left on any machine

  Scenario: Bring down the wicked client service
    When I stop the wicked client service
    Then all server daemons should be up and running
    And the interface eth0 should be down
    And the interface eth1 should be down

  Scenario: Bring up the wicked client service
    When I stop the wicked client service
    And I start the wicked client service
    Then the interface eth0 should be up and running
    And the interface eth1 should be up and running

  Scenario: Bring down the wicked server service
    When I stop the wicked server service
    Then no more server daemon should be left
    And I should not be able to bring up interface eth0

  Scenario: Bring up the wicked server service
    When I stop the wicked server service
    And I start the wicked server service
    Then all server daemons should be up and running
    And I should be able to bring up interface eth0

  Scenario: List the network interfaces with wicked
    When I ask to see all network interfaces
    Then I should see all network interfaces

  Scenario: Bring an interface down with wicked
    When I bring up eth0
    And I bring down eth0
    Then I should not be able to ping a reference machine from my dynamic address
    And eth0 should not use any address

  Scenario: Bring an interface up with wicked
    # This assumes that the default networking setup uses DHCP and NDP
    When I bring up eth0
    Then eth0 should use the dynamic addresses
    But eth0 should not use the static addresses
    And I should be able to ping a reference machine from my dynamic address

  Scenario: Set up static addresses from legacy ifcfg files
    When I set up static IP addresses for eth0 from legacy files
    Then eth0 should use the static addresses
    But eth0 should not use the dynamic addresses
    And I should be able to ping the reference machine from my static address
    But I should not have static routes to the outside World
    And I should not have dynamic routes to the outside World

  Scenario: Set up static addresses from wicked XML files
    When I set up static IP addresses for eth0 from XML files
    Then eth0 should use the static addresses
    But eth0 should not use the dynamic addresses
    And I should be able to ping the reference machine from my static address
    But I should not have static routes to the outside World
    And I should not have dynamic routes to the outside World

  Scenario: Set up dynamic addresses from legacy ifcfg files
    When I set up dynamic IP addresses for eth0 from legacy files
    Then eth0 should use the dynamic addresses
    But eth0 should not use the static addresses
    And I should be able to ping the reference machine from my dynamic address
    But I should not have static routes to the outside World
    And I should not have dynamic routes to the outside World

  Scenario: Set up dynamic addresses from wicked XML files
    When I set up dynamic IP addresses for eth0 from XML files
    Then eth0 should use the dynamic addresses
    But eth0 should not use the static addresses
    And I should be able to ping the reference machine from my dynamic address
    But I should not have static routes to the outside World
    And I should not have dynamic routes to the outside World

  Scenario: Set up static routes from legacy ifcfg files
    When I set up static addresses and routes for eth0 from legacy files
    Then I should have static routes to the outside World
    But I should not have dynamic routes to the outside World
    And I should be able to ping a host in the outside World

  Scenario: Set up static routes from wicked XML files
    When I set up static addresses and routes for eth0 from XML files
    Then I should have static routes to the outside World
    But I should not have dynamic routes to the outside World
    And I should be able to ping a host in the outside World

  Scenario: Set up dynamic routes from legacy ifcfg files
    When I ask the reference machine to advertise a default route
    And I set up dynamic IP addresses for eth0 from legacy files
    Then I should have dynamic routes to the outside World
    But I should not have static routes to the outside World
    And I should be able to ping a host in the outside World

  Scenario: Set up dynamic routes from wicked XML files
    When I ask the reference machine to advertise a default route
    And I set up dynamic IP addresses for eth0 from XML files
    Then I should have dynamic routes to the outside World
    But I should not have static routes to the outside World
    And I should be able to ping a host in the outside World

  Scenario: Hotplug deconnection and reconnection
    Given nanny is enabled
    When I bring up eth0
    And I deconnect violently eth0
    And I reconnect eth0
    Then eth0 should have a dynamic address after a while

# TODO
# ====
#
# * zeroconf (autoip flag)

