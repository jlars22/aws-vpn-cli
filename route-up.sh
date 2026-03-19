#!/bin/bash
# Called by OpenVPN --route-up after tunnel + routes are established.
# At this point, pushed dhcp-option values are available as foreign_option_* env vars.
# shellcheck disable=SC2154  # $dev is set by OpenVPN

# Parse DNS servers from pushed options
DNS_SERVERS=""
for opt in ${!foreign_option_*}; do
  val="${!opt}"
  if [[ "$val" == "dhcp-option DNS "* ]]; then
    DNS_SERVERS="${DNS_SERVERS} ${val#dhcp-option DNS }"
  fi
done

if [[ -n "$DNS_SERVERS" ]]; then
  if [[ "$(uname -s)" == "Darwin" ]]; then
    /usr/sbin/scutil <<-EOF
	d.init
	d.add ServerAddresses *${DNS_SERVERS}
	d.add SupplementalMatchDomains * ""
	set State:/Network/Service/aws-vpn-${dev}/DNS
	EOF
  else
    # shellcheck disable=SC2086  # intentional word splitting — resolvectl expects separate args
    resolvectl dns "${dev:-tun0}" $DNS_SERVERS
    resolvectl domain "${dev:-tun0}" "~."
  fi
  echo "VPN DNS configured (${dev}):${DNS_SERVERS}"
fi
