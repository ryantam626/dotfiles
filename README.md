These are my machine-common dotfiles and scripts to setup my workstations.

# My steup

## General

- ubuntu (OS)
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

WARNING: This installs shit ton of stuff, and only MIGHT works for debian-based system (other than 20.04 ubuntu that I am using right now), there will be a high chance of seemingly bricking your system if you are unfamiliar with the changes. The `.xsessionrc` is a particular high risk one, you will need to recover your system by editing/removing the file with a tty (Ctrl+Alt+F3 works for me).

```
wget -O - https://raw.githubusercontent.com/ryantam626/dotfiles/master/installers/bootstrap.sh | sh
git clone https://github.com/ryantam626/dotfiles.git dotfiles
cd dotfiles
# Optionally look at the `install.sh` + `installers.sh` and remove some optional stuff
./installers/install.sh
# Say yes and change the default shell to zsh

# Quit zsh after changing the default shell

# Launch another shell with `zsh` and continue with ...
./installers/install_zsh_plugins.sh

tmux # start tmux up once to initialise some stuff
# <Ctrl-B>+<D> to detach from tmux

# back in the `zsh` you started with do ...
./installers/install-dotfiles.sh

# optionally start up neovim with `vim`, included bootstrap will install plugins after prompt

reboot
```

## Known quirks

- zsh/p10k seem to fail to load proper theme with the very first tmux managed shell;
- google-chrome is not installed, yet I use it as default browser in xmonad;

# License

MIT
