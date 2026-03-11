#!/bin/bash
#========================================================================================================================================
# CyborgAI CC BY-NC-ND 4.0 Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International  https://github.com/cyborg-ai-git
#========================================================================================================================================


DIRECTORY_BASE=$(dirname "$(realpath "$0")")
PACKAGE_NAME="$(basename "$DIRECTORY_BASE")"
GITHUB_BASE="https://github.com/cyborg-ai-git/$PACKAGE_NAME"
# ---------------------------------------------------------------------------------------------------------------------------------------
clear
# ---------------------------------------------------------------------------------------------------------------------------------------
echo -e "🟢 CREATE PRIVATE REPOSITORY GITHUB $DIRECTORY_BASE $PACKAGE_NAME"
current_time=$(date +"%Y.%-m.%-d%H%M")
CURRENT_DIRECTORY=$(pwd)
# ---------------------------------------------------------------------------------------------------------------------------------------
cd $DIRECTORY_BASE
# ---------------------------------------------------------------------------------------------------------------------------------------
git init .
git add .
git commit -am "$PACKAGE_NAME init $current_time"
#gh auth login
gh repo create $PACKAGE_NAME --private --description "$PACKAGE_NAME"

git branch -M main
git remote add origin "$GITHUB_BASE.git"
git push -u origin main
# ---------------------------------------------------------------------------------------------------------------------------------------
cd "$CURRENT_DIRECTORY"
# ---------------------------------------------------------------------------------------------------------------------------------------