#!/bin/bash
REVIEWERS=${REVIEWERS:-"pheadra,nihsmik"}
REMOTE=${REMOTE:-"upstream"}
BRANCH=${BRANCH:-"master"}

if [ -n "$(git status --ignore-submodules --porcelain)" ]; then
  >&2 echo "Working directory is dirty"
  exit 1
fi

set -ex
gh pr create -B "$BRANCH" -r "$REVIEWERS" $*
gh merge "$pr"

git pull --ff-only "$REMOTE" "$BRANCH"

if [ "$BRANCH" = "master" ]; then
    git checkout develop
    git pull --ff-only ${REMOTE} develop
    git merge master -m 'Sync with master'
    git push ${REMOTE} develop
fi
