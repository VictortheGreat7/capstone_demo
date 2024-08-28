#!/bin/bash

# Define variables
SERVICE_PRINCIPAL_NAME="capstone-service-principal"
ROLE="Owner"
SCOPE="/subscriptions/$(az account show --query id -o tsv)"  # Get the current subscription ID
GITHUB_NAME=VictortheGreat7 # Change this to your GitHub username
GITHUB_REPO=Altschool_Capstone_Project
CREDENTIALS=$(cat <<EOF
{
    "name": "GiiHubActions",
    "issuer": "https://token.actions.githubusercontent.com/",
    "subject": "repo:$GITHUB_NAME/$GITHUB_REPO:branch:main",
    "description": "Testing",
    "audiences": [
        "api://AzureADTokenExchange"
    ]
}
EOF
)
ESCAPED_CREDENTIALS=$(echo "$CREDENTIALS" | jq -c .) # Escape the credentials for the az command
USER_OBJECT_ID=$(az ad signed-in-user show --query id) # Get the current user's object ID

# Create the service principal and assign Owner role
echo "Creating service principal with name: $SERVICE_PRINCIPAL_NAME"
SP_OUTPUT=$(az ad sp create-for-rbac --name="$SERVICE_PRINCIPAL_NAME" --role="$ROLE" --scopes="$SCOPE" --query "{appId: appId, objectId: objectId, password: password, tenant: tenant}" -o json)

# Extract the details from the output
APP_ID=$(echo $SP_OUTPUT | jq -r '.appId')
OBJECT_ID=$(echo $SP_OUTPUT | jq -r '.objectId')
PASSWORD=$(echo $SP_OUTPUT | jq -r '.password')
TENANT=$(echo $SP_OUTPUT | jq -r '.tenant')

# Display the service principal details
echo "Service Principal created successfully!"
echo "App ID (Client ID): $APP_ID"
echo "Password (Client Secret): $PASSWORD"
echo "Tenant ID: $TENANT"
echo "Subscription ID: $(az account show --query id -o tsv)"

# Save the details to a file
echo "Saving service principal details to secrets.yaml"
echo "azure:
  client_id: \"$APP_ID\"
  client_secret: \"$PASSWORD\"
  tenant_id: \"$TENANT\"
  subscription_id: \"$(az account show --query id -o tsv)\"
" >> secrets.yaml

echo "Service principal details saved to secrets.yaml"

# Add federated credentials for GitHub Actions
echo "Adding federated credentials for GitHub Actions"
az ad app federated-credential create --id $APP_ID --parameters $ESCAPED_CREDENTIALS

# Add the current user object id to the terraform.tfvars file
echo "my_user_object_id = $USER_OBJECT_ID" > capstone_terraform/terraform.tfvars