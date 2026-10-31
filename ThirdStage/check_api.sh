#!/usr/bin/env bash

if [[ $# -ne 1 ]]; then
    echo "Использование: $0 <URL>"
    exit 1
fi

url="$1"

http_code=$(curl -s -L -o /dev/null -w "%{http_code}" --max-time 10 "$url")
curl_status=$?

if [[ $curl_status -eq 0 && "$http_code" == "200" ]]; then
    echo "API доступен"
    exit 0
else
    echo "API недоступен, код ответа: ${http_code:-000}"
    exit 1
fi