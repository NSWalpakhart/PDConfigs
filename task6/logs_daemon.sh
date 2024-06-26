#!/bin/bash

LOG_FILE_1="/etc/nginx/logs/file1.log"
LOG_FILE_2="/etc/nginx/logs/file2.log"
LOG_FILE_3="/etc/nginx/logs/file3.log"
LOG_FILE_4="/etc/nginx/logs/file4.log"

while true; do
    if [ $(stat -c%s "$LOG_FILE_1") -gt 10240 ]; then
        LINE_COUNT=$(wc -l < "$LOG_FILE_1")
        echo "$(date): Cleared $LOG_FILE_1 with $LINE_COUNT lines" >> "$LOG_FILE_2"
        > "$LOG_FILE_1"
    fi

    input_file="$LOG_FILE_1"
    output_file_4xx="$LOG_FILE_4"
    output_file_5xx="$LOG_FILE_3"
    while read -r line; do
        http_code=$(echo "$line" | awk '{print $9}')
        case "$http_code" in
            [4]*)
                echo "$line" >> "$output_file_4xx"
                ;;
            [5]*)
                echo "$line" >> "$output_file_5xx"
                ;;
        esac
    done < "$input_file"
    awk '!a[$0]++' "$LOG_FILE_3" > "$LOG_FILE_3.tmp" && mv "$LOG_FILE_3.tmp" "$LOG_FILE_3"
    awk '!a[$0]++' "$LOG_FILE_4" > "$LOG_FILE_4.tmp" && mv "$LOG_FILE_4.tmp" "$LOG_FILE_4"
    sleep 5
done
