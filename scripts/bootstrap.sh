set -e

info() {
	printf "  [ \033[00;34m..\033[0m ] $1"
}

success() {
	printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail() {
	printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
	echo ''
	exit
}

bootstrap_install() {
	sudo apt update
	sudo apt install curl git -y
}

info "Yo dawg I heard you like installations, so I am installing some stuff so you can install even more stuff.\n"

bootstrap_install || fail "Bootstrap failed - NANI!?\n"
success "All done, goodbye.\n"
