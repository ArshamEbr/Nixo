#!/usr/bin/env bash

IFACE=$(ip route | awk '/default/ {print $5; exit}')
if [ -z "$IFACE" ]; then
  printf '{"text": "󰤭 Off", "tooltip": "No connection", "class": "disconnected"}'
  exit 0
fi

SSID=$(iwgetid -r 2>/dev/null || echo "")
SIGNAL=$(awk 'NR==3 {printf "%.0f", $3 * 100 / 70}' /proc/net/wireless 2>/dev/null)
SIGNAL=${SIGNAL:-0}
IP=$(ip -4 addr show "$IFACE" | awk '/inet / {print $2}' | cut -d/ -f1 | head -1)

# Get speeds
RX1=$(cat /sys/class/net/"$IFACE"/statistics/rx_bytes 2>/dev/null)
TX1=$(cat /sys/class/net/"$IFACE"/statistics/tx_bytes 2>/dev/null)
sleep 1
RX2=$(cat /sys/class/net/"$IFACE"/statistics/rx_bytes 2>/dev/null)
TX2=$(cat /sys/class/net/"$IFACE"/statistics/tx_bytes 2>/dev/null)
RXSPEED=$(( (RX2 - RX1) / 1024 ))
TXSPEED=$(( (TX2 - TX1) / 1024 ))

# Format speeds
if [ "$RXSPEED" -ge 1024 ]; then
  RXFMT="$(echo "scale=1; $RXSPEED/1024" | bc)M"
else
  RXFMT="${RXSPEED}K"
fi
if [ "$TXSPEED" -ge 1024 ]; then
  TXFMT="$(echo "scale=1; $TXSPEED/1024" | bc)M"
else
  TXFMT="${TXSPEED}K"
fi

# Get vnstat data - call ONCE and parse
VNSTAT_DATA=$(vnstat -i "$IFACE" --oneline 2>/dev/null)
if [ -n "$VNSTAT_DATA" ]; then
  TODAY=$(echo "$VNSTAT_DATA" | cut -d';' -f6)
  MONTH=$(echo "$VNSTAT_DATA" | cut -d';' -f11)
  ALLTIME=$(echo "$VNSTAT_DATA" | cut -d';' -f15)
else
  TODAY="N/A"
  MONTH="N/A"
  ALLTIME="N/A"
fi

if [ -n "$SSID" ]; then
  TEXT=" $RXFMT  $TXFMT"
  TOOLTIP="󰤨 $SSID ($SIGNAL%)\n󰩟 $IP\n\n<b>Speed</b>\n $RXFMT/s   $TXFMT/s\n\n<b>Data Usage</b>\n󰇚 Today: $TODAY\n󰇚 Month: $MONTH\n󰇚 Total: $ALLTIME"
else
  TEXT="󰈀 $RXFMT  $TXFMT"
  TOOLTIP="󰈀 $IFACE\n󰩟 $IP\n\n<b>Speed</b>\n $RXFMT/s   $TXFMT/s\n\n<b>Data Usage</b>\n󰇚 Today: $TODAY\n󰇚 Month: $MONTH\n󰇚 Total: $ALLTIME"
fi

printf '{"text": "%s", "tooltip": "%s"}' "$TEXT" "$TOOLTIP"