#!/bin/bash

set -e

CMD=$1
INSTANCE_ID=$2  

if [[ -z "${INSTANCE_ID}" ]]; then
    echo "Error: INSTANCE_ID is empty. Exiting."
    exit 1
fi

echo "Executing command on instance: ${INSTANCE_ID}"

CMD_ID="$(aws ssm send-command \
    --region "${AWS_REGION}" \
    --document-name "AWS-RunShellScript" \
    --targets "Key=instanceIds,Values=${INSTANCE_ID}" \
    --parameters "commands=[\"${CMD}\"]" \
    --query 'Command.CommandId' \
    --output text)"

if [[ -z "${CMD_ID}" ]]; then
    echo "Error: Failed to send command."
    exit 1
fi

echo "AWS command ID: ${CMD_ID}"

CNT=0
while true; do
    CNT=$((CNT + 1))
    echo "Attempt ${CNT} to get the command status"
    
    status="$(aws ssm get-command-invocation \
        --region "${AWS_REGION}" \
        --instance-id "${INSTANCE_ID}" \
        --command-id "${CMD_ID}" \
        --query 'Status' \
        --output text)"
    
    if [[ "${status}" != "InProgress" ]]; then
        break
    fi

    if [[ "${CNT}" -eq 10 ]]; then
        echo "Error: Command '${CMD}' never completed."
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

