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
      "footer": {"text":"Deployer","icon_url":"https://avatars.githubusercontent.com/u/187394964"},
      "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
    }
  ]
}
EOF
)
JSON_PAYLOAD=$(echo "$JSON_PAYLOAD" | jq '.embeds[0].fields |= map(if .name == "Image" or .name == "Environment" then .inline = true else . end)')
echo "${JSON_PAYLOAD}"

response=$(curl -s -o /dev/null -w "%{http_code}" -H "Content-Type: application/json" -d "$JSON_PAYLOAD" http://localhost:8080)
if [[ "$response" != "204" ]]; then
  echo "Failed to send notification. HTTP response: $response"
  exit 1
else
  echo "Notification sent successfully."
fi

