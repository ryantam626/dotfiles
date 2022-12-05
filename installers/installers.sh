QUIET_APT_INSTALL="sudo apt-get -qq -y -o Dpkg::Use-Pty=0 install"
SCRIPT_PATH=$(cd -P -- "$(dirname -- "$0")" && printf '%s\n' "$(pwd -P)/$(basename "$0")")
SCRIPT_DIR=$(dirname $SCRIPT_PATH)/

source $SCRIPT_DIR/helpers.sh

GLOBAL_PYTHON_VER="3.10.8"

install_pyenv() {
	${QUIET_APT_INSTALL} install python3-pip

	sudo apt-get install --no-install-recommends make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev -y
	git clone https://github.com/pyenv/pyenv.git ~/.pyenv

	/home/ryan/.pyenv/bin/pyenv install $GLOBAL_PYTHON_VER
	/home/ryan/.pyenv/bin/pyenv global $GLOBAL_PYTHON_VER
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
	[ ! -d "~/.tmux/plugins/tpm" ] && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

install_utils() {
	info "Installing other utils\n"
	${QUIET_APT_INSTALL} \
		xsel \
		pavucontrol \
		fzf \
		autoconf \
		openssh-server \
		gawk \
		flameshot \
		ncal
	sudo pip3 install thefuck
	sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b ~/.local/bin
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

install_sublime() {
	info "Installing sublime\n"
	wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
	echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
	sudo apt-get update && ${QUIET_APT_INSTALL} sublime-text
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
	curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | sudo apt-key add - 
	echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

	sudo apt-get update && sudo apt-get install spotify-client -y

	mkdir -p ~/apps

	sudo chmod 777 /usr/share/spotify -R
}

install_pycharm() {
	PYCHARM_VERSION="pycharm-professional-2022.2.3"
	PYCHARM_DIR_NAME=${PYCHARM_VERSION/-professional/}
	PYCHARM_TAR="${PYCHARM_VERSION}.tar.gz"
	LAUNCH_PYCHARM_CMD="wmname LG3D && ~/apps/${PYCHARM_DIR_NAME}/bin/pycharm.sh"
	LAUNCH_PYCHARM_SCRIPT_PATH="/usr/local/bin/pycharm"
	${QUIET_APT_INSTALL} wmname

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

install_docker() {
	sudo apt-get install \
	    ca-certificates \
	    curl \
	    gnupg \
	    lsb-release

	sudo mkdir -p /etc/apt/keyrings
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

	echo \
	  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
	  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

	sudo apt-get update

	${QUIET_APT_INSTALL} docker-ce docker-ce-cli containerd.io docker-compose-plugin

	sudo groupadd docker || true
	sudo gpasswd -a $USER docker

	sudo pip3 install docker-compose
}

install_kmonad() {
	sudo docker build -t kmonad-builder github.com/kmonad/kmonad.git
	sudo docker run --rm -it -v /tmp/kmonad:/host/ kmonad-builder bash -c 'cp -vp /root/.local/bin/kmonad /host/'
	sudo docker rmi kmonad-builder
	sudo mv /tmp/kmonad/kmonad /usr/local/bin

	sudo ln -s /home/ryan/dotfiles/dotfiles/kmonad/services/a1-remap.service /etc/systemd/system
	sudo systemctl enable a1-remap
	sudo systemctl start a1-remap
}

install_zsh() {
	info "Installing ZSH-related stuff\n"
	${QUIET_APT_INSTALL} zsh
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" || true
}

install_zsh_plugins() {
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH/custom/themes/powerlevel10k
	git clone https://github.com/zsh-users/zsh-completions ${ZSH}/custom/plugins/zsh-completions
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
	git clone https://github.com/sawadashota/go-task-completions.git ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/task
}


install_python_management() {
	curl -sSL https://install.python-poetry.org | python3 -
	pip install virtualenvwrapper virtualenv
}

install_nvm() {
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
}
