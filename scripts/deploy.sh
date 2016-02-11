#!/bin/bash
SOURCE_BRANCH="source"
DESTINATION_BRANCH="master"

echo "Starting deployment"
echo "Source branch: $SOURCE_BRANCH | Target branch: $DESTINATION_BRANCH"

CURRENT_COMMIT=`git rev-parse HEAD`
ORIGIN_URL=`git config --get remote.origin.url`
ORIGIN_URL_WITH_CREDENTIALS=${ORIGIN_URL/\/\/github.com/\/\/$GITHUB_TOKEN@github.com}

echo "Compiling site"
git checkout -B $SOURCE_BRANCH
grunt build || exit 1

echo "Pushing new content to $ORIGIN_URL"
cd dist
git config --global user.name "Travis-CI" || exit 1
git config --global user.email "dev@castimirano.com" || exit 1

git init || exit 1
git add -A . || exit 1
git commit --allow-empty -m "Regenerated static content for $CURRENT_COMMIT" || exit 1
git push --force --quiet "$ORIGIN_URL_WITH_CREDENTIALS" $DESTINATION_BRANCH > /dev/null 2>&1 || exit 1

echo "Deployed successfully."
