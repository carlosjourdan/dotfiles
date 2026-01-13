# Install and configure Claude Code

curl -fsSL https://claude.ai/install.sh | bash

if [ -z "$WORKSPACE_ROOT" ]; then
  WORKSPACE_ROOT=~
fi

cp -r ~/dotfiles/claude ${WORKSPACE_ROOT}/.claude