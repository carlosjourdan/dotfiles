# Install and configure Claude Code

curl -fsSL https://claude.ai/install.sh | bash

cp -r ~/dotfiles/claude/* ~/.claude/


# Check if azure cli is installed, and if not, install it
if ! command -v az &> /dev/null; then
    echo "Azure CLI could not be found. Installing..."
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
fi

# Check if azure devops extension is installed, and if not, install it
if ! az extension list --query "[?name=='azure-devops'].name" -o tsv | grep -q "azure-devops"; then
    echo "Azure DevOps extension could not be found. Installing..."
    az extension add --name azure-devops
fi