#!/usr/bin/env bash
# Installs/updates the spec-driven skills into ~/.claude/skills.
# Replaces ONLY the skills listed below; every other directory is left untouched.
set -euo pipefail

REPO="alefcastelo/spec-skills"
SKILLS=(specify write-tasks implement archive plan validate review learning)
DEST="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"

command -v gh >/dev/null 2>&1 || { echo "error: gh CLI is required ($REPO is private)"; exit 1; }
gh auth status >/dev/null 2>&1 || { echo "error: gh is not authenticated (run: gh auth login)"; exit 1; }

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

echo "Downloading $REPO..."
gh api "repos/$REPO/tarball" > "$tmp/repo.tar.gz"
mkdir -p "$tmp/src"
tar -xzf "$tmp/repo.tar.gz" -C "$tmp/src" --strip-components=1

mkdir -p "$DEST"
for skill in "${SKILLS[@]}"; do
  if [ ! -d "$tmp/src/$skill" ]; then
    echo "warn: $skill not found in repo, skipped"
    continue
  fi
  rm -rf "${DEST:?}/$skill"
  cp -R "$tmp/src/$skill" "$DEST/$skill"
  echo "updated: $skill"
done

echo "Done. Skills installed to $DEST — other directories untouched."
