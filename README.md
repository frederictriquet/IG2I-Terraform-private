# Terraform Training Repository - IG2I

This repository contains progressive exercises teaching Infrastructure as Code concepts with Terraform, designed for IG2I students.

## Course Presentation

- **Interactive Slides**: [Terraform Introduction Course](https://frederictriquet.github.io/IG2I-Terraform/)
- **PDF with Slides**: [cours-slides.pdf](https://frederictriquet.github.io/IG2I-Terraform/cours-slides.pdf) - Presentation format (one slide per page)
- **PDF Continuous**: [cours-continuous.pdf](https://frederictriquet.github.io/IG2I-Terraform/cours-continuous.pdf) - Document format (no slide breaks)

## Repository Structure

The exercises build progressively on each other:

- **Exercise 01** - Random provider: Understanding Terraform state without cloud credentials
- **Exercise 02** - First AWS deployment with S3 buckets
- **Exercise 03** - Variables and terraform.tfvars files
- **Exercise 04** - Locals for computed values and avoiding repetition
- **Exercise 05** - (Planned)

Each exercise contains:
- `starter/` - Starting point for students
- `solution/` - Complete reference solution
- `README.md` - Exercise instructions (English)

## Additional Resources

- `Specs/` - Detailed exercise specifications (French)
- `cours.md` - Marp presentation slides covering Terraform fundamentals (French)
- `CLAUDE.md` - Project guidelines for Claude Code

## Getting Started

### Prerequisites

1. **Terraform** - Install from [terraform.io](https://terraform.io)
2. **AWS Account** - Either AWS Academy or personal account
3. **AWS CLI** - Configured with your credentials
4. **VS Code** (recommended) with HashiCorp Terraform extension

### Standard Terraform Workflow

```bash
terraform init      # Initialize providers and modules
terraform fmt       # Format code
terraform validate  # Validate syntax
terraform plan      # Preview changes
terraform apply     # Apply changes
terraform output    # Display outputs
terraform destroy   # Destroy all resources
```

## Key Concepts Covered

- Infrastructure as Code (IaC) fundamentals
- Terraform providers and resources
- State management and idempotency
- Variables, locals, and outputs
- File organization best practices
- AWS S3 and resource management

## Important Notes

- State files (`terraform.tfstate`) contain sensitive data and should never be committed to Git
- S3 bucket names must be globally unique across all AWS accounts
- Always use the random provider for generating unique suffixes

## Documentation

- [Terraform Documentation](https://terraform.io/docs)
- [Terraform Registry](https://registry.terraform.io/)
- [AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws)
- [HashiCorp Learn](https://learn.hashicorp.com/terraform)
