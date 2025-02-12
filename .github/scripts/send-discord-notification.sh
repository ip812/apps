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

FIELDS_JSON=$(echo "$FIELDS" | tr ',' '\n' | jq -R 'split("=") | {name: .[0], value: .[1], inline: false}' | jq -s -c .)
JSON_PAYLOAD=$(cat <<EOF
{
  "embeds": [
    {
      "title": "${TITLE}",
      "description": "${DESCRIPTION}",
      "color": ${COLOR},
      "fields": ${FIELDS_JSON},
      "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
    }
  ]
}
EOF
)

echo "${JSON_PAYLOAD}"

curl -H "Content-Type: application/json" -X POST -d "${JSON_PAYLOAD}" "${DISCORD_DEPLOYMENTS_WEBHOOK_URL}"

if [[ $? -eq 0 ]]; then
  echo "Notification sent successfully."
else
  echo "Failed to send notification."
  exit 1
fi

