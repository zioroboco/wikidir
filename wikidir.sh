#!/bin/sh
set -e

# Use the directory "wiki" by default...
dir=wiki

init() {
  if [ -d "$1" ]; then
    echo "repo $1 already exists."
    exit 1
  fi

  # e.g. origin/master
  remote_ref=$(git rev-parse --abbrev-ref --symbolic-full-name @\{u\})

  # e.g. origin
  remote_name=$(echo "$remote_ref" | cut -d'/' -f1)

  # e.g. git@github.com:zioroboco/wikidir.git (or https://github.com/...)
  remote_url=$(git remote get-url "$remote_name")

  # e.g. zioroboco/wikidir
  repo_slug=$(echo "$remote_url" | sed 's/\.git$//' | sed 's/.*github.com//' | sed 's/^[:\/]//')

  # e.g. https://github.com/zioroboco/wikidir
  base_url="https://github.com/$repo_slug"

  # e.g. https://github.com/zioroboco/wikidir.wiki.git
  wiki_url="$base_url.wiki.git"

  echo "Cloning $wiki_url..."
  git clone "$wiki_url" "$1"

  echo "### [Docs are in the wiki.]($base_url/wiki)" >> README.md.tmp
  git add README.md.tmp
  git mv README.md.tmp "$1/README.md"

  echo "/.gitignore" >> "$1/.gitignore"
  echo "/README.md" >> "$1/.gitignore"
  git add -f "$1/.gitignore"

  echo "/$1/" >> .gitignore
  git add .gitignore
}

while [ $# -gt 0 ]; do
  case "$1" in
  -h | --help)
    echo "Usage: wikidir [-d directory] [init | ... (git args)]"
    exit 0
    ;;
  -d | --dir)
    dir=$2
    shift
    shift
    ;;
  init)
    init "$dir"
    exit 0
    ;;
  *)
    git --git-dir="$dir/.git" --work-tree="$dir" "$@"
    exit 0
    ;;
  esac
done
