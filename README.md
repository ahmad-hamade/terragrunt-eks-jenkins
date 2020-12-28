# Scalable EKS platform (with Jenkins)

![Terraform](https://img.shields.io/badge/Terraform-v0.13-blue.svg)
![Terragrunt](https://img.shields.io/badge/Terragrunt-v0.26-blue.svg)

A sample project for setting up an EKS cluster that runs Jenkins configured as a code and installed via terraform/terragrunt.

- [Scalable EKS platform (with Jenkins)](#scalable-eks-platform-with-jenkins)
  - [What does it create](#what-does-it-create)
    - [Base infrastructure](#base-infrastructure)
    - [Applications infrastructure](#applications-infrastructure)
  - [Setup (macOS)](#setup-macos)
  - [Setup infra configuration](#setup-infra-configuration)
  - [Deployment](#deployment)
    - [Setup terra* tools](#setup-terra-tools)
    - [Route53 setup](#route53-setup)
    - [Deploy the rest](#deploy-the-rest)
    - [Build Jenkins agent image](#build-jenkins-agent-image)
  - [Code checks](#code-checks)

## What does it create

This project will create the following AWS services:

### Base infrastructure

- VPC (with private and public subnets across all AZ)
- EKS cluster with 2 worker groups for `apps` and `jenkins`
- Route53 public zone
- Public ACM
- S3 Logging bucket (used to log events in S3 and ALB)

### Applications infrastructure

- Jenkins
- K8s namespace
- K8s RBAC for the created namespace
- ECR for a sample tomcat-app

## Setup (macOS)

Install dependencies via Homebrew and setup terraform and terragrunt respectively:

  ```bash
  # Adds more repos to the list of formulae
  brew tap sigsegv13/tgenv
  brew tap liamg/tfsec
  brew tap versent/homebrew-taps
  brew tap etopeter/tap

  # Install packages
  brew install awscli pre-commit tflint \
              tfenv tgenv terraform-docs shellcheck gawk liamg/tfsec/tfsec

  # Install terraform and terragrunt from inside terraform folder
  cd terraform/terragrunt
  tfenv install
  tgenv install
  ```

## Setup infra configuration

Make sure you update the below files to match the AWS account ID along with other configurations:

Rename the folder `eu-central-1` under `./terraform/terragrunt/non-prod/` to match the region ID where you want to deploy the resources.

- ./terraform/terragrunt/global.yaml
- ./terraform/terragrunt/non-prod/account.yaml
- ./terraform/terragrunt/non-prod/`<REGION>`/region.yaml
- ./terraform/terragrunt/non-prod/`<REGION>`/dev/env.yaml

There are few standard tags that are added by default to all AWS resources and you can add/remove keys from the root [terragrunt.hcl](./terraform/terragrunt/terragrunt.hcl) under `locals` declaration with name `standard_tags`.

## Deployment

### Setup terra* tools

Please make sure to run the below commands to install and configure `terraform` and `terragrunt` before proceeding with the next steps:

```bash
cd ./terraform/

tfenv install
tgenv install
```

### Route53 setup

Route53 public zone is used to expose the services outside world with a friendly name.
You need to have a registered domain in order to use it with AWS. You need to ensure deploying the below component before start deploying anything else:

```bash
cd ./terraform/terragrunt/non-prod/<REGION>/<ENV>/base-infra/route53-public

terragrunt apply --terragrunt-non-interactive
```

> ⚠️ **Note:**  Make sure to wait till TTL is expired and your domain is using Route 53 NAMEservers before proceeding to the next steps.

### Deploy the rest

You can apply all components by running the following command:

```bash
cd ./terraform

terragrunt apply-all --terragrunt-working-dir terragrunt/non-prod \
--terragrunt-non-interactive --terragrunt-parallelism 1
```

### Build Jenkins agent image

Jenkins setup has pre-defined kubernates agent that is used to run pipelines. You need to run the below comand in order to build and push the image to ECR repo:

```bash
cd ./docker-images/jenkins

make dev aws=<AWS_ACCOUNT_ID> region=<AWS_REGION_ID>
```

## Code checks

To keep the files linted with all checks (tf, hcl, json, yaml), all you need is to run the following from the root of the repo:

```bash
pre-commit run -a
```
