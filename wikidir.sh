#!/bin/sh
set -e

if [ ! -d .git ]; then
  echo "not a repo!"
  exit 1
fi

# Use the directory "docs" by default
dir="docs"

# e.g. git@github.com:zioroboco/wikidir.git (or https://github.com/...)
remote_url=$(git remote get-url "$(git remote)")

# e.g. zioroboco/wikidir
repo_slug=$(echo "$remote_url" | sed 's/\.git$//' | sed 's/.*github.com//' | sed 's/^[:\/]//')

# e.g. https://github.com/zioroboco/wikidir
base_url="https://github.com/$repo_slug"

# e.g. https://github.com/zioroboco/wikidir.wiki.git (must use https)
wiki_url="$base_url.wiki.git"

init() {
  if [ -d "$dir" ]; then
    echo "repo $dir already exists."
    exit 1
  fi

  echo "Cloning $wiki_url..."
  git clone "$wiki_url" "$dir"

  echo "### [Docs are in the wiki.]($base_url/wiki)" >>README.md.tmp
  git add README.md.tmp
  git mv README.md.tmp "$dir/README.md"

  echo "/.gitignore" >>"$dir/.gitignore"
  echo "/README.md" >>"$dir/.gitignore"
  git add -f "$dir/.gitignore"

  echo "\n/$dir/" >>.gitignore
  git add .gitignore
}

update() {
  if [ ! -d "$dir" ]; then
    echo "Setting up $dir directory..."
    git clone "$wiki_url" "$dir"
    exit 0
  fi

  cd $dir

  if [ -n "$(git status --porcelain)" ]; then
    echo "$dir directory is dirty: skipping update."
    exit 0
  fi

  # Shhh...
  git pull --quiet 2>/dev/null

  if [ $? != 0 ]; then
    echo "$dir directory failed to update."
  fi
}

while [ $# -gt 0 ]; do
  case "$1" in
  -h | --help)
    echo "Usage: wikidir [-d directory] [init | update | ... (git args)]"
    exit 0
    ;;
  -d | --dir)
    dir=$2
    shift
    shift
    ;;
  init)
    init
    exit 0
    ;;
  update)
    update
    exit 0
    ;;
  *)
    git --git-dir="$dir/.git" --work-tree="$dir" "$@"
    exit 0
    ;;
  esac
done
