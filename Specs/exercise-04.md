# Exercise 04: Using Locals to Avoid Redundancies

## Prompt to generate this exercise

```
Using @Specs/you.md, create Exercise 4 that teaches students about Terraform locals.

Requirements:
- Start with code from Exercise 3 (provide it in starter/ directory)
- Guide students to identify repeated values and code redundancies
- Clearly explain the difference between variables (inputs) and locals (computed values)
- Create locals for: bucket_name, common_tags, all_tags, is_production, requires_backup
- Demonstrate the DRY principle (Don't Repeat Yourself)
- Show how to use locals to reference other locals
- Use merge() to combine common_tags with additional_tags
- Add computed boolean values (is_production, requires_backup)
- Include terraform console examples for debugging locals
- Add comprehensive comparison table: variables vs locals vs outputs
- Include reflection questions about when to use locals vs when not to
- Provide practical examples of other useful locals (timestamp, DNS names, mappings)
- Explain that locals don't appear in state file
```

## Learning objectives

1. Understand the fundamental difference between variables and locals
2. Identify code redundancies that should become locals
3. Learn to create computed/derived values with locals
4. Apply the DRY (Don't Repeat Yourself) principle
5. Use locals to reference other locals
6. Debug and inspect locals using terraform console
7. Understand when locals improve code vs when they add complexity
8. Recognize that locals are internal logic, not user inputs

## Key concepts covered

- Local values declaration with `locals {}` block
- Accessing locals with `local.name` (singular)
- Difference between variables (var.*), locals (local.*), and outputs
- Common use cases: repeated expressions, computed values, merged maps
- Using locals for bucket names, tags, boolean logic
- merge() function to combine maps
- Boolean expressions in locals (==, ||, &&)
- terraform console for debugging locals
- DRY principle in Infrastructure as Code
- Locals don't appear in state (computed on each run)
- Function analogy: variables = parameters, locals = local variables, outputs = return values

## Key distinction to emphasize

**Variables** = User configurable inputs (what users provide)
**Locals** = Computed internal values (what Terraform calculates)
**Outputs** = Results exposed externally (what Terraform returns)