#!/usr/bin/env bash
set -e

SKILL_NAME="$1"

if [ -z "$SKILL_NAME" ]; then
  echo "Usage: $0 <skill-name>"
  exit 1
fi

SKILL_DIR="$(pwd)/$SKILL_NAME"

if [ -d "$SKILL_DIR" ]; then
  echo "Error: directory '$SKILL_NAME' already exists"
  exit 1
fi

mkdir -p "$SKILL_DIR"

cat > "$SKILL_DIR/SKILL.md" <<EOF
---
name: $SKILL_NAME
description:
argument-hint:
---

# $SKILL_NAME

## Instructions

1.
EOF

echo "Created $SKILL_NAME/SKILL.md"
