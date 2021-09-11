#!/bin/sh
set -e

if [ -d docs ]; then
  exit 0
fi

repo=$(node ./get-repo)
wiki="ssh://git@github.com/$repo.wiki.git"

echo "Cloning $wiki..."
git clone "$wiki" ./docs

echo "# See [wiki](https://github.com/$repo/wiki) for docs..." >> docs/README.md
git add docs/README.md

echo "/.gitignore" >> docs/.gitignore
echo "/README.md" >> docs/.gitignore
git add -f docs/.gitignore

echo "/docs/" >> .gitignore
git add .gitignore
