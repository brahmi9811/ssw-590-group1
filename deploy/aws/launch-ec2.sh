#!/bin/bash
# Launches one t3.micro (Free Tier eligible) Amazon Linux 2023 instance that
# runs ec2-user-data.sh at first boot. Requires the AWS CLI v2 configured with
# `aws configure` for an IAM user (never the root account).
set -euo pipefail

REGION="${AWS_REGION:-us-east-1}"
KEY_NAME="${KEY_NAME:-ssw590-group1-key}"
SG_NAME="${SG_NAME:-ssw590-group1-web}"
MY_IP="$(curl -s https://checkip.amazonaws.com)/32"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# SSH key pair (private key stays on this machine, chmod 400)
if ! aws ec2 describe-key-pairs --region "$REGION" --key-names "$KEY_NAME" >/dev/null 2>&1; then
  aws ec2 create-key-pair --region "$REGION" --key-name "$KEY_NAME" \
    --query KeyMaterial --output text > "$HOME/.ssh/$KEY_NAME.pem"
  chmod 400 "$HOME/.ssh/$KEY_NAME.pem"
fi

# Security group: HTTP from anywhere, SSH only from the current public IP
SG_ID=$(aws ec2 describe-security-groups --region "$REGION" \
  --filters Name=group-name,Values="$SG_NAME" \
  --query 'SecurityGroups[0].GroupId' --output text)
if [ "$SG_ID" = "None" ]; then
  SG_ID=$(aws ec2 create-security-group --region "$REGION" --group-name "$SG_NAME" \
    --description "SSW 590 group 1 web server" --query GroupId --output text)
  aws ec2 authorize-security-group-ingress --region "$REGION" --group-id "$SG_ID" \
    --protocol tcp --port 80 --cidr 0.0.0.0/0
  aws ec2 authorize-security-group-ingress --region "$REGION" --group-id "$SG_ID" \
    --protocol tcp --port 22 --cidr "$MY_IP"
fi

# Latest Amazon Linux 2023 AMI from the public SSM parameter
AMI_ID=$(aws ssm get-parameter --region "$REGION" \
  --name /aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64 \
  --query Parameter.Value --output text)

INSTANCE_ID=$(aws ec2 run-instances --region "$REGION" \
  --image-id "$AMI_ID" --instance-type t3.micro \
  --key-name "$KEY_NAME" --security-group-ids "$SG_ID" \
  --user-data "file://$SCRIPT_DIR/ec2-user-data.sh" \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=ssw590-group1-web}]' \
  --query 'Instances[0].InstanceId' --output text)

aws ec2 wait instance-running --region "$REGION" --instance-ids "$INSTANCE_ID"
PUBLIC_DNS=$(aws ec2 describe-instances --region "$REGION" --instance-ids "$INSTANCE_ID" \
  --query 'Reservations[0].Instances[0].PublicDnsName' --output text)

echo "Instance: $INSTANCE_ID"
echo "Website (ready 2-3 minutes after boot): http://$PUBLIC_DNS"
