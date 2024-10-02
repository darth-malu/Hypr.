#!/bin/dash

#for i in {1..5}; do

for i in 1 2 3 4 5; do
    response_text=$(curl -s "https://wttr.in/$1?format=1")
    curl_status=$?

    if [ $curl_status -eq 0 ]; then
        text=$(echo "$response_text" | sed -E "s/\s+/ /g")
        response_tooltip=$(curl -s "https://wttr.in/$1?format=4")
        curl_status=$?

        if [ $curl_status -eq 0 ]; then
            tooltip=$(echo "$response_tooltip" | sed -E "s/\s+/ /g")
            echo "{\"text\":\"$text\", \"tooltip\":\"$tooltip\"}"
            exit 0
        fi
    fi
    sleep 2
done

echo "{\"text\":\"error\", \"tooltip\":\"error\"}"
exit 1

