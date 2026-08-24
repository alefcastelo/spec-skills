#!/usr/bin/env bash
# Installs/updates the spec-driven skills into ~/.claude/skills.
# Replaces ONLY the skills listed below; every other directory is left untouched.
set -euo pipefail

REPO="alefcastelo/spec-skills"
SKILLS=(specify write-tasks implement archive plan validate review never-again learning research)
DEST="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

echo "Downloading $REPO..."
curl -fsSL "https://github.com/$REPO/archive/refs/heads/main.tar.gz" -o "$tmp/repo.tar.gz"
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
