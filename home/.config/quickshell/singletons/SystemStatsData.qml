pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    property int cpuUsage: 0
    property int memoryUsage: 0
    property string networkSpeedDown: "0b/s"
    property string networkSpeedUp: "0b/s"
    property real networkBitsPerSecDown: 0
    property real networkBitsPerSecUp: 0

    function formatSpeed(bits) {
        if (bits >= 1000000000) {
            return (bits / 1000000000).toFixed(1) + "Gb/s"
        } else if (bits >= 1000000) {
            return (bits / 1000000).toFixed(1) + "Mb/s"
        } else if (bits >= 1000) {
            return (bits / 1000).toFixed(1) + "Kb/s"
        } else {
            return Math.round(bits) + "b/s"
        }
    }

    // History arrays (last 60 samples)
    property var cpuHistory: []
    property var memoryHistory: []
    property var networkHistoryDown: []
    property var networkHistoryUp: []

    function addToHistory(array, value, maxLength) {
        var newArray = array.slice()
        newArray.push(value)
        if (newArray.length > maxLength) {
            newArray.shift()
        }
        return newArray
    }

    // CPU Usage
    Process {
        id: cpuProcess
        running: true
        command: ["sh", "-c", "top -bn2 -d 0.5 | grep 'Cpu(s)' | tail -1 | awk '{print int($2)}'"]

        stdout: SplitParser {
            onRead: data => {
                cpuUsage = parseInt(data) || 0
                cpuHistory = addToHistory(cpuHistory, cpuUsage, 60)
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
                memoryHistory = addToHistory(memoryHistory, memoryUsage, 60)
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

    // Network Speed (RX and TX)
    Process {
        id: networkProcess
        running: true
        command: ["sh", "-c", `
            PREV_FILE="/tmp/quickshell_net_prev"
            CURRENT_RX=$(cat /sys/class/net/enp6s0/statistics/rx_bytes)
            CURRENT_TX=$(cat /sys/class/net/enp6s0/statistics/tx_bytes)

            if [ -f "$PREV_FILE" ]; then
                PREV_RX=$(head -1 "$PREV_FILE")
                PREV_TX=$(tail -1 "$PREV_FILE")

                RX_DIFF=$((CURRENT_RX - PREV_RX))
                TX_DIFF=$((CURRENT_TX - PREV_TX))

                RX_BYTES_PER_SEC=$((RX_DIFF / 5))
                TX_BYTES_PER_SEC=$((TX_DIFF / 5))

                RX_BITS=$((RX_BYTES_PER_SEC * 8))
                TX_BITS=$((TX_BYTES_PER_SEC * 8))

                echo "RX:$RX_BITS"
                echo "TX:$TX_BITS"
            else
                echo "RX:0"
                echo "TX:0"
            fi

            echo "$CURRENT_RX" > "$PREV_FILE"
            echo "$CURRENT_TX" >> "$PREV_FILE"
        `]

        stdout: SplitParser {
            onRead: data => {
                var trimmed = data.trim()

                // Parse RX bits
                if (trimmed.startsWith("RX:")) {
                    var value = trimmed.substring(3)
                    var num = parseFloat(value)
                    if (!isNaN(num)) {
                        networkBitsPerSecDown = num
                        networkSpeedDown = formatSpeed(num)
                        networkHistoryDown = addToHistory(networkHistoryDown, num / 1000000, 60)
                    }
                }
                // Parse TX bits
                else if (trimmed.startsWith("TX:")) {
                    var value = trimmed.substring(3)
                    var num = parseFloat(value)
                    if (!isNaN(num)) {
                        networkBitsPerSecUp = num
                        networkSpeedUp = formatSpeed(num)
                        networkHistoryUp = addToHistory(networkHistoryUp, num / 1000000, 60)
                    }
                }
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
