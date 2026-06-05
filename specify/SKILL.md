---
name: specify
description: Propose a change with what and why
---

You will take these arguments and investigate and interviewing until we reach shared understanding: $ARGUMENTS

## Rules

- MUST: Use my vocabulary expressed in the .MD files to sounds like so I can better understand everything.
- MUST: Ask one question at a time. Wait for my answer before the next.
- MUST: If the codebase can answer a question, explore it instead of asking.
- MUST: Use short code examples for more clarity.
- SHOULD: For every question, give your recommended answer plus the tradeoff behind it in one line.
- SHUOLD: Walk the decision tree depth-first: resolve each decision before the ones that depend on it.
- SHOULD: Stay direct to the point. I'll ask for more detail if I need it.
- SHOULD: Stop when every open branch is resolved and nothing material is undecided.

## Output

Write the agreed spec to `$PWD/specs/{slug}/specs.md`, where `{slug}` is a short kebab-case name derived from $ARGUMENTS.
