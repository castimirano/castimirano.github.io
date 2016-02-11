#!/bin/bash
SOURCE_BRANCH="source"
DESTINATION_BRANCH="master"

rm -rf dist
echo "Starting deployment"
echo "Source branch: $SOURCE_BRANCH | Target branch: $DESTINATION_BRANCH"

CURRENT_COMMIT=`git rev-parse HEAD`

echo "Compiling site"
git checkout -B $SOURCE_BRANCH
grunt build || exit 1

echo "Pushing new content to $ORIGIN_URL"
cd dist
git init
git remote add origin git@github.com:castimirano/castimirano.github.io.git
git add -A . || exit 1
git commit --allow-empty -m "Regenerated static content for $CURRENT_COMMIT" || exit 1
git push origin $DESTINATION_BRANCH --force --quiet

echo "Deployed successfully."
