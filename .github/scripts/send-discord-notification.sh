#!/bin/bash

curl -H "Content-Type: application/json" -X POST -d '{
  "embeds": [
    {
      "title": "'${TITLE}'",
      "description": "'${DESCRIPTION}'",
      "color": '${COLOR}',
      "fields": [
        {"name": "Image name", "value": "'${IMAGE_NAME}'", "inline": true},
        {"name": "Tag", "value": "'${TAG}'", "inline": true}
        {"name": "Environment", "value": "'${ENV}'", "inline": true}
      ],
      "timestamp": "'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'"
    }
  ]
}' ${DISCORD_DEPLOYMENTS_WEBHOOK_URL}

