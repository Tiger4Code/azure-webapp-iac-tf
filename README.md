# Provisioning Azure Web App Basic Infrastructure with Terraform

This repository contains the Terraform code needed to provision a basic infrastructure on Azure, including a Linux Virtual Machine with an Nginx web server installed. The infrastructure setup is automated and deployed using GitHub Actions.

## YouTube Tutorial

A step-by-step video tutorial for this project is available on the [Tiger4Code YouTube Channel](https://www.youtube.com/@tiger4code). The video walks through the entire process, from writing the Terraform code to deploying it to Azure using GitHub Actions.

## Project Overview

This project provisions the following Azure resources:
- **Resource Group**: A container that holds related resources.
- **Virtual Network (VNet)**: A virtual network for the infrastructure.
- **Subnet**: A logical subdivision of the virtual network.
- **Public IP Address**: Allows inbound connections to the virtual machine.
- **Network Interface (NIC)**: Connects the VM to the VNet.
- **Network Security Group (NSG)**: Secures the network interface by allowing inbound HTTP and HTTPS traffic.
- **Linux Virtual Machine (VM)**: A virtual machine running Ubuntu, with Nginx installed and configured to start on boot.

### Terraform Code

The Terraform code in this repository sets up the infrastructure as follows:

1. **Resource Group**: Defined using `azurerm_resource_group`.
2. **Virtual Network and Subnet**: Created using `azurerm_virtual_network` and `azurerm_subnet`.
3. **Public IP Address**: Provisioned with `azurerm_public_ip`.
4. **Network Interface**: Configured with `azurerm_network_interface`.
5. **Network Security Group**: Secures the VM by allowing HTTP (port 80) and HTTPS (port 443) traffic.
6. **Linux Virtual Machine**: A VM is created with Nginx installed via custom data.

### GitHub Actions Workflow

The GitHub Actions workflow in this repository automates the deployment of this infrastructure to Azure. The workflow performs the following steps:
- Checkout the code from the repository.
- Set up Terraform.
- Authenticate to Azure using a service principal.
- Initialize Terraform.
- Plan the deployment.
- Apply the Terraform plan to provision the resources.

## Getting Started

### Prerequisites

Before you begin, ensure you have the following:
- An Azure account.
- Terraform installed on your local machine.
- An SSH key pair (for connecting to the VM).
- A GitHub repository (already created).

### Steps to Deploy

1. **Clone this repository**:
   ```bash
   git clone https://github.com/Tiger4Code/azure-webapp-iac-tf.git
   cd azure-webapp-iac-tf

### Customize the variables:
Edit the `locals` block in the Terraform code to customize the resource tags and location.

### Authenticate to Azure:
Use the Azure CLI to log in and set the subscription:
   ```bash
   az login
   az account set --subscription "<YOUR_SUBSCRIPTION_ID>"
   ```

### Initialize Terraform:
   ```bash
   terraform init
   ```

### Plan the Deployment
   ```bash
   terraform plan
   ```
### Apply the Plan
   ```bash
   terraform apply
   ```
### Access the VM
    After deployment, you can access the VM using the public IP address and SSH. Open a web browser and navigate to the public IP address to see the Nginx default page.

## Workflow Details

    The GitHub Actions workflow is defined in .github/workflows/main.yml. The workflow automates the deployment process and can be triggered by a push to the main branch.

### Contributing

    Feel free to open issues or submit pull requests to improve this project.

### License

This project is licensed under the MIT License. See the LICENSE file for details.

