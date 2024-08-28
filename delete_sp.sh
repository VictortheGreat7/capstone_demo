#!/bin/bash

# Define variables
SERVICE_PRINCIPAL_NAME="capstone-service-principal"  # Change this to the name of the service principal to delete

# Get the service principal App ID
SP_APP_ID=$(az ad sp list --filter "displayName eq '$SERVICE_PRINCIPAL_NAME'" --query "[0].appId" -o tsv)

if [ -z "$SP_APP_ID" ]; then
    echo "Service principal with name '$SERVICE_PRINCIPAL_NAME' not found."
    exit 1
fi

# Delete the service principal
echo "Deleting service principal with App ID: $SP_APP_ID"
az ad sp delete --id "$SP_APP_ID"

echo "Service principal deleted successfully!"
