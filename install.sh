# Install and configure Claude Code

curl -fsSL https://claude.ai/install.sh | bash

if [ -z "$WORKSPACE_FOLDER" ]; then
  WORKSPACE_FOLDER=~
fi

cp -r ~/dotfiles/claude ${WORKSPACE_FOLDER}/.claude