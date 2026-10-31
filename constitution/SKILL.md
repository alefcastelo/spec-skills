---
name: constitution
description: Build or rebuild the project's constitution — lasting decisions and tech stack — in .ai/CONSTITUTION.md
effort: max
---

Map this project's lasting decisions and the technology that implements them into `.ai/CONSTITUTION.md`. Run it whenever the project needs it — every run revisits every definition: $ARGUMENTS

## Decisions

Decisions that survive a technology change, in this order:

- **Architecture style** — hexagonal, clean, layered, MVC, modular monolith, microservices.
- **Layers** — which layers exist and the folder each one lives in.
- **Modules** — the modules or bounded contexts, one purpose each.
- **Dependency rule** — who may depend on whom, across layers and modules.
- **API style** — REST, GraphQL, gRPC or events; sync or async; versioning.
- **Communication between modules** — direct calls, internal events, messaging.
- **Authentication/authorization model** — token, session, OAuth; RBAC or ABAC.
- **Error handling** — domain exceptions, where they are translated, the shape the client sees.
- **Principles** — SOLID, Object Calisthenics, tactical DDD, CQS, and what each one enforces here.
- **Persistence pattern** — repository, active record, CQRS, event sourcing.
- **Transactions/consistency** — where a transaction opens; strong or eventual consistency.
- **Validation** — the layer that validates input.
- **Observability** — structured logs, tracing, metrics, as a convention.
- **Testing strategy** — the kinds of test, where each one lives, what gets mocked.

## Tech stack

The name and version behind each section, in this order:

Language/runtime · Framework · HTTP/API layer · Database · ORM/DB access · Migrations · Serialization · Validation · Messaging/queue · Cache · Auth · HTTP client · Logging/observability · Testing · Static analysis/lint · Package manager/build · Runtime infra · External services

## Format

A title, the two parts in this order, one bullet per section:

```markdown
# Constitution

## Decisions

- **Architecture style:** hexagonal, modular monolith
- **Dependency rule:** domain ← application ← infrastructure; modules talk only through events

## Tech stack

- **Framework:** {name} {version}
```

## Mapping

- MUST: Read the code before asking me anything — dispatch sub-agents, one per part, findings and evidence back, not file dumps. The code is the unique truth.
- MUST: Infer every section from the code first. Ask me only what the code can't answer.
- MUST: Read every tech stack version from the manifests and lockfiles, never from memory.
- MUST: Leave out a section the project doesn't have or that nobody can answer. An empty section is noise.
- MUST: Write one line per section, a few words stating the decision — never a paragraph or an explanation.
- DON'T: Name a tool or library under Decisions. If it changes when the framework changes, it belongs under Tech stack.

## Rebuild

- MUST: Treat the current `.ai/CONSTITUTION.md` as claims to check, never as truth — compare every section against the code on every run.
- MUST: Present the whole result in one round, per section: ✅ kept, ✏️ changed, ➕ new, ➖ removed, with the evidence (`file:line` or manifest) for every ✏️ ➕ ➖. On a first run every section is ➕.
- MUST: Show a decision the code contradicts as ✏️ or ➖. Never keep it silently.
- MUST: Put the open questions in the same round — numbered, each with your recommended answer and its tradeoff.
- MUST: Write only what I approved. A change I reject leaves the section as it was.
