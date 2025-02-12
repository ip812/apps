#!/bin/bash

TITLE=$1
DESCRIPTION=$2
STATUS=$3
FIELDS=$4
DISCORD_DEPLOYMENTS_WEBHOOK_URL=$5

if [[ "${STATUS}" = "success" ]]; then
    COLOR=3066993 # Green
else
    COLOR=15158332 # Red
fi

FIELDS_JSON=""
while read FIELD; do
    KEY="$(echo "${FIELD}" | cut -d '=' -f 1)" 
    VALUE="$(echo "${FIELD}" | cut -d '=' -f 2)" 
    FIELDS_JSON+="{\"name\": \"${KEY}\", \"value\": \"${VALUE}\", \"inline\": true},"
done < <(echo "${FIELDS}" | tr ',' '\n')

JSON_PAYLOAD=$(cat <<EOF
{
  "embeds": [
    {
      "title": "${TITLE}",
      "description": "${DESCRIPTION}",
      "color": ${COLOR},
      "fields": [${FIELDS_JSON}],
      "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
    }
  ]
}
EOF
)

echo "${JSON_PAYLOAD}"

curl -H "Content-Type: application/json" -X POST -d "${JSON_PAYLOAD}" "${DISCORD_DEPLOYMENTS_WEBHOOK_URL}"

