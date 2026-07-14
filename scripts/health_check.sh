#!/bin/bash

VM_IP=$1

if [ -z "$VM_IP" ]; then
    echo "Usage: $0 <VM_PUBLIC_IP>"
    exit 1
fi

URL="http://${VM_IP}:8080/devops-e2e-app/hello"

echo "Checking application at: $URL"

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$URL")

if [ "$HTTP_CODE" -eq 200 ]; then
    echo "SUCCESS"
    exit 0
else
    echo "FAILED"
    echo "HTTP Status Code: $HTTP_CODE"
    exit 1
fi
