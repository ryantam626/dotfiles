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
