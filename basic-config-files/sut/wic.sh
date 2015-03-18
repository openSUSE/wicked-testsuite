#! /bin/bash

echo "Wicked client called on $(date) as $(whoami) ---------------" | systemd-cat -t wickedc
echo "# wicked $@"                                                  | systemd-cat -t wickedc

ulimit -c unlimited
/usr/sbin/wicked --debug all --log-target syslog "$@"
RC=$?
echo "# wicked $@ returned: $RC"                                    | systemd-cat -t wickedc
echo                                                                | systemd-cat -t wickedc

echo "# wicked ifstatus all"                                        | systemd-cat -t wickedc
/usr/sbin/wicked ifstatus all 2>&1                                  | systemd-cat -t wickedc
echo                                                                | systemd-cat -t wickedc

echo "# wicked show-config"                                         | systemd-cat -t wickedc
/usr/sbin/wicked show-config 2>&1                                   | systemd-cat -t wickedc
echo                                                                | systemd-cat -t wickedc

echo "# ip addr show"                                               | systemd-cat -t wickedc
ip addr show 2>&1                                                   | systemd-cat -t wickedc
echo                                                                | systemd-cat -t wickedc

echo "# ip -4 route show"                                           | systemd-cat -t wickedc
ip -4 route show 2>&1                                               | systemd-cat -t wickedc
echo                                                                | systemd-cat -t wickedc

echo "# ip -6 route show"                                           | systemd-cat -t wickedc
ip -6 route show 2>&1                                               | systemd-cat -t wickedc
echo                                                                | systemd-cat -t wickedc

echo                                                                | systemd-cat -t wickedc
exit $RC
