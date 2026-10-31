# spec-skills

Spec-driven skills for Claude Code, synced across machines. Source of truth for the ten skills installed into `~/.claude/skills`. Project-agnostic — no reference to any particular language, stack, or private repo.

## The flow

| Skill | Role |
|---|---|
| `/research` | Collaborative external research: validate hypotheses against sources, devil's advocate, living document in `docs/research/{slug}.md` that feeds a PRD/spec |
| `/explore` | Explore a feature as a Product Manager and a Software Architect would, settling its product and technical direction in `.ai/{date}-{slug}/EXPLORE.md` |
| `/specify` | Full feature: interview until shared understanding, produce `specs/{slug}/SPEC.md`, then run `/write-tasks` |
| `/write-tasks` | Break an agreed spec into slices/tasks → `TASK.md` |
| `/plan` | Light sibling of `/specify` for refactorings, fixes, simple changes → a single `PLAN.md` (standalone or nested in a spec); also turns PR review comments into a correction plan |
| `/validate` | Optional pre-implementation check of a SPEC/PLAN against gaps and the real code; corrections folded into the doc itself |
| `/implement` | Execute a track (`TASK.md` or `PLAN.md`) end-to-end, in waves of parallel agents |
| `/review` | Review a PR and post inline + summary comments on it (`COMMENT` or `REQUEST_CHANGES`, never `APPROVE`) |
| `/archive` | Move a finished spec/plan to `specs/archive/` (research docs to `docs/research/archive/`) |
| `/constitution` | Build or rebuild the project's lasting decisions and tech stack in a single `.ai/CONSTITUTION.md`, revisiting every definition on each run |

## Install / update on a machine

```sh
curl -fsSL https://raw.githubusercontent.com/alefcastelo/spec-skills/main/install.sh | bash
```

Replaces only the ten skills above in `~/.claude/skills` and removes retired ones; any other skill directory is left untouched.

## Editing

Edit here, push to `main`, run the installer on the other machines.
