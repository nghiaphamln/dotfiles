---
name: brainstorming
description: Use before any creative work — explores intent, requirements, and design through dialogue before implementation. No coding until design is approved.
---

# Brainstorming Ideas Into Designs

Help turn ideas into fully formed designs through natural collaborative dialogue.

Start by understanding the current project context, then ask questions one at a time to refine the idea. Once you understand what you're building, present the design and get user approval before any implementation.

<HARD-GATE>
Do NOT write any code, scaffold any project, or take any implementation action until you have presented a design and the user has approved it.
</HARD-GATE>

## Process

1. **Explore project context** — check files, docs, recent commits
2. **Ask clarifying questions** — one at a time, understand purpose/constraints/success criteria
3. **Propose 2-3 approaches** — with trade-offs and your recommendation
4. **Present design** — in sections scaled to complexity, get user approval after each section
5. **Transition to implementation** — only after user approves the design

## How to Ask Questions

- Only one question per message
- Prefer multiple choice over open-ended when possible
- Focus on: purpose, constraints, success criteria
- If scope is too large (multiple independent subsystems), flag it and help decompose first

## How to Present Design

- Lead with your recommended approach and why
- Scale each section to its complexity — a few sentences if simple, up to 200-300 words if nuanced
- Cover what's relevant: architecture, components, data flow, error handling, testing
- Ask after each section whether it looks right before continuing

## Key Principles

- **One question at a time** — don't overwhelm
- **YAGNI ruthlessly** — no unrequested features in any design
- **Explore alternatives** — always propose 2-3 approaches
- **Incremental validation** — present → get approval → move on
- **Follow existing patterns** — explore the codebase before proposing changes
