# dotfiles

## Fresh install

Install [iTerm2](https://iterm2.com) manually, then run the commands below. On a
fresh Mac, the first `git` command will prompt you to install the Xcode Command
Line Tools. Click Install and rerun the clone once it finishes.

```
git clone https://github.com/freddie-w/dotfiles ~/.dotfiles
cd ~/.dotfiles
./install
```

`./install` installs Homebrew if missing (using Workbrew's `brew` on work Macs),
everything in the `Brewfile`, links the configs, and installs node via mise.

To load the iTerm2 settings: Settings > General > Settings > "Load settings from
a custom folder or URL" > `~/.dotfiles/iterm2`.

## Update existing installation

```
cd ~/.dotfiles
git pull
./install
```
