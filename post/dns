#!/bin/bash

set -euo pipefail
shopt -s nullglob

# Function to disable DHCP DNS in network files
disable_dhcp_dns() {
  for file in /etc/systemd/network/*.network; do
    [[ -f "$file" ]] || continue
    if ! grep -q "^\[DHCPv4\]" "$file"; then continue; fi

    # Add UseDNS=no to DHCPv4 section if not present
    if ! sed -n '/^\[DHCPv4\]/,/^\[/p' "$file" | grep -q "^UseDNS="; then
      sudo sed -i '/^\[DHCPv4\]/a UseDNS=no' "$file"
    fi

    # Add UseDNS=no to IPv6AcceptRA section if present
    if grep -q "^\[IPv6AcceptRA\]" "$file" && ! sed -n '/^\[IPv6AcceptRA\]/,/^\[/p' "$file" | grep -q "^UseDNS="; then
      sudo sed -i '/^\[IPv6AcceptRA\]/a UseDNS=no' "$file"
    fi
  done
}

# Function to enable DHCP DNS in network files
enable_dhcp_dns() {
  for file in /etc/systemd/network/*.network; do
    [[ -f "$file" ]] || continue
    sudo sed -i '/^UseDNS=no/d' "$file"
  done
}

# Function to restart network services
restart_services() {
  if ! sudo systemctl restart systemd-networkd systemd-resolved; then
    echo "Error: Failed to restart network services"
    exit 1
  fi
  echo "DNS configuration updated successfully!"
}

# Get DNS provider choice
if [[ -z "${1:-}" ]]; then
  dns=$(gum choose --height 5 --header "Select DNS provider" Cloudflare DHCP Custom)
else
  dns="$1"
fi

case "$dns" in
Cloudflare)
  sudo tee /etc/systemd/resolved.conf >/dev/null <<'EOF'
[Resolve]
DNS=1.1.1.1#cloudflare-dns.com 1.0.0.1#cloudflare-dns.com
FallbackDNS=9.9.9.9 149.112.112.112
DNSOverTLS=opportunistic
EOF

  disable_dhcp_dns
  restart_services
  ;;

DHCP)
  sudo tee /etc/systemd/resolved.conf >/dev/null <<'EOF'
[Resolve]
DNSOverTLS=no
EOF

  enable_dhcp_dns
  restart_services
  ;;

Custom)
  echo "Enter your DNS servers (space-separated, e.g. '192.168.1.1 1.1.1.1'):"
  read -r dns_servers

  if [[ -z "$dns_servers" ]]; then
    echo "Error: No DNS servers provided."
    exit 1
  fi

  # Validate DNS servers are IP addresses (basic IPv4 validation)
  for server in $dns_servers; do
    if ! [[ $server =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
      echo "Error: '$server' is not a valid IPv4 address"
      exit 1
    fi
  done

  sudo tee /etc/systemd/resolved.conf >/dev/null <<EOF
[Resolve]
DNS=$dns_servers
FallbackDNS=9.9.9.9 149.112.112.112
EOF

  disable_dhcp_dns
  restart_services
  ;;

*)
  echo "Error: Invalid DNS provider '$dns'"
  echo "Valid options: Cloudflare, DHCP, Custom"
  exit 1
  ;;
esac
