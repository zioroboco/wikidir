#!/bin/sh
set -e

init() {
  if [ -d docs ]; then
    echo "docs already exists."
    exit 1
  fi

  repo=$(node $(dirname $0)/../@zioroboco/wiki-as-docs-dir/get-repo)
  wiki="https://github.com/$repo.wiki.git"

  echo "Cloning $wiki..."
  git clone "$wiki" ./docs

  echo "# See [wiki](https://github.com/$repo/wiki) for docs..." >> docs/README.md
  git add docs/README.md

  echo "/.gitignore" >> docs/.gitignore
  echo "/README.md" >> docs/.gitignore
  git add -f docs/.gitignore

  echo "/docs/" >> .gitignore
  git add .gitignore
}

update() {
  if [ ! -d docs ]; then
    echo "docs doesn't exist."
    exit 1
  fi

  cd docs

  if [ ! -z $(git status --porcelain) ]; then
    echo "docs is dirty."
    exit 1
  fi

  git pull 1> /dev/null 2> /dev/null

  if [ $? = 0 ]; then
    echo "docs updated."
  else
    echo "docs failed to update."
  fi
}

if [ $1 = init ]; then
  init
elif [ $1 = update ]; then
  update
else
  echo "Usage: wiki-as-docs-dir <init|update>"
  exit 1
fi
