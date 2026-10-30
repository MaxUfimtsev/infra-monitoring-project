#!/usr/bin/env bash

LOG_FILE="access.log"

> "$LOG_FILE"

for ((i=1; i <= 300; i++)); do

    case $((i % 10)) in
        0|2|4|6|8) ip="192.168.1.10" ;;
        1|3|5)     ip="10.0.0.5" ;;
        *)         ip="172.16.0.8" ;;
    esac

    if (( i % 2 == 0 )); then
        method="POST"
        path="/api/login"
    else
        method="GET"
        path="/api/users"
    fi

    if (( i % 10 == 0 )); then
        status=500
    elif (( i % 7 == 0 )); then
        status=404
    else
        status=200
    fi

    second=$(printf "%02d" $((i % 60)))
    date_str=$(date '+%d/%b/%Y:%H:%M')

    echo "$ip - - [$date_str:$second] \"$method $path HTTP/1.1\" $status" >> "$LOG_FILE"

done

total=$(awk 'END {print NR}' "$LOG_FILE")

top_ips=$(grep -Eo '^[0-9]{1,3}(\.[0-9]{1,3}){3}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -3)

errors_4xx=$(grep -Ec '" 4[0-9]{2}$' "$LOG_FILE")
errors_5xx=$(grep -Ec '" 5[0-9]{2}$' "$LOG_FILE")

echo "Анализ логов"
echo "------------------------"
echo "Всего запросов: $total"
echo ""
echo "Топ-3 IP-адреса:"
echo "$top_ips"
echo ""
echo "Ошибки 4xx: $errors_4xx"
echo "Ошибки 5xx: $errors_5xx"