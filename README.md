# dotfiles

## Fresh install

Install [iTerm2](https://iterm2.com) manually, then:

```
git clone https://github.com/freddie-w/dotfiles ~/.dotfiles
cd ~/.dotfiles
./install
```

`./install` installs Homebrew if missing (using Workbrew's `brew` on work Macs),
everything in the `Brewfile`, oh-my-zsh and its plugins, links the configs, and
installs node via mise.

To load the iTerm2 settings: Settings > General > Settings > "Load settings from
a custom folder or URL" > `~/.dotfiles/iterm2`.

## Update existing installation

```
cd ~/.dotfiles
git pull
./install
```
