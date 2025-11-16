#!/bin/bash

# Check if Claude Code is installed
if ! command -v claude &> /dev/null; then
  echo "⚠️  Claude Code not found. Skipping Claude setup."
  exit 0
fi

# Claude Code settings
CLAUDE_DIR="$HOME/.claude"
mkdir -p "$CLAUDE_DIR"

ln -sf "$PWD/claude/settings.json" "$CLAUDE_DIR/settings.json"

# Link skills
SKILLS_DIR="$CLAUDE_DIR/skills"
mkdir -p "$SKILLS_DIR"

for skill_file in "$PWD/claude/skills"/**/SKILL.md; do
  if [ -f "$skill_file" ]; then
    skill_name=$(basename "$(dirname "$skill_file")")
    skill_target_dir="$SKILLS_DIR/$skill_name"
    mkdir -p "$skill_target_dir"
    ln -sf "$skill_file" "$skill_target_dir/SKILL.md"
  fi
done

CCSTATUSLINE_DIR="$HOME/.config/ccstatusline"
mkdir -p "$CCSTATUSLINE_DIR"

ln -sf "$PWD/claude/ccstatusline-settings.json" "$CCSTATUSLINE_DIR/settings.json"

echo "✓ Claude Code settings linked"
