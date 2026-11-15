#!/usr/bin/env bash

OUTPUT_DIR="/var/www/html/viikko3"
OUTPUT_FILE="$OUTPUT_DIR/index.html"
TEMP_FILE="$OUTPUT_FILE.tmp"

GITHUB_URL="https://github.com/nour4557/viikko3-Bash-and-a-Server-Status-Report"

GENERATED_AT=$(TZ=UTC date '+%d.%m.%Y %H:%M:%S UTC (UTC%:z)')
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

cat > "$TEMP_FILE" <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Week 3 – Server Status Report</title>
    <style>
          body {
            font-family: Arial, sans-serif;
            max-width: 900px;
            margin: 40px auto;
            padding: 0 20px;
            line-height: 1.7;
            background: #fff1f6;
            color: #55404a;
        }

        header {
            background: white;
            padding: 25px;
            border-radius: 16px;
            margin-bottom: 24px;
            border: 1px solid #f5c6d8;
        }

        h1 {
            color: #d65b91;
            text-align: center;
        }

        h2, h3 {
            color: #c34d83;
        }

        section {
            margin: 24px 0;
            padding: 24px;
            background: white;
            border-radius: 16px;
            border: 1px solid #f5c6d8;
        }

        .table-container {
            overflow-x: auto;
        }

        table {
            border-collapse: collapse;
            width: 100%;
        }

        th, td {
            border: 1px solid #f2c5d7;
            padding: 12px;
            text-align: left;
        }

        th {
            background: #ffe0ec;
            color: #9e3e6c;
        }

        code {
            background: #fff0f5;
            padding: 3px 6px;
            border-radius: 5px;
            overflow-wrap: anywhere;
            color: #bd477b;
        }

        a {
            color: #d64f8b;
            font-weight: bold;
        }

        a:hover {
            color: #96345f;
        }

        .note {
            color: #927080;
        }

        footer {
            text-align: center;
            padding: 20px;
        }
    </style>
</head>
<body>
    <header>
        <h1>Server Status Report</h1>
        <p>Week 3: Linux command line and Bash scripting</p>
        <p>
            This report shows information about my Linux server.
        </p>
    </header>

    <section>
        <h2>Current server status</h2>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th scope="col">Information</th>
                        <th scope="col">Value</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <th scope="row">Report generated</th>
                        <td>$GENERATED_AT</td>
                    </tr>
                    <tr>
                        <th scope="row">Server uptime</th>
                        <td>$UPTIME_TEXT</td>
                    </tr>
                    <tr>
                        <th scope="row">Root filesystem disk usage</th>
                        <td>$DISK_USAGE%</td>
                    </tr>
                    <tr>
                        <th scope="row">Disk space status</th>
                        <td>$DISK_STATUS</td>
                    </tr>
                    <tr>
                        <th scope="row">Total RAM</th>
                        <td>$MEM_TOTAL MiB</td>
                    </tr>
                    <tr>
                        <th scope="row">Available RAM</th>
                        <td>$MEM_AVAILABLE MiB</td>
                    </tr>
                </tbody>
            </table>
        </div>

        <p>
            Disk space status is OK below 80% usage
            and WARNING at 80% or above.
        </p>

        <p class="note">
            Bash generates this report once per minute.
            Wait approximately 1–2 minutes and reload the page
            to see a new generation time.
        </p>
    </section>

    <section>
        <h2>Commands used</h2>
        <ul>
            <li>
                <code>date</code>:
                displays the current date, time and time zone.
            </li>
            <li>
                <code>uptime -p</code>:
                displays how long the server has been running.
            </li>
            <li>
                <code>df -P /</code>:
                displays disk usage for the root filesystem.
            </li>
            <li>
                <code>free -m</code>:
                displays memory information in mebibytes (MiB).
            </li>
            <li>
                <code>df -P / | awk 'NR == 2 {print &#36;5}'</code>:
                uses a pipe to send filesystem information to awk,
                which extracts the disk usage percentage.
            </li>
        </ul>
    </section>

    <section>
        <h2>How the script works</h2>
        <p>
            The script collects server information using Linux commands
            and stores the results in Bash variables through command
            substitution.
        </p>
        <p>
            The check_disk function checks the disk usage.
            If the usage is 80% or more, the status is WARNING.
            Otherwise, the status is OK.
        </p>
        <p>
            The script generates a temporary HTML file and then moves
            the completed file into place as index.html.
            Nginx serves this file at /viikko3/.
        </p>
    </section>

    <section>
        <h2>Scheduling</h2>
        <p>
            I used cron to run my Bash script once every minute.
            I added the cron job using crontab.
            I checked that cron was active.
        </p>
    </section>

    <section>
        <h2>Test results</h2>

        <h3>Syntax check and manual execution</h3>
        <p>
            I tested the script with bash -n report.sh.
            It did not show any errors.
            I also ran the script manually and checked the report
            in my browser.
        </p>

        <h3>Disk space status tests</h3>
        <p>
            I tested the status logic using three different values.
            The results were the same as expected.
        </p>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th scope="col">Test input</th>
                        <th scope="col">Expected status</th>
                        <th scope="col">Actual status</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>50%</td>
                        <td>OK</td>
                        <td>OK</td>
                    </tr>
                    <tr>
                        <td>80%</td>
                        <td>WARNING</td>
                        <td>WARNING</td>
                    </tr>
                    <tr>
                        <td>90%</td>
                        <td>WARNING</td>
                        <td>WARNING</td>
                    </tr>
                </tbody>
            </table>
        </div>

        <h3>Automatic updates</h3>
        <p>
            I checked the report at different times. The file updated automatically every minute. I checked it twice and saw that the modification time had changed.
        </p>

        <h3>Reboot test</h3>
        <p>
            I learned how to check if the cron service is active
            and if the report page is working.
        </p>
    </section>

    <section>
        <h2>A problem solved or a lesson learned</h2>
        <p>

            I learned how to check running processes and system services.
        </p>
    </section>

    <footer>
        <p><a href="$GITHUB_URL">View the source code on GitHub</a></p>
    </footer>
</body>
</html>
EOF

mv "$TEMP_FILE" "$OUTPUT_FILE"
