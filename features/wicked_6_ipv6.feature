Feature: Wicked 6 IPv6

  In order to be able to set up network interfaces
  As a network administrator who wants to use IPv6
  I should be able to use the new Wicked network interfaces broker

  Background:
    When the reference machine is set up correctly
    And the system under test is set up correctly
    And there is no core dump
    And the wicked services are started
    And the interfaces are in a basic state
    And the routing table is empty
    And there is no virtual interface left on any machine

  # All the tests below assume that eth0 is set by default with DHCP and RADVD

  Scenario: Managed off, other off, prefix length != 64
    When radvd is set to managed off, other off, prefix length != 64
    And I set up static IP addresses for eth0 from legacy files
    And I let eth0 wait for a router announcement
    And I retrigger DHCP requests
    Then I should not obtain an address by DHCPv4
    And I should not obtain an autonomous IPv6 address
    And I should not obtain an address by DHCPv6
    And no address should be tentative
    And I should obtain a default IPv6 route
    And I should not obtain a DNS server by DHCPv4
#    And I should not obtain a DNS server by RDNSS
    And I should not obtain a DNS server by DHCPv6

  Scenario: Managed off, other off, prefix length != 64, RDNSS
    When radvd is set to managed off, other off, prefix length != 64, RDNSS
    And I set up static IP addresses for eth0 from legacy files
    And I let eth0 wait for a router announcement
    And I retrigger DHCP requests
    Then I should not obtain an address by DHCPv4
    And I should not obtain an autonomous IPv6 address
    And I should not obtain an address by DHCPv6
    And no address should be tentative
    And I should obtain a default IPv6 route
    And I should not obtain a DNS server by DHCPv4
#    And I should obtain a DNS server by RDNSS
    But I should not obtain a DNS server by DHCPv6

  Scenario: Managed off, other off, prefix length == 64
    When radvd is set to managed off, other off, prefix length == 64
    And I set up static IP addresses for eth0 from legacy files
    And I let eth0 wait for a router announcement
    And I retrigger DHCP requests
    Then I should not obtain an address by DHCPv4
    But I should obtain an autonomous IPv6 address
    But I should not obtain an address by DHCPv6
    And no address should be tentative
    And I should obtain a default IPv6 route
    And I should not obtain a DNS server by DHCPv4
#    And I should not obtain a DNS server by RDNSS
    And I should not obtain a DNS server by DHCPv6

  Scenario: Managed off, other off, prefix length == 64, RDNSS
    When radvd is set to managed off, other off, prefix length == 64, RDNSS
    And I set up static IP addresses for eth0 from legacy files
    And I let eth0 wait for a router announcement
    And I retrigger DHCP requests
    Then I should not obtain an address by DHCPv4
    And I should obtain an autonomous IPv6 address
    But I should not obtain an address by DHCPv6
    And no address should be tentative
    And I should obtain a default IPv6 route
    And I should not obtain a DNS server by DHCPv4
#    And I should obtain a DNS server by RDNSS
    But I should not obtain a DNS server by DHCPv6

  Scenario: Managed off, other on, prefix length != 64
    When radvd is set to managed off, other on, prefix length != 64
    And I set up dynamic IP addresses for eth0 from legacy files
    And I let eth0 wait for a router announcement
    And I retrigger DHCP requests
    Then I should obtain an address by DHCPv4
    But I should not obtain an autonomous IPv6 address
    And I should not obtain an address by DHCPv6
    And no address should be tentative
    And I should obtain a default IPv6 route
    And I should obtain a DNS server by DHCPv4
#    And I should not obtain a DNS server by RDNSS
    But I should obtain a DNS server by DHCPv6

  Scenario: Managed off, other on, prefix length != 64, RDNSS
    When radvd is set to managed off, other on, prefix length != 64, RDNSS
    And I set up dynamic IP addresses for eth0 from legacy files
    And I let eth0 wait for a router announcement
    And I retrigger DHCP requests
    Then I should obtain an address by DHCPv4
    But I should not obtain an autonomous IPv6 address
    And I should not obtain an address by DHCPv6
    And no address should be tentative
    And I should obtain a default IPv6 route
    And I should obtain a DNS server by DHCPv4
#    And I should obtain a DNS server by RDNSS
    And I should obtain a DNS server by DHCPv6

  Scenario: Managed off, other on, prefix length == 64
    When radvd is set to managed off, other on, prefix length == 64
    And I set up dynamic IP addresses for eth0 from legacy files
    And I let eth0 wait for a router announcement
    And I retrigger DHCP requests
    Then I should obtain an address by DHCPv4
    And I should obtain an autonomous IPv6 address
    But I should not obtain an address by DHCPv6
    And no address should be tentative
    And I should obtain a default IPv6 route
    And I should obtain a DNS server by DHCPv4
#    And I should not obtain a DNS server by RDNSS
    But I should obtain a DNS server by DHCPv6

  Scenario: Managed off, other on, prefix length == 64, RDNSS
    When radvd is set to managed off, other on, prefix length == 64, RDNSS
    And I set up dynamic IP addresses for eth0 from legacy files
    And I let eth0 wait for a router announcement
    And I retrigger DHCP requests
    Then I should obtain an address by DHCPv4
    And I should obtain an autonomous IPv6 address
    But I should not obtain an address by DHCPv6
    And no address should be tentative
    And I should obtain a default IPv6 route
    And I should obtain a DNS server by DHCPv4
#    And I should obtain a DNS server by RDNSS
    And I should obtain a DNS server by DHCPv6

  Scenario: Managed on, prefix length != 64
    When radvd is set to managed on, prefix length != 64
    And I set up dynamic IP addresses for eth0 from legacy files
    And I let eth0 wait for a router announcement
    And I retrigger DHCP requests
    Then I should obtain an address by DHCPv4
    But I should not obtain an autonomous IPv6 address
    But I should obtain an address by DHCPv6
    And no address should be tentative
    And I should obtain a default IPv6 route
    And I should obtain a DNS server by DHCPv4
#    And I should not obtain a DNS server by RDNSS
    But I should obtain a DNS server by DHCPv6

  Scenario: Managed on, prefix length != 64, RDNSS
    When radvd is set to managed on, prefix length != 64, RDNSS
    And I set up dynamic IP addresses for eth0 from legacy files
    And I let eth0 wait for a router announcement
    And I retrigger DHCP requests
    Then I should obtain an address by DHCPv4
    But I should not obtain an autonomous IPv6 address
    But I should obtain an address by DHCPv6
    And no address should be tentative
    And I should obtain a default IPv6 route
    And I should obtain a DNS server by DHCPv4
#    And I should obtain a DNS server by RDNSS
    And I should obtain a DNS server by DHCPv6

  Scenario: Managed on, prefix length == 64
    When radvd is set to managed on, prefix length == 64
    And I set up dynamic IP addresses for eth0 from legacy files
    And I let eth0 wait for a router announcement
    And I retrigger DHCP requests
    Then I should obtain an address by DHCPv4
    And I should obtain an autonomous IPv6 address
    And I should obtain an address by DHCPv6
    And no address should be tentative
    And I should obtain a default IPv6 route
    And I should obtain a DNS server by DHCPv4
#    And I should not obtain a DNS server by RDNSS
    But I should obtain a DNS server by DHCPv6

  Scenario: Managed on, prefix length == 64, RDNSS
    When radvd is set to managed on, prefix length == 64, RDNSS
    And I set up dynamic IP addresses for eth0 from legacy files
    And I let eth0 wait for a router announcement
    And I retrigger DHCP requests
    Then I should obtain an address by DHCPv4
    And I should obtain an autonomous IPv6 address
    And I should obtain an address by DHCPv6
    And no address should be tentative
    And I should obtain a default IPv6 route
    And I should obtain a DNS server by DHCPv4
#    And I should obtain a DNS server by RDNSS
    And I should obtain a DNS server by DHCPv6

  Scenario: No radvd server, BOOTPROTO="static"
    When radvd is switched off
    And I bring up eth0 with BOOTPROTO="static"
    Then the setup should be finished
    But I should not obtain an autonomous IPv6 address
    And I should not obtain an address by DHCPv4
    And I should not obtain an address by DHCPv6
    And no address should be tentative
    And I should not obtain a default IPv6 route
#    And I should not obtain a DNS server by RDNSS
    And I should not obtain a DNS server by DHCPv4
    And I should not obtain a DNS server by DHCPv6

  Scenario: No radvd server, BOOTPROTO="dhcp"
    When radvd is switched off
    And I bring up eth0 with BOOTPROTO="dhcp"
    Then the setup should be finished
    But I should not obtain an autonomous IPv6 address
    But I should obtain an address by DHCPv4
    And no address should be tentative
    And I should not obtain a default IPv6 route
#    And I should not obtain a DNS server by RDNSS
    But I should obtain a DNS server by DHCPv4
    # No test of DHCPv6, as it would depend on last RA before switching off RADVD

  Scenario: No radvd server, BOOTPROTO="dhcp6"
    When radvd is switched off
    And I bring up eth0 with BOOTPROTO="dhcp6"
    Then the setup should be finished
    But I should not obtain an autonomous IPv6 address
    And I should not obtain an address by DHCPv4
    And no address should be tentative
    And I should not obtain a default IPv6 route
#    And I should not obtain a DNS server by RDNSS
    And I should not obtain a DNS server by DHCPv4
    # No test of DHCPv6, as it would depend on last RA before switching off RADVD

  Scenario: No dhcpd and dhcpd6 servers, BOOTPROTO="static"
    When radvd is set to managed on, prefix length == 64, RDNSS
    And dhcpd is switched off
    And dhcpd6 is switched off
    And I bring up eth0 with BOOTPROTO="static"
    And I let eth0 wait for a router announcement
    Then the setup should be finished
    And I should obtain an autonomous IPv6 address
    But I should not obtain an address by DHCPv4
    And I should not obtain an address by DHCPv6
    And no address should be tentative
    But I should obtain a default IPv6 route
#    And I should obtain a DNS server by RDNSS
    But I should not obtain a DNS server by DHCPv4
    And I should not obtain a DNS server by DHCPv6

  Scenario: No dhcpd and dhcpd6 servers, BOOTPROTO="dhcp"
    When radvd is set to managed on, prefix length == 64, RDNSS
    And dhcpd is switched off
    And dhcpd6 is switched off
    And I bring up eth0 with BOOTPROTO="dhcp"
    And I let eth0 wait for a router announcement
    And I retrigger DHCP requests
    Then the setup should still be in progress
    And I should obtain an autonomous IPv6 address
    But I should not obtain an address by DHCPv4
    And I should not obtain an address by DHCPv6
    And no address should be tentative
    But I should obtain a default IPv6 route
#    And I should obtain a DNS server by RDNSS
    But I should not obtain a DNS server by DHCPv4
    And I should not obtain a DNS server by DHCPv6

  Scenario: No dhcpd and dhcpd6 servers, BOOTPROTO="dhcp6"
    When radvd is set to managed on, prefix length == 64, RDNSS
    And dhcpd is switched off
    And dhcpd6 is switched off
    And I bring up eth0 with BOOTPROTO="dhcp6"
    And I let eth0 wait for a router announcement
    And I retrigger DHCP requests
    Then the setup should still be in progress
    And I should obtain an autonomous IPv6 address
    But I should not obtain an address by DHCPv4
    And I should not obtain an address by DHCPv6
    And no address should be tentative
    But I should obtain a default IPv6 route
#    And I should obtain a DNS server by RDNSS
    But I should not obtain a DNS server by DHCPv4
    And I should not obtain a DNS server by DHCPv6

  Scenario: No dhcpd6 server, BOOTPROTO="static"
    When radvd is set to managed on, prefix length == 64, RDNSS
    And dhcpd6 is switched off
    And I bring up eth0 with BOOTPROTO="static"
    And I let eth0 wait for a router announcement
    Then the setup should be finished
    And I should obtain an autonomous IPv6 address
    But I should not obtain an address by DHCPv4
    And I should not obtain an address by DHCPv6
    And no address should be tentative
    But I should obtain a default IPv6 route
#    And I should obtain a DNS server by RDNSS
    But I should not obtain a DNS server by DHCPv4
    And I should not obtain a DNS server by DHCPv6

  Scenario: No dhcpd6 server, BOOTPROTO="dhcp"
    When radvd is set to managed on, prefix length == 64, RDNSS
    And dhcpd6 is switched off
    And I bring up eth0 with BOOTPROTO="dhcp"
    And I let eth0 wait for a router announcement
    And I retrigger DHCP requests
    Then the setup should be finished
    And I should obtain an autonomous IPv6 address
    And I should obtain an address by DHCPv4
    But I should not obtain an address by DHCPv6
    And no address should be tentative
    But I should obtain a default IPv6 route
#    And I should obtain a DNS server by RDNSS
    And I should obtain a DNS server by DHCPv4
    But I should not obtain a DNS server by DHCPv6

  Scenario: No dhcpd6 server, BOOTPROTO="dhcp6"
    When radvd is set to managed on, prefix length == 64, RDNSS
    And dhcpd6 is switched off
    And I bring up eth0 with BOOTPROTO="dhcp6"
    And I let eth0 wait for a router announcement
    And I retrigger DHCP requests
    Then the setup should still be in progress
    And I should obtain an autonomous IPv6 address
    But I should not obtain an address by DHCPv4
    And I should not obtain an address by DHCPv6
    And no address should be tentative
    But I should obtain a default IPv6 route
#    And I should obtain a DNS server by RDNSS
    But I should not obtain a DNS server by DHCPv4
    And I should not obtain a DNS server by DHCPv6

