# Intelligent AI App Infrastructure

This repository contains the Terraform infrastructure code for provisioning the Intelligent AI App platform on Azure. It leverages custom modules to rapidly deploy a full AI foundry, including resource groups, storage, OpenAI model deployments, AI agents, and Azure Cognitive Search—all in under 500 lines of code.

## Features
- Modular Terraform code for easy customization and reuse
- Automated provisioning of:
  - Azure Resource Group
  - Storage Account for AI search data
  - AI Foundry (core project/account)
  - OpenAI model deployments
  - AI Agents (e.g., recruiter agent)
  - Azure Cognitive Search
- Secure state management using Azure Storage backend
- GitHub Actions workflow for automated CI/CD

## Prerequisites
- [Terraform](https://www.terraform.io/) >= 1.5.0
- Azure CLI (`az`)
- Access to required Azure resources and permissions

## Setup
1. **Clone the repository:**
   ```sh
   git clone https://github.com/pick2solutions/intelligent-ai-app.git
   cd intelligent-ai-app/infrastructure
   ```
2. **Configure backend:**
   Edit `backend.conf` with your Azure Storage backend details.

3. **Set required variables:**
   - `subscription_id`: Your Azure Subscription ID
   - `azure_ai_token`: Retrieve with:
     ```sh
     export AZURE_AI_TOKEN=$(az account get-access-token --resource 'https://ai.azure.com' --query 'accessToken' -o tsv)
     ```
   - Add these to `terraform.tfvars` or pass as CLI variables.

4. **Initialize Terraform:**
   ```sh
   terraform init -backend-config=backend.conf
   ```

5. **Plan and apply:**
   ```sh
   terraform plan
   terraform apply
   ```

## CI/CD
This repo includes a GitHub Actions workflow (`.github/workflows/publish.yml`) that:
- Logs into Azure using OIDC
- Retrieves the Azure AI token
- Runs Terraform from the `infrastructure` directory
- Applies changes automatically on push to `main`

## Custom Modules
Modules are referenced locally from the `../modules` directory. See `main.tf` for usage examples.

## Security
- Sensitive variables (like `azure_ai_token`) should never be committed to source control.
- State files and `.tfvars` are gitignored by default.

## License
MIT
