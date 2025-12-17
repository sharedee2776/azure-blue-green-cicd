#!/bin/bash
set -e

RESOURCE_GROUP=$1
APP_NAME=$2

if [ -z "$RESOURCE_GROUP" ] || [ -z "$APP_NAME" ]; then
  echo "❌ Usage: ./swapslots.sh <resource-group> <app-name>"
  exit 1
fi

echo "🔁 Swapping deployment slots..."
echo "Staging ➜ Production"

az webapp deployment slot swap \
  --resource-group "$RESOURCE_GROUP" \
  --name "$APP_NAME" \
  --slot staging \
  --target-slot production

echo "✅ Slot swap completed successfully"