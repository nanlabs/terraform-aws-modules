## Description

Please include a summary of the changes and the related issue. List any dependencies that are required for this change.

Fixes # (issue)

## Type of Change

- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update

## 📝 Changelog Entry

Please add your changes to the [CHANGELOG.md](../CHANGELOG.md) file under the `[Unreleased]` section:

- [ ] Added entry to CHANGELOG.md under appropriate section (Added/Changed/Fixed/etc.)
- [ ] No changelog entry needed (documentation, internal changes, etc.)

**Changelog Entry:**

```markdown
- Your change description here (#PR-number)
```

## 🏷️ Release Type

If this change should trigger a new release, specify the type (see [Versioning Strategy](../docs/VERSIONING.md) for details):

- [ ] `patch` - Backwards compatible bug fixes
- [ ] `minor` - New features (backwards compatible) **[Default]**
- [ ] `major` - Breaking changes
- [ ] No release needed

## How Has This Been Tested?

Please describe the tests that you ran to verify your changes. Provide instructions so we can reproduce.

- [ ] Test A
- [ ] Test B

## 📦 Affected Modules

List the modules that were changed in this PR:

- [ ] `module-name-1`
- [ ] `module-name-2`

## Checklist

- [ ] My code follows the style guidelines of this project
- [ ] I have performed a self-review of my code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation
- [ ] I have updated module documentation (docs/MODULE.md) if needed
- [ ] My changes generate no new warnings
- [ ] I have tested my changes with `terraform plan` and `terraform validate`
- [ ] Any dependent changes have been merged and published in downstream modules
- [ ] I have checked my code and corrected any misspellings

---

📚 **Helpful Resources:**

- [Contributing Guidelines](../docs/CONTRIBUTING_GUIDELINES.md)
- [Versioning Strategy](../docs/VERSIONING.md)
- [Modules Guide](../docs/MODULES.md)
