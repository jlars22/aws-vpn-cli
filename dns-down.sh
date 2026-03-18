#!/bin/bash
# Called by OpenVPN --down when tunnel is torn down.
# Removes the VPN DNS resolver entry for this specific tunnel device.

if [[ "$(uname -s)" == "Darwin" ]]; then
  /usr/sbin/scutil <<-EOF
	remove State:/Network/Service/aws-vpn-${dev}/DNS
	EOF
else
  resolvectl revert "${dev:-tun0}" 2>/dev/null || true
fi
echo "DNS restored for ${dev}"
