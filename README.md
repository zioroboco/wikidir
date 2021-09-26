<div align="center">
  <h1>
    <p>📎</p>
    <p>wikidir</p>
  </h1>
  <p>
    Maintain your GitHub wiki alongside your code.
  </p>
  <a href="https://www.npmjs.com/package/wikidir">
    <img alt="npm" src="https://img.shields.io/npm/v/wikidir?style=flat-square">
  </a>
</div>
<br/>

## Overview

`wikidir` is a dead-simple script I wrote for getting more use out of GitHub wikis.

It's just a couple of handy commands for telling git to set up a local copy of the current repo's wiki into a git-ignored sub directory (e.g. `docs`), and to keep that copy of the wiki up to date.

## Setting up

Firstly, make sure you have initialised the wiki (by creating at least one page).

Then, navigate to the parent repo and use `wikidir init` to clone the wiki:

```sh
# clones to the `docs` directory by default...
npx wikidir init
```

Finally, put `wikidir update` somewhere that runs regularly — e.g. in `package.json`:

```json
{
  "scripts": {
    "postinstall": "npx wikidir update"
  }
}
```

Now every time you install packages, `wikidir` will pull changes. Easy!

## API

### `wikidir [-d directory] init`

The `init` command sets up a local copy of the wiki in the current repo, by:

- cloning the active repo's wiki to the specified directory
- updating the `.gitignore` in the parent repo
- adding a `README.md` with a link to the wiki (for anyone browsing on GitHub)

### `wikidir [-d directory] update`

The `update` command quietly pulls any new changes made to the wiki. It's designed to be run regularly (e.g. in a `postinstall` script) to keep the local copy of the wiki current.

Note that `update` won't pull changes if the local copy is dirty. You'll need to manually unblock it.

### `wikidir [-d directory] ...` (git args)

Finally, any arbitrary arguments will be proxied to git in the wiki repo. e.g.

  - `wikidir log --oneline`
  - `wikidir commit -am 'fix typo!'`
  - `wikidir push`

## VSCode extras

I like to clean up the file explorer by adding to `.vscode/settings.json`:

```json
{
  "files.exclude": {
    "docs/.gitignore": true,
    "docs/README.md": true
  }
}
```

The [vscode-markdown-notes](https://github.com/kortina/vscode-markdown-notes) extension also adds better support for [[wiki-style]] links, including navigation (i.e. go to definition), auto-completion, etc.

Happy docs-ing! :wave:
