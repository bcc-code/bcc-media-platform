#!/bin/bash

## Exit on all errors
set -euo pipefail
shopt -s inherit_errexit

# Make sure we have all tags
git fetch

# Make sure we are on master
git checkout master

if [ -z "$(git status --untracked-files=no --porcelain)" ]; then
  echo "Working directory is clean"
else
  echo "Please make sure your working directory is clean"
  exit 2
fi

git pull

VNEXT=$(git tag | grep -e 'v[[:digit:]]*' | sort -V | tail -n 1 | perl -pe 's/([0-9]+)/($1 + 1)/ge')
git tag $VNEXT
git push --tags
