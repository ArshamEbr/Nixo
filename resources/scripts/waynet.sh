#!/usr/bin/env bash

IFACE=$(ip route | awk '/default/ {print \$5; exit}')
if [ -z "\$IFACE" ]; then
  printf '{"text": "󰤭 Off", "tooltip": "No connection", "class": "disconnected"}'
  exit 0
fi

SSID=$(iwgetid -r 2>/dev/null || echo "")
SIGNAL=$(awk 'NR==3 {printf "%.0f", \$3 * 100 / 70}' /proc/net/wireless 2>/dev/null || echo "0")
IP=$(ip -4 addr show "\$IFACE" | awk '/inet / {print \$2}' | cut -d/ -f1 | head -1)

# Get speeds
RX1=$(cat /sys/class/net/"\$IFACE"/statistics/rx_bytes)
TX1=$(cat /sys/class/net/"\$IFACE"/statistics/tx_bytes)
sleep 1
RX2=$(cat /sys/class/net/"\$IFACE"/statistics/rx_bytes)
TX2=$(cat /sys/class/net/"\$IFACE"/statistics/tx_bytes)
RXSPEED=$(( (RX2 - RX1) / 1024 ))
TXSPEED=$(( (TX2 - TX1) / 1024 ))

# Format speeds
if [ "\$RXSPEED" -ge 1024 ]; then
  RXFMT="$(echo "scale=1; \$RXSPEED/1024" | bc)M"
else
  RXFMT="${RXSPEED}K"
fi
if [ "\$TXSPEED" -ge 1024 ]; then
  TXFMT="$(echo "scale=1; \$TXSPEED/1024" | bc)M"
else
  TXFMT="${TXSPEED}K"
fi

# Get vnstat data
TODAY=$(vnstat -i "\$IFACE" --oneline 2>/dev/null | cut -d';' -f6 || echo "N/A")
MONTH=$(vnstat -i "\$IFACE" --oneline 2>/dev/null | cut -d';' -f11 || echo "N/A")
ALLTIME=$(vnstat -i "\$IFACE" --oneline 2>/dev/null | cut -d';' -f16 || echo "N/A")

if [ -n "\$SSID" ]; then
  TEXT=" \$RXFMT  \$TXFMT"
  TOOLTIP="󰤨 $SSID (\$SIGNAL%)\n󰩟 \$IP\n\n<b>Speed</b>\n \$RXFMT/s   \$TXFMT/s\n\n<b>Data Usage</b>\n󰇚 Today: \$TODAY\n󰇚 Month: \$MONTH\n󰇚 Total: \$ALLTIME"
else
  TEXT="󰈀 \$RXFMT  \$TXFMT"
  TOOLTIP="󰈀 \$IFACE\n󰩟 \$IP\n\n<b>Speed</b>\n \$RXFMT/s   \$TXFMT/s\n\n<b>Data Usage</b>\n󰇚 Today: \$TODAY\n󰇚 Month: \$MONTH\n󰇚 Total: \$ALLTIME"
fi

printf '{"text": "%s", "tooltip": "%s"}' "$TEXT" "\$TOOLTIP"