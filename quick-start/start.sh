#!/usr/bin/env bash

echo "Stalling for Kibana"
while true; do
    sleep 1
    status=$(curl -s --head -w %{http_code} http://0.0.0.0:9200/.kibana -o /dev/null)
    if [ ${status} -eq 200 ]; then
        break
    fi
done

echo "Starting Vamp"
java -Dlogback.configurationFile=/usr/local/vamp/logback.xml -Dconfig.file=/usr/local/vamp/application.conf -jar /usr/local/vamp/vamp.jar
