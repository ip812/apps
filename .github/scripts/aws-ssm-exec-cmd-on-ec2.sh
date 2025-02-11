#!/bin/bash

CMD_ID="$(aws ssm send-command \
    --region "${AWS_REGION}" \
    --document-name "AWS-RunShellScript" \
    --targets "Key=instanceIds,Values=${INSTANCE_ID}" \
    --parameters "commands=[\"${CMD}\"]" \
    --query 'Command.CommandId' \
    --output text)"

CNT=0
while true; do
    CNT=$((CNT + 1))
    status="$(aws ssm get-command-invocation \
        --region "${AWS_REGION}" \
        --instance-id "${INSTANCE_ID}" \
        --command-id "${CMD_ID}" \
        --query 'Status' \
        --output text)"
    if [[ "${status}" != "InProgress" ]]; then
        break
    fi
    if [ "${CNT}" -eq 10 ]; then
        echo "Command \"${CMD}\"  never ends"
        exit 42
    fi
    sleep 1
done

aws ssm get-command-invocation \
    --region "${AWS_REGION}" \
    --instance-id "${INSTANCE_ID}" \
    --command-id "${CMD_ID}" \
    --query 'StandardOutputContent' \
    --output text

