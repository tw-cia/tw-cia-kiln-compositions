---
name: kcl-primer
description: >
  KCL syntax reference, error diagnosis, and workspace example discovery
  for Kiln compositions. Use when working on KCL, hitting syntax errors,
  or confused about dictionary/lambda syntax.
---

# KCL Primer Skill

## When to Use This

Invoke with `/kcl-primer` or I'll suggest it when:
- You're writing KCL composition code
- Rendering fails with `InvalidSyntax` errors
- You see "unexpected token" or "expected one of" errors
- Dictionary/lambda/schema syntax is unclear

## Most Critical: Dictionary Syntax

**KCL dictionaries use `key = value` on SEPARATE LINES (no commas)**

❌ **WRONG** (JSON-like):
```kcl
{key: "value", nested: {inner: "data"}}
```

✅ **RIGHT** (KCL):
```kcl
{
    key = "value"
    nested = {
        inner = "data"
    }
}
```

This is the #1 syntax error. If rendering fails with:
- `expected one of ["}"] got ,`
- `expected one of [":"] got =`
- `unexpected token ','`

→ It's almost always the dictionary syntax.

## Composition Function Template

```kcl
# Lambda function signature
composeMyComposition = lambda oxr, ocds -> [{str:any}] {
    # oxr = observed composite resource (the XR the user creates)
    # ocds = observed composed resources (map of already-created resources)
    
    # Build your resources here
    resource1 = {
        apiVersion = "group/v1"
        kind = "ResourceType"
        metadata = {name = oxr.spec.name}
        spec = {forProvider = {...}}
    }
    
    resource2 = {
        apiVersion = "group/v1"
        kind = "ResourceType2"
        metadata = {name = oxr.spec.name + "-extra"}
        spec = {forProvider = {...}}
    }
    
    # Return as list
    [resource1, resource2]
}
```

## Schema Template

```kcl
schema MyCompositionSpec:
 name: str                       # Required string
 count: int = 5                  # Optional with default
 tags: {str: str} = {}           # Dict type
 enabled: bool = True            # Boolean

schema MyCompositionStatus:
 ready: bool = False
 message: str = ""
```

**Rules:**
- Use `=` not `:` for defaults
- Require type annotations: `name: str`
- Use 1-space indentation (not 4)

## Common Error Patterns

| Error | Cause | Fix |
|-------|-------|-----|
| `expected one of ["}"] got ,` | Commas in dict | Remove commas, use newlines |
| `expected one of [":"] got =` | Using `=` in dict | Use `=` not `:` |
| `unexpected token 'indent'` | Indentation/newlines in YAML string | Check schemas have minimal indent |
| `name 'X' is not defined` | Variable typo or scope issue | Check variable names |

## Finding Examples

Working Kiln compositions in your workspace:
- `cia-infra-test/kcl-scripts/staticwebsite.k`
- `cia-infra-test/kcl-scripts/iamrole.k`
- `lazy-crossplane/kcl-scripts/staticwebsite.k`

When syntax is unclear, **search for similar patterns in these files first**.

## KCL Key Differences from Python

| Feature | Python | KCL |
|---------|--------|-----|
| Dicts | `{k: v, k2: v2}` | `{k = v\n k2 = v2}` |
| Commas | Between items | NOT between dict properties |
| Testing | `assert`, `try/except` | `kiln render` only |
| Functions | `def foo():` | `foo = lambda x ->` |
| Types | Optional | Required in schemas |
| Return | explicit `return` | Implicit (last expression) |

## Quick Troubleshooting

**Q: Rendering fails with syntax error but code looks right**
→ Search workspace examples for the same pattern

**Q: Dictionary keeps getting "expected }" errors**
→ Remove ALL commas between properties, use newlines

**Q: Can't write unit tests with `kcl test`**
→ KCL has no assertions; validate with `kiln render`

**Q: Schema indentation causes parse errors**
→ Use minimal indentation (1 space), kiln import auto-fixes

**Q: Lambda returning empty list `[]`**
→ That's valid; compose returns all resources it created

## Resources

- **KCL Guide for Kiln**: `kcl-guide-for-kiln.md` in this skills directory (Kiln-specific patterns)
- **Official KCL Docs**: https://www.kcl-lang.io/docs/user_docs/guides/ (language reference)
- **Kiln Docs**: `kiln docs` (comprehensive, dense)
- **Working Examples**: Search for `*.k` files in other Kiln projects' `kcl-scripts/` directories
