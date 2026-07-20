---
name: security-and-secrets
description: Use when a task materially affects authentication, authorization, secret or credential handling, sensitive data, permission or trust boundaries, untrusted input, or an explicit security review. Do not invoke merely because an ordinary task uses shell commands, networking, dependencies, or config.
---

# Security And Secrets

Use this when a task materially changes credentials, auth, permissions, trust boundaries, sensitive data handling, or code that processes untrusted input. Ordinary shell, network, dependency, and config work does not require this skill unless it has a concrete security-sensitive aspect.

## Hard Rules

- Do not read real environment files such as `.env`, `.env.local`, or `.env.production`, or auth files, tokens, private keys, session stores, or credential files unless the user explicitly approves and the task requires it. Safe templates such as `.env.example` and `.env.sample` may be read.
- Never print, copy, summarize, or commit secrets.
- Prefer `.env.example`, docs, schemas, or key names over real values.
- Do not add logging that can expose secrets, tokens, PII, request bodies, cookies, or authorization headers.
- Do not weaken permissions, auth checks, TLS, validation, or sandboxing without explicit user approval.

## Review Checklist

Check for:

1. Authentication vs authorization gaps.
2. Missing input validation or unsafe deserialization.
3. Command injection, path traversal, SSRF, open redirects, and unsafe shell interpolation.
4. Secrets in source, logs, diffs, generated files, or test fixtures.
5. Overly broad file, network, cloud, or database permissions.
6. Dependency or config changes that increase attack surface.
7. Error messages that leak internals or sensitive data.

## Safer Alternatives

- Use placeholders such as `<API_KEY>` or `<TOKEN>`.
- Use environment variable names, not values.
- Use read-only inspections before changing security-sensitive config.
- Ask one focused question when security intent is ambiguous.

## Reporting

State security findings with impact and the smallest safe fix. If verification is possible, include the command or inspection that proves the risk is addressed.
