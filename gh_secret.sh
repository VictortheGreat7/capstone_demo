#!/bin/bash

gh secret set ANSIBLE_VAULT_PASSWORD --repo VictortheGreat7/capstone_demo --body ""
gh secret set AZURE_CREDENTIALS --repo VictortheGreat7/capstone_demo --body '{
  "clientId": "",
  "clientSecret": "",
  "subscriptionId": "",
  "tenantId": ""
}'

gh secret set ARM_CLIENT_ID --repo VictortheGreat7/capstone_demo --body ""

gh secret set ARM_CLIENT_SECRET --repo VictortheGreat7/capstone_demo --body ""

gh secret set ARM_SUBSCRIPTION_ID --repo VictortheGreat7/capstone_demo --body ""

gh secret set ARM_TENANT_ID --repo VictortheGreat7/capstone_demo --body ""