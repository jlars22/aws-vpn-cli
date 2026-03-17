#!/bin/bash
# Called by OpenVPN --route-up after tunnel + routes are established.
# At this point, pushed dhcp-option values are available as foreign_option_* env vars.

# Parse DNS servers from pushed options
DNS_SERVERS=""
for opt in ${!foreign_option_*}; do
  val="${!opt}"
  if [[ "$val" == "dhcp-option DNS "* ]]; then
    DNS_SERVERS="${DNS_SERVERS} ${val#dhcp-option DNS }"
  fi
done

if [[ -n "$DNS_SERVERS" ]]; then
  /usr/sbin/scutil <<-EOF
	d.init
	d.add ServerAddresses *${DNS_SERVERS}
	d.add SupplementalMatchDomains * ""
	set State:/Network/Service/openvpn/DNS
	EOF
  echo "VPN DNS configured:${DNS_SERVERS}"
fi
