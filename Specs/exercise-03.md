# Exercise 03: Using Variables and tfvars

## Prompt to generate this exercise

```
Using @Specs/you.md, create Exercise 3 that teaches students about Terraform variables.

Requirements:
- Start with code from Exercise 2 (provide it in starter/ directory)
- Guide students to identify hardcoded values that should become variables
- Cover all basic variable types: string, bool, map
- Teach variable validation with the encryption_algorithm example
- Demonstrate conditional resource creation using count with ternary operator
- Explain terraform.tfvars files and custom .tfvars files
- Show variable precedence (defaults, env vars, tfvars, -var-file, -var)
- Use merge() function for combining default and custom tags
- Separate code organization: variables.tf, main.tf, outputs.tf
- Include practical exercises: create production.tfvars and minimal.tfvars
- Do NOT introduce locals yet (that's for the next exercise)
- Add reflection questions about when to use variables vs hardcoded values
- Include Git best practices for .tfvars files
```

## Learning objectives

1. Understand the purpose and benefits of variables in Terraform
2. Learn to declare variables with different types
3. Implement variable validation
4. Use conditional resource creation with count
5. Master terraform.tfvars and custom .tfvars files
6. Understand variable precedence and override mechanisms
7. Organize code properly across multiple files
8. Use merge() for combining maps

## Key concepts covered

- Variable declaration with type, description, and default
- Variable types: string, bool, map(string)
- Variable validation rules
- Accessing variables with var.variable_name
- Conditional resources: count = condition ? 1 : 0
- terraform.tfvars (automatic loading)
- Custom .tfvars files with -var-file flag
- Command-line variables with -var flag
- Environment variables with TF_VAR_ prefix
- Variable precedence order
- merge() function for combining maps
- File organization best practices
- Git considerations for .tfvars files (secrets handling)