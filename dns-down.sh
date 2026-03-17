#!/bin/bash
# Called by OpenVPN --down when tunnel is torn down.
# Removes the VPN DNS resolver entry.

/usr/sbin/scutil <<-EOF
	remove State:/Network/Service/openvpn/DNS
	EOF
echo "DNS restored to system defaults"
