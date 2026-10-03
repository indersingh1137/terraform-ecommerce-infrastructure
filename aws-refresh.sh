#!/bin/bash

# Clear old AWS environment variables
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN
unset AWS_PROFILE

echo "✅ Cleared old AWS environment variables."

# Re-authenticate (adjust profile name if needed)
PROFILE="default"   # change this if you use a custom profile
REGION="ap-south-1" # adjust to your region

echo "🔑 Logging in with AWS SSO/profile: $PROFILE"
aws sso login --profile $PROFILE

# Verify identity
echo "🔍 Verifying AWS identity..."
aws sts get-caller-identity --profile $PROFILE

# Reminder for Terraform provider block
echo "⚡ Make sure your Terraform provider block uses:"
echo "provider \"aws\" {"
echo "  region  = \"$REGION\""
echo "  profile = \"$PROFILE\""
echo "}"