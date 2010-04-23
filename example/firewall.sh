#!/bin/sh

#
# firewall-script template
# nostromo, Wed Nov 30 16:52:28 2005
#

#
# update-rc.d nos_firewall start 40 S . stop 89 0 6 .
#---------------------------------------------------------------
# while true; do test=""; read  -t 20 -p "OK? " test ; \
# [ -z "$test" ] && /etc/init.d/nos_firewall clear ; done
#---------------------------------------------------------------
#

# config: services from the internet...
TCP_SERVICES="80 443 6622"
UDP_SERVICES=""

# config: services to the internet...
REMOTE_TCP_SERVICES="22 80 443"
REMOTE_UDP_SERVICES="53"

#
# do not modify beyond this line, except you really know what
# you're doing... you've been warned!
#

PATH=/bin:/sbin:/usr/bin:/usr/sbin

IPTABLES="/sbin/iptables"

if ! [ -x $IPTABLES ]; then
    exit 0
fi

fw_start () {

  #
  # input...
  #
  $IPTABLES -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

  if [ -n "$TCP_SERVICES" ] ; then
  for PORT in $TCP_SERVICES; do
    $IPTABLES -A INPUT -p tcp --dport ${PORT} -j ACCEPT
  done
  fi

  if [ -n "$UDP_SERVICES" ] ; then
  for PORT in $UDP_SERVICES; do
    $IPTABLES -A INPUT -p udp --dport ${PORT} -j ACCEPT
  done
  fi

  $IPTABLES -A INPUT -p icmp -j ACCEPT
  $IPTABLES -A INPUT -i lo -j ACCEPT
  $IPTABLES -P INPUT DROP
  # $IPTABLES -A INPUT -j LOG

  #
  # output...
  #
  $IPTABLES -A OUTPUT -j ACCEPT -o lo
  $IPTABLES -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

  $IPTABLES -A OUTPUT -p icmp -j ACCEPT

  # apt-get...
  $IPTABLES -A OUTPUT -p tcp -d security.debian.org --dport 80 -j ACCEPT

  if [ -n "$REMOTE_TCP_SERVICES" ] ; then
  for PORT in $REMOTE_TCP_SERVICES; do
    $IPTABLES -A OUTPUT -p tcp --dport ${PORT} -j ACCEPT
  done
  fi

  if [ -n "$REMOTE_UDP_SERVICES" ] ; then
  for PORT in $REMOTE_UDP_SERVICES; do
    $IPTABLES -A OUTPUT -p udp --dport ${PORT} -j ACCEPT
  done
  fi

  # $IPTABLES -A OUTPUT -j LOG
  $IPTABLES -A OUTPUT -j REJECT 
  $IPTABLES -P OUTPUT DROP

  echo 1 > /proc/sys/net/ipv4/tcp_syncookies
  echo 0 > /proc/sys/net/ipv4/ip_forward 
  echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts 
  echo 1 > /proc/sys/net/ipv4/conf/all/log_martians 
  echo 1 > /proc/sys/net/ipv4/icmp_ignore_bogus_error_responses
  echo 1 > /proc/sys/net/ipv4/conf/all/rp_filter
  echo 0 > /proc/sys/net/ipv4/conf/all/send_redirects
  echo 0 > /proc/sys/net/ipv4/conf/all/accept_source_route

}

fw_stop () {
  $IPTABLES -F
  $IPTABLES -t nat -F
  $IPTABLES -t mangle -F
  $IPTABLES -P INPUT DROP
  $IPTABLES -P FORWARD DROP
  $IPTABLES -P OUTPUT ACCEPT
}

fw_clear () {
  $IPTABLES -F
  $IPTABLES -t nat -F
  $IPTABLES -t mangle -F
  $IPTABLES -P INPUT ACCEPT
  $IPTABLES -P FORWARD ACCEPT
  $IPTABLES -P OUTPUT ACCEPT
}


case "$1" in
  start|restart)
    echo -n "starting firewall.."
    fw_stop 
    fw_start
    echo "done."
    ;;
  stop)
    echo -n "stopping firewall.."
    # fw_stop
    fw_clear
    echo "done."
    ;;
  clear)
    echo -n "clearing firewall rules.."
    fw_clear
    echo "done."
    ;;
  *)
    echo "Usage: $0 {start|stop|restart|clear}"
    exit 1
    ;;
  esac
exit 0

