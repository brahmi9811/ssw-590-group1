#!/bin/bash
# Terminates the group web server so it stops accruing charges.
set -euo pipefail
REGION="${AWS_REGION:-us-east-1}"
INSTANCE_ID=$(aws ec2 describe-instances --region "$REGION" \
  --filters Name=tag:Name,Values=ssw590-group1-web Name=instance-state-name,Values=running \
  --query 'Reservations[].Instances[].InstanceId' --output text)
[ -n "$INSTANCE_ID" ] && aws ec2 terminate-instances --region "$REGION" --instance-ids $INSTANCE_ID
