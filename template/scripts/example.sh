#!/bin/bash
# Example script that can be called from SKILL.md
#
# Scripts in bundled directories are executed, not loaded into context
# This keeps context efficient while allowing complex automations
#
# Usage from SKILL.md:
#   Run the validation script: `${CLAUDE_SKILL_DIR}/scripts/example.sh $ARGUMENTS`

set -e  # Exit on error

# Access arguments passed from the skill
ARGS="$@"

echo "Running example script with arguments: $ARGS"

# Your script logic here
# - Validate inputs
# - Process data
# - Generate outputs
# - Return results

echo "Script completed successfully"
exit 0
