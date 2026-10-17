#!/bin/bash
# Run by the AXISCOPE macro (RUN_SHELL_COMMAND CMD=axiscope_start).
# Uses Moonraker's API (local and trusted, no sudo needed) to restart crowsnest
# so a freshly plugged-in camera is picked up, then starts the axiscope service.
# The last line is HTML: Fluidd's console shows it as a clickable link.
API="http://127.0.0.1:7125"

service() {  # $1 = start|restart, $2 = service name
    local code
    code=$(curl -s -m 30 -o /dev/null -w "%{http_code}" -X POST "$API/machine/services/$1?service=$2")
    if [ "$code" = "200" ]; then
        echo "$2: $1 ok"
    else
        echo "$2: $1 failed (HTTP $code)"
    fi
}

service restart crowsnest
service start axiscope

ip=$(hostname -I 2>/dev/null | awk '{print $1}')
[ -z "$ip" ] && ip=$(hostname).local
echo "<a href='http://${ip}:3000' target='_blank'>Open Axiscope</a>"
