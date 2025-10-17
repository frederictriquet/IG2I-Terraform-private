# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Terraform training repository for IG2I students. It contains progressive exercises teaching Infrastructure as Code concepts, from basic state management to advanced variable usage and locals.

## Repository Structure

The repository follows a consistent pedagogical structure:

```
exercise-XX/
├── README.md           # Exercise instructions in English (summary)
├── starter/           # Starting point for students (may be empty or contain base code)
│   ├── main.tf
│   ├── variables.tf   # (from exercise 3+)
│   └── outputs.tf     # (from exercise 3+)
└── solution/          # Complete reference solution
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    ├── locals.tf      # (from exercise 4+)
    └── terraform.tfvars
```

- `Specs/` - Contains detailed exercise specifications in French (full instructions)
- `cours.md` - Marp presentation slides covering Terraform fundamentals (in French)

## Exercise Progression

The exercises build progressively on each other:

1. **Exercise 01** - Random provider: Understanding Terraform state without cloud credentials
2. **Exercise 02** - First AWS deployment with S3 buckets
3. **Exercise 03** - Variables and terraform.tfvars files
4. **Exercise 04** - Locals for computed values and avoiding repetition
5. **Exercise 05** - (Planned)

Each exercise teaches specific concepts while reinforcing previous knowledge.

## Key Terraform Concepts

### File Organization Pattern (from exercise 3+)

- `main.tf` - Primary resource definitions and provider configuration
- `variables.tf` - Input variable declarations with types, descriptions, defaults
- `outputs.tf` - Output value definitions for displaying results
- `locals.tf` - Local values for computed/derived values (exercise 4+)
- `terraform.tfvars` - Default variable values (not committed to Git)

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

### State Management

- `terraform.tfstate` contains the current infrastructure state
- State is crucial for idempotency - Terraform tracks what exists vs what should exist
- State files should NEVER be committed to Git (contain sensitive data)
- The random provider demonstrates state concepts without needing cloud access

### Variables vs Locals

- **Variables** (`var.*`) - External inputs, configurable by users
- **Locals** (`local.*`) - Internal computed values, derived from variables or resources
- Variables should be in `variables.tf`, locals in `locals.tf`

### Common Patterns

**Unique naming with random provider:**
```hcl
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "example" {
  bucket = "${var.bucket_prefix}-${random_id.bucket_suffix.hex}"
}
```

**Conditional resource creation:**
```hcl
resource "aws_s3_bucket_versioning" "example" {
  count = var.enable_versioning ? 1 : 0
  # ...
}
```

**Tag merging:**
```hcl
locals {
  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
  all_tags = merge(local.common_tags, var.additional_tags)
}
```

## AWS Configuration

Students use either:
- **AWS Academy** accounts (temporary credentials)
- **Personal AWS accounts** (standard credentials)

Credentials configured via:
- AWS CLI: `aws configure`
- Environment variables: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_DEFAULT_REGION`

Default region used in exercises: `eu-west-3` (Paris)

## Working with This Repository

### When Creating New Exercises

- Follow the established structure: `starter/` and `solution/` directories
- Write detailed specs in French in `Specs/exercise-XX.md`
- Write concise English README in `exercise-XX/README.md`
- Solutions should be complete, working examples
- Starter code should contain just enough to guide students

### When Modifying Exercises

- Maintain backward compatibility with previous exercises
- Update both starter and solution directories
- Test that `terraform init`, `plan`, and `apply` work correctly
- Ensure all variables have descriptions and sensible defaults

### When Reviewing Student Code

- Check file organization (proper separation of variables, main, outputs)
- Verify sensitive values are marked with `sensitive = true`
- Ensure no hardcoded credentials or state files
- Look for proper use of variables vs locals
- Validate that naming follows conventions (`var.name` not `vars.name`)

## Important Reminders

- **State files** (`terraform.tfstate`, `terraform.tfstate.backup`) contain sensitive data and should never be committed
- **S3 bucket names** must be globally unique across all AWS accounts
- **Provider versions** should be pinned with `~>` to allow patch updates
- **Outputs** marked as `sensitive` won't display in plan/apply output
- **Random resources** persist in state - they don't regenerate on each apply unless tainted or destroyed

## Common Commands for Development

```bash
# Format all Terraform files recursively
terraform fmt -recursive

# Validate configuration
terraform validate

# View current state
terraform show

# List resources in state
terraform state list

# Interactive console for testing expressions
terraform console
```

## Testing Exercise Solutions

```bash
cd exercise-XX/solution
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply -auto-approve
terraform output
terraform destroy -auto-approve
```

## Documentation References

- Terraform Registry: https://registry.terraform.io/
- AWS Provider: https://registry.terraform.io/providers/hashicorp/aws
- Random Provider: https://registry.terraform.io/providers/hashicorp/random
- HashiCorp Learn: https://learn.hashicorp.com/terraform
