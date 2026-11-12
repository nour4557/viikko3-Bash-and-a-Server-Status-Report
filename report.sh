#!/usr/bin/env bash
GENERATED_AT=$(date)
UPTIME_TEXT=$(uptime -p)
DISK_USAGE=$(df -P / | awk 'NR == 2 {print $5}' | cut -d'%' -f1)
MEM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
MEM_AVAILABLE=$(free -m | awk '/Mem:/ {print $7}')

check_disk() {
    if [ "$DISK_USAGE" -ge 80 ]; then
        DISK_STATUS="WARNING"
    else
        DISK_STATUS="OK"
    fi
}

check_disk
cat > /var/www/html/viikko3/index.html <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Week 3 - Server Status</title>
</head>
<body>

    <h1>My Server Status Report</h1>

    <h2>Server information</h2>

    <p>Report generated: $GENERATED_AT</p>
    <p>Server uptime: $UPTIME_TEXT</p>
    <p>Disk usage: $DISK_USAGE%</p>
    <p>Disk status: $DISK_STATUS</p>
    <p>Total RAM: $MEM_TOTAL MiB</p>
    <p>Available RAM: $MEM_AVAILABLE MiB</p>

</body>
</html>
EOF
