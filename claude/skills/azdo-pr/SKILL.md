---
name: azdo-pr
description: Create an Azure DevOps PR workflow - optionally creates a new branch, reviews and organizes changes into reviewer-friendly commits, pushes to remote, creates a PR, self-approves, sets auto-complete with squash merge, and returns the PR URL.
allowed-tools: Bash, Read, Glob, Grep, Edit, Write, AskUserQuestion
---

# Azure DevOps PR Workflow

This skill automates the complete PR workflow for Azure DevOps.

## Workflow Steps

### 1. Check Prerequisites

First, verify the Azure CLI is available and the user is logged in:

```bash
az account show
az repos pr list --top 1
```

### 2. Gather Current State

Check the current git state:

```bash
git status
git branch --show-current
git diff --stat
git diff --stat --staged
```

### 3. Optional: Create New Branch

Ask the user if they want to create a new branch. If yes:
- Ask for the branch name
- Create and checkout the new branch from the current branch

**If current branch is main or master, always create a new one**

```bash
git checkout -b <branch-name>
```

### 4. Review Changes

Review all changes in the working tree:
- Show unstaged changes
- Show staged changes
- Understand what files were modified and why

### 5. Organize Commits

Organize changes into logical, reviewer-friendly commits:
- Group related changes together
- Write clear, descriptive commit messages
- **IMPORTANT: Do NOT include "Co-Authored-By:" lines in commit messages**
- Use conventional commit format when appropriate (feat:, fix:, refactor:, etc.)

Example commit format:
```
feat: Add DNS server configuration to az_network module

- Add optional dns_servers variable with empty list default
- Update virtual network resource to use custom DNS servers
- Configure DNS servers in main.tf locals
```

### 6. Push to Remote

Push the branch to the remote repository:

```bash
git push -u origin <branch-name>
```

### 7. Create Azure DevOps PR

Ask the user to choose the PR title from two suggestion, or give his input.

Then, create the PR using Azure CLI:

```bash
az repos pr create \
  --title "<PR title>" \
  --description "<PR description>" \
  --source-branch <source-branch> \
  --target-branch main \
  --output json
```

Capture the PR ID from the response.

### 8. Self-Approve the PR

Set vote to approve (10 = approve):

```bash
az repos pr set-vote \
  --id <pr-id> \
  --vote approve
```

### 9. Set Auto-Complete

Enable auto-complete with squash merge and delete source branch:

```bash
az repos pr update \
  --id <pr-id> \
  --auto-complete true \
  --squash true \
  --delete-source-branch true
```

### 10. Return PR URL

Extract and display the web URL for the PR from the creation response, or construct it:

```
https://dev.azure.com/{organization}/{project}/_git/{repo}/pullrequest/{pr-id}
```

## Output Format

At the end, provide a clear summary:

```
PR Created Successfully!

Title: <title>
PR #: <pr-id>
Source: <source-branch> -> Target: main
Status: Auto-complete enabled (squash merge, delete source branch)

PR URL: <web-url>
```

## Error Handling

- If `az` CLI is not installed or not logged in, inform the user
- If there are no changes to commit, inform the user
- If push fails due to conflicts, inform the user
- If PR creation fails, show the error message

## Notes

- This skill assumes the target branch is `main`
- The user should have appropriate permissions in Azure DevOps
- Requires Azure CLI with DevOps extension (`az extension add --name azure-devops`)
