# Jenkins agent docker files

This folder contains docker files used as agent with Jenkins.

Trigger docker builds and push the image to the ECR repository using the following commands:

```bash
make dev image=backend tag=latest aws=<AWS_ACCOUNT_ID> region=<AWS_REGION_ID>  # Build and push image to DEV
```
