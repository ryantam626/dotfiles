QUIET_APT_INSTALL="sudo apt-get -qq -y -o Dpkg::Use-Pty=0 install"
SCRIPT_PATH=$(cd -P -- "$(dirname -- "$0")" && printf '%s\n' "$(pwd -P)/$(basename "$0")")
SCRIPT_DIR=$(dirname $SCRIPT_PATH)/

source $SCRIPT_DIR/helpers.sh

install_sublime() {
	info "Installing sublime\n"
	wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
	echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
	sudo apt-get update && ${QUIET_APT_INSTALL} sublime-text
}

install_python3() {
	info "Install basic python3 tool\n"
	${QUIET_APT_INSTALL} python3-pip
}

install_zsh() {
	info "Installing ZSH-related stuff\n"
	${QUIET_APT_INSTALL} zsh
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" || true



}

install_zsh_plugins() {
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH/custom/themes/powerlevel10k
	#git clone git@github.com:chisui/zsh-nix-shell.git $ZSH/custom/plugins/nix-shell
	#git clone git@github.com:spwhitt/nix-zsh-completions.git $ZSH/custom/plugins/nix-zsh-completions
	git clone https://github.com/zsh-users/zsh-completions ${ZSH}/custom/plugins/zsh-completions
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
}


install_wm() {
	info "Installing xmonad and friends\n"
	${QUIET_APT_INSTALL} xmonad xmobar stalonetray feh i3lock
	# better looking i3lock
	git clone https://github.com/meskarune/i3lock-fancy.git /tmp/lock
	pushd /tmp/lock
	sudo make install
	popd
	rm -rf /tmp/lock
}

install_launcher() {
	info "Installing a launcher\n"
	${QUIET_APT_INSTALL} rofi
}

install_terminal() {
	info "Installing terminal and tmux+tpm\n"
	${QUIET_APT_INSTALL} rxvt-unicode tmux
	TPM_DIR="~/.tmux/plugins/tpm"
	if [ -d "$TPM_DIR" ] ; then
	    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
	fi
}

install_utils() {
	info "Installing other utils\n"
	${QUIET_APT_INSTALL} \
		xsel \
		xcape \
		pavucontrol \
		fzf \
		autoconf \
		openssh-server
	sudo pip3 install thefuck

}

install_theme() {
	info "Installing theme\n"
	${QUIET_APT_INSTALL} arc-theme

	git clone https://github.com/horst3180/arc-icon-theme --depth 1 /tmp/arc-icon-theme
	pushd /tmp/arc-icon-theme
	./autogen.sh --prefix=/usr
	sudo make install
	popd
	rm -rf /tmp/arc-icon-theme
}

install_pywal() {
	info "Installing pywal and backends\n"
	sudo pip3 install pywal colorz colorthief haishoku
	${QUIET_APT_INSTALL} imagemagick -y
}

install_fonts() {
	info "Install fonts\n"
	mkdir -p ~/.fonts/
	
    wget https://github.com/adobe-fonts/source-code-pro/archive/2.030R-ro/1.050R-it.zip
    unzip 1.050R-it.zip
    cp source-code-pro-*-it/OTF/*.otf ~/.fonts/
    rm -rf source-code-pro*
    rm 1.050R-it.zip

    git clone https://github.com/powerline/fonts.git --depth=1 /tmp/fonts
    pushd /tmp/fonts
    ./install.sh
    popd
    rm -rf /tmp/fonts

    wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/UbuntuMono/Regular/complete/Ubuntu%20Mono%20Nerd%20Font%20Complete%20Mono.ttf -P ~/.fonts

    fc-cache -vf
}

install_telegram() {
	mkdir -p ~/apps
	wget https://telegram.org/dl/desktop/linux -P /tmp/telegram
	pushd /tmp/telegram
	tar -xf linux
	mv Telegram ~/apps
	popd
	rm -rf /tmp/telegram

	echo "~/apps/Telegram/Telegram" | sudo tee /usr/local/bin/telegram
	sudo chmod +x /usr/local/bin/telegram
}


install_spotify() {
	curl -sS https://download.spotify.com/debian/pubkey.gpg | sudo apt-key add -
	echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
	sudo apt-get update && sudo apt-get install spotify-client -y

	mkdir -p /tmp/spicetify/spicetify
	mkdir -p ~/apps
	pushd /tmp/spicetify
	wget https://github.com/khanhas/spicetify-cli/releases/download/v0.9.5/spicetify-0.9.5-linux-amd64.tar.gz -P /tmp/spicetify
	tar -xf spicetify-0.9.5-linux-amd64.tar.gz -C spicetify
	mv spicetify ~/apps
	popd
	rm -rf /tmp/spicetify

	sudo chmod 777 /usr/share/spotify -R

	~/apps/spicetify/spicetify

	git clone https://github.com/morpheusthewhite/spicetify-themes.git /tmp/spicetify-themes
	pushd /tmp/spicetify-themes
	cp -r * ~/.config/spicetify/Themes
	popd
	rm -rf /tmp/spicetify-themes

	spotify &  # spotify has to be ran at least once before applying theme
	~/apps/spicetify/spicetify config current_theme Pop-Dark
	~/apps/spicetify/spicetify backup apply
}

install_pycharm() {
	PYCHARM_VERSION="pycharm-professional-2019.2.4"
	PYCHARM_DIR_NAME=${PYCHARM_VERSION/-professional/}
	PYCHARM_TAR="${PYCHARM_VERSION}.tar.gz"
	LAUNCH_PYCHARM_CMD="wmname LG3D && ~/apps/${PYCHARM_DIR_NAME}/bin/pycharm.sh"
	LAUNCH_PYCHARM_SCRIPT_PATH="/usr/local/bin/pycharm"

	mkdir -p /tmp/pycharm
	wget https://download.jetbrains.com/python/${PYCHARM_TAR} -P /tmp/pycharm
	wget https://download.jetbrains.com/python/${PYCHARM_TAR}.sha256 -P /tmp/pycharm/

	pushd /tmp/pycharm
	sha256sum -c ${PYCHARM_TAR}.sha256
	tar -xf ${PYCHARM_TAR}
	mkdir -p ~/apps
	mv ${PYCHARM_DIR_NAME} ~/apps
	popd
	rm -rf /tmp/pycharm

	echo "${LAUNCH_PYCHARM_CMD}" | sudo tee ${LAUNCH_PYCHARM_SCRIPT_PATH}
	sudo chmod +x ${LAUNCH_PYCHARM_SCRIPT_PATH}
}

install_nix() {
	curl https://nixos.org/nix/install | sh
}

install_docker() {
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - 
	sudo add-apt-repository \
	   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
	   disco \
	   stable"

	${QUIET_APT_INSTALL} docker-ce docker-ce-cli containerd.io
	sudo groupadd docker || true
	sudo gpasswd -a $USER docker

	sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose
}
