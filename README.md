# DevOps Demo - Flask App (AWS + Docker Hub) - Windows Guide

This project is a ready-to-run DevOps demo containing:
- A minimal Flask app (app/)
- Dockerfile & docker-compose for containerization
- GitHub Actions workflows for CI (build & push) and CD (deploy via SSH)
- Terraform scripts to provision an EC2 instance and ECR repo (demo)
- Ansible playbook to configure the EC2 host and deploy the Docker container

## What you need locally (Windows)
- Install Git: https://git-scm.com/downloads
- Install Docker Desktop for Windows: https://www.docker.com/products/docker-desktop
  - Enable WSL2 backend if on Windows 10/11 (recommended)
- Install Windows Subsystem for Linux (WSL) and Ubuntu from Microsoft Store (recommended for Terraform/Ansible)
  - https://learn.microsoft.com/windows/wsl/install
- Install Terraform: https://developer.hashicorp.com/terraform/downloads
- Install AWS CLI and configure: https://aws.amazon.com/cli/
- Install Ansible (use WSL Ubuntu): `sudo apt update && sudo apt install -y ansible python3-pip`
- Create an AWS EC2 key pair in the AWS console (or use `aws ec2 create-key-pair`)

## Quick local test (Windows)
1. Build and run with Docker Desktop (PowerShell):
   ```powershell
   docker build -t youruser/devops-demo:local .
   docker run --rm -p 5000:5000 youruser/devops-demo:local
   # open http://localhost:5000
   ```

## Push to GitHub
1. Create a new repo on GitHub.
2. From PowerShell (or WSL), run:
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git branch -M main
   git remote add origin https://github.com/YOUR_USER/YOUR_REPO.git
   git push -u origin main
   ```

## GitHub Actions secrets to set (Repository -> Settings -> Secrets & variables -> Actions)
- DOCKERHUB_USERNAME : your Docker Hub username
- DOCKERHUB_TOKEN    : Docker Hub access token (recommended)
- AWS_ACCESS_KEY_ID  : (if you run Terraform in CI or locally)
- AWS_SECRET_ACCESS_KEY
- EC2_HOST           : EC2 public IP (after terraform apply)
- EC2_SSH_KEY        : your private key (.pem) content (for appleboy/ssh-action)

## Provision AWS resources (Terraform)
1. From WSL/Ubuntu or a terminal with Terraform installed and AWS credentials configured:
   ```bash
   cd terraform
   terraform init
   terraform apply -var 'key_name=YOUR_KEYPAIR_NAME'
   ```
2. Note the EC2 public IP output and copy it to `ansible/inventory.ini` or save as `EC2_HOST` secret.

## Deploy with Ansible (recommended run from WSL/Ubuntu)
1. Ensure `ansible/inventory.ini` contains the EC2 IP. Example:
   ```ini
   [web]
   34.200.123.45 ansible_user=ubuntu
   ```
2. Run the playbook:
   ```bash
   cd ansible
   ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory.ini playbook.yml --key-file ~/.ssh/YOUR_KEY.pem
   ```

## Manual deploy via script (PowerShell or WSL)
   ```bash
   bash scripts/build_and_push.sh yourdockerhubuser/devops-demo latest
   bash scripts/deploy_on_ec2.sh EC2_PUBLIC_IP yourdockerhubuser/devops-demo:latest ~/.ssh/YOUR_KEY.pem
   ```

## Verify
- Open http://EC2_PUBLIC_IP in your browser. You should see the JSON response from the Flask app.

## Notes & security
- This repo uses wide-open security group rules for demo purposes (0.0.0.0/0). **Do not use this in production.**
- Do not store private keys in the repo. Use GitHub Secrets for CI.
- Consider GitHub OIDC for production pipelines to avoid long-lived AWS credentials.

## Next steps (if you want more)
- Replace Docker Hub with AWS ECR (I can provide the modified workflows).
- Add Helm & Kubernetes deployment (minikube or EKS).
- Add monitoring (Prometheus + Grafana) and log aggregation.
