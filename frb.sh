#!/run/current-system/sw/bin/bash

# Check for the required argument
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <commit_message>"
  exit 1
fi

# Variables
commit_message=$1
flake_dir=~/flake

# Navigate to the flake directory
cd $flake_dir || { echo "Flake directory not found. Exiting."; exit 1; }

# Ensure you are on the develop branch
git checkout develop || { echo "Failed to switch to the develop branch. Exiting."; exit 1; }

# Add all changes to the repository
git add .

# Commit with the specified message
git commit -m "$commit_message"

# Rebuild with root privileges
sudo nixos-rebuild switch --flake .#marin

