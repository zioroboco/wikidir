#!/bin/sh
set -e

init() {
  if [ -d docs ]; then
    echo "docs already exists."
    exit 1
  fi

  # e.g. origin/master
  remote_ref=$(git rev-parse --abbrev-ref --symbolic-full-name @\{u\})

  # e.g. origin
  remote_name=$(echo "$remote_ref" | cut -d'/' -f1)

  # e.g. git@github.com:zioroboco/wikidir.git
  remote_url=$(git remote get-url "$remote_name")

  # e.g. zioroboco/wikidir
  repo_slug=$(echo "$remote_url" | sed 's/\.git$//' | sed 's/.*github.com//' | sed 's/://')

  # e.g. https://github.com/zioroboco/wikidir
  base_url="https://github.com/$repo_slug"

  # e.g. https://github.com/zioroboco/wikidir.wiki.git
  wiki_url="$base_url.wiki.git"

  echo "Cloning $wiki_url..."
  git clone "$wiki_url" ./docs

  echo "### [Docs are in the wiki.]($base_url/wiki)" >> README.md.tmp
  git add README.md.tmp
  git mv README.md.tmp docs/README.md

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

  if [ -n "$(git status --porcelain)" ]; then
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

if [ "$1" = init ]; then
  init
elif [ "$1" = update ]; then
  update
else
  echo "Usage: wikidir <init|update>"
  exit 1
fi
