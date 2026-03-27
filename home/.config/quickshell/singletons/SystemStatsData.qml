pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    property int cpuUsage: 0
    property int memoryUsage: 0
    property string networkSpeed: "0.0b/s"

    // CPU Usage
    Process {
        id: cpuProcess
        running: true
        command: ["sh", "-c", "top -bn2 -d 0.5 | grep 'Cpu(s)' | tail -1 | awk '{print int($2)}'"]

        stdout: SplitParser {
            onRead: data => {
                cpuUsage = parseInt(data) || 0
            }
        }
    }

    Timer {
        interval: 10000  // Update every 10 seconds
        running: true
        repeat: true
        onTriggered: {
            cpuProcess.running = false
            cpuProcess.running = true
        }
    }

    // Memory Usage
    Process {
        id: memoryProcess
        running: true
        command: ["sh", "-c", "free | grep Mem | awk '{print int($3/$2 * 100)}'"]

        stdout: SplitParser {
            onRead: data => {
                memoryUsage = parseInt(data) || 0
            }
        }
    }

    Timer {
        interval: 30000  // Update every 30 seconds
        running: true
        repeat: true
        onTriggered: {
            memoryProcess.running = false
            memoryProcess.running = true
        }
    }

    // Network Speed
    Process {
        id: networkProcess
        running: true
        command: ["sh", "-c", `
            PREV_FILE="/tmp/quickshell_net_prev"
            CURRENT=$(cat /sys/class/net/enp6s0/statistics/rx_bytes)

            if [ -f "$PREV_FILE" ]; then
                PREV=$(cat "$PREV_FILE")
                BYTES_DIFF=$((CURRENT - PREV))
                BYTES_PER_SEC=$((BYTES_DIFF / 5))
                BITS_PER_SEC=$((BYTES_PER_SEC * 8))

                if [ "$BITS_PER_SEC" -ge 1000000000 ]; then
                    awk -v bits="$BITS_PER_SEC" 'BEGIN {printf "%.1fGb/s", bits/1000000000}'
                elif [ "$BITS_PER_SEC" -ge 1000000 ]; then
                    awk -v bits="$BITS_PER_SEC" 'BEGIN {printf "%.1fMb/s", bits/1000000}'
                elif [ "$BITS_PER_SEC" -ge 1000 ]; then
                    awk -v bits="$BITS_PER_SEC" 'BEGIN {printf "%.1fKb/s", bits/1000}'
                else
                    printf "%db/s" "$BITS_PER_SEC"
                fi
            else
                echo "0.0b/s"
            fi

            echo "$CURRENT" > "$PREV_FILE"
        `]

        stdout: SplitParser {
            onRead: data => {
                networkSpeed = data.trim()
            }
        }
    }

    Timer {
        interval: 5000  // Update every 5 seconds
        running: true
        repeat: true
        onTriggered: {
            networkProcess.running = false
            networkProcess.running = true
        }
    }
}
