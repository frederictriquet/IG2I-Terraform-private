# Exercise 2: First AWS Deployment with S3

## Prompt to generate this exercise

```
Using @Specs/you.md, create Exercise 2 that introduces students to AWS with S3 buckets.

Requirements:
- Use S3 as the first AWS resource (simplest AWS service, no networking required)
- Combine AWS provider with random provider for unique bucket names
- Include AWS credentials setup instructions for both AWS Academy and personal accounts
- Cover bucket creation, versioning, and encryption configuration
- Demonstrate the difference between random resources and cloud resources
- Include CLI verification steps (aws s3 commands)
- Add troubleshooting section for common AWS errors
- Focus on understanding global uniqueness of S3 bucket names
- Show implicit dependencies between S3 bucket and its configuration resources
- Include reflection questions comparing local random resources vs cloud resources
```

## Learning objectives

1. Configure AWS authentication for Terraform
2. Deploy first real cloud resource on AWS
3. Understand global uniqueness requirements (S3 bucket names)
4. Learn about AWS tags for resource organization
5. Observe differences between random provider and cloud providers
6. Understand implicit dependencies in Terraform
7. Practice AWS CLI integration with Terraform outputs

## Key concepts covered

- AWS provider configuration
- AWS credentials management (AWS Academy vs personal account)
- S3 bucket creation and configuration
- Global resource naming constraints
- Resource tagging best practices
- Implicit dependencies in Terraform
- State differences between local and cloud resources
- AWS CLI verification workflows
- Proper resource destruction (empty bucket before destroy)
