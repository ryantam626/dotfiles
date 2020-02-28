These are my machine-common dotfiles and scripts to setup my workstations.

# My steup

## General

- urxvt (terminal emulator)
- zsh (shell)

## "Desktop environment"

- xmonad (tiling window manager)
- rofi (launcher)
- xmobar (bar)
- stalonetray (tray)
- i3lock (lock)
- i3lock-fancy (lock)

## CLI

- nvim (editor)
- tmux (terminal multiplexer)

## GUI

- sublime (spare editor, config is not ported yet)
- spotify (music client, themed by spicetify)

## Other shit

- setxkbmap (changes keymap to a very custom one, to be explained some day...)
- xcape (mapping capslock to hyper modifier on long press)

# Installation steps

```
wget -O - https://raw.githubusercontent.com/ryantam626/dotfiles/master/installers/bootstrap.sh | sh
git clone https://github.com/ryantam626/dotfiles.git dotfiles
cd dotfiles
./installers/install.sh
# Say yes and change the default shell to zsh

# Quit zsh after changing the default shell

# Launch another shell with `zsh` and continue with ...
./installers/install_zsh_plugins.sh

tmux # start tmux up once to initialise some stuff
# <Ctrl-A>+<D> to detach from tmux

# back in the `zsh` you started with do ...
./installers/install-dotfiles.sh

# optionally start up neovim with `vim`, included bootstrap will install plugins after prompt

reboot
```

## Known quirks

- zsh/p10k seem to fail to load proper theme with the very first tmux managed shell;
