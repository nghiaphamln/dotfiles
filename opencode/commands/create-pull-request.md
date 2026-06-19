---
description: Review the current branch and create a GitHub pull request
agent: plan
---

Prepare a pull request for the current branch. If the remote is GitHub, create it with the GitHub CLI after explicit confirmation. If the remote is GitLab or another host, return a ready-to-copy title and description instead of creating it.

Guidance: $ARGUMENTS

## Workflow

1. Inspect branch state with read-only commands:
   - `git status --short --branch`
   - `git branch --show-current`
   - `git remote -v`
   - determine the default/base branch from remote metadata when possible
   - `git log --oneline <base>..HEAD`
   - `git diff <base>...HEAD`

2. Detect the hosting platform from the remote URL:
   - GitHub: host contains `github.com` or a GitHub Enterprise hostname clearly indicated by the remote.
   - GitLab: host contains `gitlab.com` or a GitLab Enterprise hostname clearly indicated by the remote.
   - Other/unknown: anything else.

3. Stop and ask before continuing if:
   - there are uncommitted changes
   - the current branch is `main` or `master`
   - there are no commits ahead of the base branch
   - the base branch is ambiguous
   - GitHub creation is requested and the branch has no upstream, because it needs `git push -u origin HEAD`

4. Review the branch before PR creation or manual output:
   - summarize the functional changes
   - call out verification evidence or missing verification
   - mention risks or follow-up notes if relevant
   - do not list every changed file; the diff already shows that

5. Draft the PR title and body using this template.

Title rules:
   - short imperative phrase, about 50 characters when practical
   - no Conventional Commit prefix unless the repository explicitly requires it
   - write it like completing: "This PR will ..."

Description template:

```text
<One sentence describing what this PR does and why.>

<Brief context: what was broken, missing, or needed.>

- <Major functional change 1>
- <Major functional change 2>

Verification:
- <Command/check run, or "Not run: <reason>">

Notes:
- <Risk, migration, deployment, or follow-up note. Omit this section if empty.>
```

6. Platform-specific behavior:

GitHub:
   - Before pushing or creating/updating the PR, ask for explicit confirmation.
   - Prior approval for planning or drafting does not imply approval to push or create a PR.
   - If approved and the branch has no upstream, run `git push -u origin HEAD`.
   - If approved, run `gh pr create` with the drafted title and body.
   - Return the PR URL.

GitLab or other/unknown host:
   - Do not create a merge request automatically.
   - Return a ready-to-copy block with:
     - platform/remote host
     - source branch
     - target/base branch
     - title
     - description

If `gh pr create` fails, report the exact error and suggest the smallest fix, such as authenticating `gh`, pushing the branch, or checking whether a PR already exists.
