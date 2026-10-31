# spec-skills

Spec-driven skills for Claude Code, synced across machines. Source of truth for the nine skills installed into `~/.claude/skills`. Project-agnostic — no reference to any particular language, stack, or private repo.

## The flow

| Skill | Role |
|---|---|
| `/explore` | Explore a feature as a Product Manager and a Software Architect would, settling its product and technical direction in `.ai/<Y-m-d>-<slug>/EXPLORE.md` |
| `/specify` | Full feature: interview until shared understanding, produce `.ai/<Y-m-d>-<slug>/SPEC.md`, then run `/write-tasks` |
| `/write-tasks` | Break an agreed spec into slices/tasks → `TASK.md`, then run `/validate` |
| `/plan` | Light sibling of `/specify` for refactorings, fixes, simple changes → a single `PLAN.md` (standalone or nested in a spec); also turns `/review` findings and PR comments into a correction plan, with a ready reply for each comment it rejects |
| `/validate` | Pre-implementation check of a spec (`SPEC` + `TASK`) or a plan by four isolated sub-agents — inconsistencies, gaps, unmapped changes, implementability; runs automatically after `/write-tasks`; corrections folded into the docs |
| `/implement` | Execute a track (`TASK.md` or `PLAN.md`) end-to-end, in waves of parallel agents |
| `/review` | Review a PR against its spec and tasks with four isolated sub-agents — criteria table, bugs, side effects, scope; no nitpicks; reports in the session, never on the PR, and suggests `/plan` when there's something to fix |
| `/archive` | Move a finished spec/plan folder to `.ai/archive/` |
| `/constitution` | Build or rebuild the project's lasting decisions and tech stack in a single `.ai/CONSTITUTION.md`, revisiting every definition on each run |

## Install / update on a machine

```sh
curl -fsSL https://raw.githubusercontent.com/alefcastelo/spec-skills/main/install.sh | bash
```

Replaces only the nine skills above in `~/.claude/skills` and removes retired ones; any other skill directory is left untouched.

## Editing

Edit here, push to `main`, run the installer on the other machines.
