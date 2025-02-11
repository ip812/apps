#!/bin/bash

cmd_id="$(aws ssm send-command \
    --region "${AWS_REGION}" \
    --document-name "AWS-RunShellScript" \
    --targets "Key=instanceIds,Values=${INSTANCE_ID}" \
    --parameters "commands=[\"${CMD}\"]" \
    --query 'Command.CommandId' \
    --output text)"

cnt=0
while true; do
    cnt=$((cnt + 1))
    status="$(aws ssm get-command-invocation \
        --region "${AWS_REGION}" \
        --instance-id "${INSTANCE_ID}" \
        --command-id "${cmd_id}" \
        --query 'Status' \
        --output text)"
    if [[ "${status}" != "InProgress" ]]; then
        break
    fi
    if [ "${cnt}" -eq 10 ]; then
        echo "Command \"${CMD}\"  never ends"
        exit 42
    fi
    sleep 1
done

aws ssm get-command-invocation \
    --region "${AWS_REGION}" \
    --instance-id "${INSTANCE_ID}" \
    --command-id "${cmd_id}" \
    --query 'StandardOutputContent' \
    --output text

