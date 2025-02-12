#!/bin/bash

TITLE=$1
DESCRIPTION=$2
STATUS=$3
declare -n FIELDS=$4
DISCORD_DEPLOYMENTS_WEBHOOK_URL=$5

if [[ "${STATUS}" = "success" ]]; then
    COLOR=3066993 # Green
else
    COLOR=15158332 # Red
fi

FIELDS_JSON=""
for KEY in "${!FIELDS[@]}"; do
  FIELDS_JSON+="{\"name\": \"${KEY}\", \"value\": \"${FIELDS[${KEY}]}\", \"inline\": true},"
done
FIELDS_JSON="${FIELDS_JSON%,}"

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

