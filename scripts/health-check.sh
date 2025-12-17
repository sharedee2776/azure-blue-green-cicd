#!/bin/bash
set -e

APP_URL=$1

if [ -z "$APP_URL" ]; then
  echo "❌ App URL not provided"
  exit 1
fi

echo "🔍 Checking application health at $APP_URL/health"

STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$APP_URL/health")

if [ "$STATUS_CODE" -eq 200 ]; then
  echo "✅ Application is healthy (200 OK)"
else
  echo "❌ Health check failed with status code: $STATUS_CODE"
  exit 1
fi