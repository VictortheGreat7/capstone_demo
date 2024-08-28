# Deploy a Microservices Application on Azure Kubernetes Service using GitHub Actions

## Project Overview
This project guides you through deploying a microservices application on Azure Kubernetes Service (AKS) using GitHub Actions for automation. The process includes:
- Provisioning Azure infrastructure with Terraform
- Configuring the AKS cluster using Ansible and kubectl
- Setting up basic alerting, monitoring, and logging

## Prerequisites
Before starting, ensure you have:

### Azure Account:
- Preferably with an Entra ID User Account
- Subscription Owner and Entra ID Global Administrator roles
- Funded account (some services are not free)

### Domain Provider:
- e.g., Name.com, Namecheap

### GitHub Account

### Ubuntu Environment:
- Physical machine, virtual machine, or Windows Subsystem for Linux (WSL)
- Sudo privileges required

### Required Software:
- Git
- Azure CLI
- kubectl CLI
- kubelogin CLI
- jq (JSON processor)
- cURL
- Ansible and Ansible Vault

## Step-by-Step Instructions

### 1. Repository Setup
a. Fork the repository to your GitHub account.
b. Clone the forked repository to your Ubuntu machine.

### 2. Azure Configuration
a. Log in to Azure CLI using your Entra ID User account.
b. Run the `service_principal.sh` script:
    ```bash
    chmod +x service_principal.sh
    ./service_principal.sh
    ```
    This script:
    - Creates a service principal for GitHub Actions
    - Saves details to `secrets.yaml`
    - Updates `terraform.tfvars` with your Azure user's object ID

c. Assign the "Group Administrator" role to the new Service Principal:
    - Navigate to "Microsoft Entra Roles and Administrators" in Azure Portal
    - Assign the "Group Administrator" role to the Service Principal
    - (Refer to `screenshots/group_admin_role.md` for visual instructions)

### 3. GitHub Actions Setup
a. Create secrets in your forked GitHub repository:
    - Refer to `screenshots/github_secrets.md` for guidance
    - Include secrets from `secrets.yaml` and other necessary credentials

b. Encrypt `secrets.yaml` using Ansible Vault:
    ```bash
    ansible-vault encrypt secrets.yaml
    ```
    Use the same password set for `ANSIBLE_VAULT_PASSWORD` in GitHub secrets.

### 4. Network Configuration
Run the `authorized_ips.sh` script:
    ```bash
    cd capstone_terraform
    chmod +x authorized_ips.sh
    ./authorized_ips.sh
    ```
    This script restricts cluster access to your current IP address.

### 5. Domain Configuration
a. Edit `microservices_manifests/ingress.yaml`:
    - Replace all instances of `<subdomain>.mywonder.works` with your domain
    - Example: Change `kibana.mywonder.works` to `kibana.yourdomain.com`

b. Push changes to your GitHub repository:
    - Uncomment the automatic trigger in `.github/workflows/build.yaml`
    - Comment out the manual trigger
    - Commit and push changes

### 6. DNS Configuration
a. After successful GitHub Actions deployment, locate the External IP:
    - Check GitHub Actions workflow output, or
    - Connect to the AKS cluster and run `kubectl get ingress`

b. Configure A records for each subdomain in your domain provider's DNS settings:
    - Use the obtained External IP
    - Refer to `screenshots/my_subdomain_config.md` for examples

### 7. Application Access
Access your application using the configured subdomains:
- `sockshop.yourdomain.com` (publicly accessible)
- `prometheus.yourdomain.com` (IP-restricted)
- `grafana.yourdomain.com` (IP-restricted)
- `alertmanager.yourdomain.com` (IP-restricted)
- `kibana.yourdomain.com` (IP-restricted)

Note: Certificate issuance may take some time. Initially, you might see security warnings in your browser.

### 8. Testing and Monitoring
a. Test Prometheus Alerts:
    ```bash
    kubectl apply -f microservices_manifests/loadtest-dep.yaml
    kubectl get pods -n load-test
    ```
    Monitor the Prometheus UI (`prometheus.yourdomain.com`) for alert status changes.

b. Configure Grafana Dashboards:
    - Access Grafana at `grafana.yourdomain.com` (default credentials: `admin/admin`)
    - Add Prometheus as a data source: `http://prometheus.monitoring.svc.cluster.local:9090`
    - Import and view dashboards

### 9. Cleanup
To destroy the infrastructure:
- Manually run the "Destroy Infrastructure" workflow in GitHub Actions
- Monitor the workflow progress in the GitHub Actions tab

## Additional Notes
- Run `authorized_ips.sh` only once to avoid duplicate entries
- Ensure all bash scripts are executable before running
- Double-check all configurations and secrets before deployment
- Refer to the provided screenshots and markdown files for visual guidance
