# Contributing

Thank you for your interest in contributing to our Terraform modules repository!

## Getting Started

- Please read the [docs/CONTRIBUTING_GUIDELINES.md](./docs/CONTRIBUTING_GUIDELINES.md) for detailed contribution guidelines.
- For development environment setup, see [docs/DEV_SETUP.md](./docs/DEV_SETUP.md).
- For module usage and creation, see [docs/MODULES.md](./docs/MODULES.md).
- For best practices, see [docs/BEST_PRACTICES.md](./docs/BEST_PRACTICES.md) and [awesome-nan](https://github.com/nanlabs/awesome-nan).
- For versioning and release strategy, see [docs/VERSIONING.md](./docs/VERSIONING.md).

## Pull Requests

- Ensure your code follows the repository's style and best practices.
- Add or update documentation as needed.
- **Update the [CHANGELOG.md](./CHANGELOG.md)** under the `[Unreleased]` section with your changes.
- **Specify release type** in your PR description if your changes should trigger a new release (see [Versioning Strategy](./docs/VERSIONING.md)).
- Run all tests and linters before submitting.
- Reference related issues in your PR description.

## Code of Conduct

Please read and follow our [Code of Conduct](./CODE_OF_CONDUCT.md).

## Reporting Bugs/Feature Requests

We welcome you to use the GitHub issue tracker to report bugs or suggest features.

When filing an issue, please check existing open, or recently closed, issues to make sure somebody else hasn't already
reported the issue. Please try to include as much information as you can. Details like these are incredibly useful:

- A reproducible test case or series of steps
- The version of our code being used
- Any modifications you've made relevant to the bug
- Anything unusual about your environment or deployment

### Reporting Bugs

This section guides you through submitting a bug report for this project. Following these guidelines helps maintainers and the community understand your report, reproduce the behavior, and find related reports.

When creating bug reports please fill out [the required template](./.github/ISSUE_TEMPLATE/bug_report.md), the information it asks for helps us resolve issues faster.

### Suggesting Enhancements

This section guides you through submitting an enhancement suggestion for this project, including completely new features and minor improvements to existing functionality. Following these guidelines helps maintainers and the community understand your suggestion and find related suggestions.

When creating enhancement suggestions, please fill in [the template](./.github/ISSUE_TEMPLATE/feature_request.md), including the steps that you imagine you would take if the feature you're requesting existed.

## Contributing via Pull Requests

Contributions via pull requests are much appreciated. Before sending us a pull request, please ensure that:

1. You are working against the latest source on the _main_ branch.
2. You check existing open, and recently merged, pull requests to make sure someone else hasn't addressed the problem already.
3. You open an issue to discuss any significant work - we would hate for your time to be wasted.

To send us a pull request, please:

1. Fork the repository.
2. Modify the source; please focus on the specific change you are contributing. If you also reformat all the code, it will be hard for us to focus on your change.
3. Ensure local tests pass (_if applicable_).
4. **Update CHANGELOG.md** with your changes under the `[Unreleased]` section.
5. **Specify release type** in your commit message or PR description if needed (e.g., `release-type: minor`).
6. Commit to your fork using clear commit messages.
7. Send us a pull request, answering any default questions in the pull request template.
8. Pay attention to any automated CI failures reported in the pull request, and stay involved in the conversation.

GitHub provides additional document on [forking a repository](https://help.github.com/articles/fork-a-repo/) and
[creating a pull request](https://help.github.com/articles/creating-a-pull-request/).

## Finding contributions to work on

Looking at the existing issues is a great way to find something to contribute on. As our projects, by default, use the default GitHub issue labels (enhancement/bug/duplicate/help wanted/invalid/question/wontfix), looking at any 'help wanted' issues is a great place to start.

## Coding Guidelines

### Writing Terraform Code

- Follow the [Terraform Style Guide](https://www.terraform-best-practices.com/style-guide)
- Use consistent naming conventions
- Add proper variable validation
- Include comprehensive documentation
- Write clear and descriptive commit messages
- Test your changes locally before submitting
- Follow the module structure in `modules/__template__`
- Use terraform-docs to generate documentation
- Run terraform fmt before committing
- Validate your code with terraform validate
- Check for security issues with tfsec

### Writing Shell Scripts

- Follow shell scripting best practices (e.g. as described in
  [Google's shell style guide](https://google.github.io/styleguide/shell.xml))
- Try to be POSIX compliant
- Use `"${variable}"` instead of `$variable`
- Constants (and global variables) should be in `UPPER_CASE`, other variables
  should be in `lower_case`
- Use single square brackets (`[ condition ]`) for conditionals
  (e.g. in 'if' statements)
- Write clean and readable code
- Write comments where needed (e.g. explaining functions)
- Explain what arguments a function takes (if any)
- Use different error codes when exiting and explain when they occur
  at the top of the file
- If you've created a new file or have made a lot of changes
  (judge this by yourself), you can add a copyright disclaimer below the shebang
  line and below any other copyright notices
  (e.g. `Copyright (C) Jane Doe <contact@jane.doe>`)
- Always line wrap at 80 characters
- Scripts should not have an extension, e.g. `./example.sh` should be `./example`.
- Libraries should always have a `.sh` extension and should not have a shebang
- Neither scripts nor libraries should be executable (their permissions are
  set during compilation)
- Use `shellscript` to error-check your code
- Test your code before submitting a PR (not required if it's a draft)
- Write long and informative commit messages

### Writing Dockerfiles

- Follow the [Dockerfile best practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- Use multi-stage builds when appropriate
- Keep images as small as possible
- Use specific version tags
- Include health checks
- Follow security best practices
- Document any non-obvious choices
