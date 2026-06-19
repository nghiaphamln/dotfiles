---
name: brainstorming
description: "Invoke before any new feature, refactor, or non-trivial change when the user has not already specified the exact implementation. Explores intent, constraints, and proposes 2-3 approaches via dialogue. HARD GATE: no code, scaffolding, or implementation until the user approves the design. SKIP for mechanical changes already specified by the user."
---

# Brainstorming Ideas Into Designs

Help turn ideas into fully formed designs through natural collaborative dialogue.

Start by understanding the current project context, then ask questions one at a time to refine the idea. Once you understand what is being built, present the design and get user approval before implementation.

<HARD-GATE>
Do NOT write code, scaffold a project, or take implementation action until you have presented a design and the user has approved it.
</HARD-GATE>

## Process

1. Explore project context: check files, docs, and recent commits.
2. Ask clarifying questions: one at a time, focused on purpose, constraints, and success criteria.
3. Propose 2-3 approaches: include tradeoffs and a recommendation.
4. Present the design: scale detail to complexity.
5. Transition to implementation only after user approval.

## How to Ask Questions

- Ask only one question per message.
- Prefer multiple choice over open-ended when possible.
- Focus on purpose, constraints, and success criteria.
- If scope is too large, flag it and help decompose first.

## Key Principles

- YAGNI ruthlessly.
- Explore alternatives.
- Follow existing patterns.
- Prefer incremental validation over big-bang implementation.
