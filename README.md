# Salesforce DX Project

This project includes Stay Activity and Comp Request management features for Salesforce.

## 🔍 Automated Code Reviews with Uncle Bob

This repository enforces Clean Code principles through automated code reviews on every pull request. Our CI/CD pipeline includes Uncle Bob's Code Review workflow that checks for common code smells and quality issues.

### What Gets Reviewed

The automated workflow checks all Apex classes, triggers, Lightning Web Components, and scripts for:

- **File Length**: Files over 500 lines (complexity indicator)
- **Method Count**: Classes with 20+ methods (SRP violation)
- **Commented Code**: Excessive commented code blocks
- **Technical Debt**: Too many TODO/FIXME comments
- **Magic Numbers**: Numeric literals without meaningful names
- **Nested Conditionals**: Deeply nested if statements
- **Long Parameter Lists**: Methods with 4+ parameters
- **Generic Naming**: Classes named Manager, Handler, Processor, etc.
- **Missing Tests**: Apex classes without corresponding test classes

### How It Works

1. **Automatic Trigger**: When you create or update a pull request
2. **Code Analysis**: The workflow scans changed files for code smells
3. **Pass/Fail**: If violations are found, the PR check fails
4. **Detailed Feedback**: Review comments explain each violation with Uncle Bob's characteristic wisdom

### Clean Code Principles Enforced

Based on Robert C. Martin's "Clean Code":

- ✅ **Meaningful Names** - Intent-revealing, pronounceable identifiers
- ✅ **Small Functions** - One thing per function, 4-20 lines maximum
- ✅ **KISS** - Keep It Simple, Stupid
- ✅ **DRY** - Don't Repeat Yourself
- ✅ **SOLID** - All five principles (SRP, OCP, LSP, ISP, DIP)

### Example Violations

#### ❌ Bad
```apex
public class DataManager {  // Generic name
    public void process(String a, String b, String c, String d, String e) {  // Too many params
        if (a != null) {
            if (b != null) {
                if (c != null) {  // Nested conditionals
                    // TODO: Fix this later  // Technical debt
                    Integer x = 42;  // Magic number
                }
            }
        }
    }
}
```

#### ✅ Good
```apex
public class CustomerAccountValidator {  // Specific name
    private static final Integer MAX_RETRY_ATTEMPTS = 42;  // Named constant
    
    public void validateAccount(AccountValidationRequest request) {  // Parameter object
        if (isInvalidRequest(request)) return;  // Early return
        processValidAccount(request);  // Extracted method
    }
    
    private Boolean isInvalidRequest(AccountValidationRequest request) {
        return request == null || request.account == null;
    }
}
```

### Getting Your PR Approved

1. **Write clean code from the start** - Follow the `.cursorrules` guidelines
2. **Fix violations promptly** - Review the workflow summary for specific issues
3. **Add tests** - Every production class needs a test class
4. **Use meaningful names** - Make your code self-documenting
5. **Keep it simple** - Clever code is hard to maintain

### Local Development

The `.cursorrules` file provides real-time guidance in Cursor IDE. Use it to catch issues before pushing.

### Uncle Bob Says

> "Clean code is not about following rules dogmatically. It's about making life easier for the next developer—who might be you, six months from now, after you've forgotten everything."

> "Remember the Boy Scout Rule: Leave the code cleaner than you found it."

---

## Project Setup

### Prerequisites
- Salesforce CLI installed
- Access to a Salesforce org
- Node.js and npm installed

### Quick Start

```bash
# Clone the repository
git clone <repository-url>
cd dx-project

# Authorize your org
sf org login web --alias my-org

# Deploy to org
sf project deploy start

# Run tests
sf apex test run --test-level RunLocalTests
```

## Contributing

1. Create a feature branch from `main`
2. Make your changes following Clean Code principles
3. Write tests for your changes
4. Create a pull request
5. Address any Uncle Bob code review feedback
6. Get approval and merge

## Questions?

Review the `.cursorrules` file for detailed Clean Code guidelines and Uncle Bob's wisdom.