#!/bin/bash
# Called by OpenVPN --down when tunnel is torn down.
# Removes the VPN DNS resolver entry.

if [[ "$(uname -s)" == "Darwin" ]]; then
  /usr/sbin/scutil <<-EOF
	remove State:/Network/Service/openvpn/DNS
	EOF
else
  resolvectl revert "${dev:-tun0}" 2>/dev/null || true
fi
echo "DNS restored to system defaults"
