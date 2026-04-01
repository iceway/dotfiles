#!/bin/bash -x

# cur_dir="$(dirname "$(readlink -f "$0")")"
# dl_dir="$cur_dir/download"

SUDO="sudo"

if [[ -z "$GITHUB" ]]; then
	export GITHUB="https://gh-proxy.org/https://github.com"
fi
if [[ -z "$GITHUBRAW" ]]; then
	export GITHUBRAW="https://gh-proxy.org/https://raw.githubusercontent.com"
fi

# $1 green|red|yellow|blue
# $2 message
print_log() {
	case "$1" in
	red)
		shift
		echo -e "\033[1;31m$*\033[0m"
		;;
	green)
		shift
		echo -e "\033[1;32m$*\033[0m"
		;;
	yellow)
		shift
		echo -e "\033[1;33m$*\033[0m"
		;;
	blue | *)
		shift
		echo -e "\033[1;34m$*\033[0m"
		;;
	esac
}

apt_install_pkgs() {
	local to_install=()
	for pkg in "$@"; do
		if ! dpkg -s "$pkg" &>/dev/null; then
			to_install+=("$pkg")
		fi
	done
	if [ ${#to_install[@]} -gt 0 ]; then
		print_log green ">>> apt install ${to_install[*]}"
		$SUDO apt -qq -y install "${to_install[@]}"
	fi
}

pip_install_pkg() {
	if ! pip show "$@" &>/dev/null; then
		print_log green ">>> ++ pip install $*"
		pip install "$@"
	fi
}

npm_install_pkg() {
	if ! npm list -g "$@" &>/dev/null; then
		print_log green ">>> ++ npm install $*"
		$SUDO npm install -g "$@"
	fi
}

# $1: target
# $2: soruce
curl_get_file() {
	if [[ ! -s "${1:?missing arg 1}" ]]; then
		print_log yellow ">>> curl: $2 -> $1"
		curl -fLo "${1:?missing arg 1}" --create-dirs "${2:?missing arg 2}"
	fi
}

# $1: target dir
# $2: repo url
git_clone_repo() {
	if ! git -C "${1:?missing arg 1}" rev-parse --is-inside-work-tree; then
		print_log blue ">>> git: $2 -> $1"
		git clone "${2:?missing arg 2}" "${1:?missing arg 1}"
	fi
}

install_base() {
	apt_install_pkgs grep
	apt_install_pkgs sed
	apt_install_pkgs gawk

	if ! grep -qE 'http://mirror.sjtu.edu.cn' /etc/apt/sources.list; then
		$SUDO sed -ri -e 's#http://.*archive.ubuntu.com#http://mirror.sjtu.edu.cn#g' /etc/apt/sources.list
		$SUDO apt -qq update
	fi
}

install_tools() {
	apt_install_pkgs file
	apt_install_pkgs diffutils
	apt_install_pkgs findutils
	apt_install_pkgs dos2unix

	apt_install_pkgs wget
	apt_install_pkgs curl

	apt_install_pkgs tar
	apt_install_pkgs gzip
	apt_install_pkgs bzip2
	apt_install_pkgs xz-utils
	apt_install_pkgs unzip
	apt_install_pkgs unrar
	apt_install_pkgs p7zip-full
	apt_install_pkgs lz4
	apt_install_pkgs zstd

	apt_install_pkgs exa
	apt_install_pkgs fd-find
	apt_install_pkgs ripgrep
	apt_install_pkgs bat
	apt_install_pkgs jq
	apt_install_pkgs tree
	apt_install_pkgs lftp

	apt_install_pkgs iputils-ping
	apt_install_pkgs net-tools
	apt_install_pkgs iproute2
	apt_install_pkgs lsof
	apt_install_pkgs sysstat
	apt_install_pkgs psmisc
	apt_install_pkgs htop
	apt_install_pkgs lshw

	apt_install_pkgs clang-format
	apt_install_pkgs shfmt

	apt_install_pkgs ffmpeg
	apt_install_pkgs figlet

	apt_install_pkgs "fonts-noto-cjk"
	apt_install_pkgs "fonts-arphic-ukai"

	### git
	apt_install_pkgs git
	apt_install_pkgs tig
	curl_get_file "$HOME/.gitconfig" "$GITHUBRAW/iceway/dotfiles/master/git/gitconfig"
	git config --global "url.$GITHUB.insteadOf" "https://github.com"

	### vim
	apt_install_pkgs vim
	curl_get_file "$HOME/.vim/autoload/plug.vim" "$GITHUBRAW/junegunn/vim-plug/master/plug.vim"
	curl_get_file "$HOME/.vimrc" "$GITHUBRAW/iceway/dotfiles/master/vim/vimrc"

	### tmux
	apt_install_pkgs tmux
	curl_get_file "$HOME/.tmux.conf" "$GITHUBRAW/iceway/dotfiles/master/tmux/tmux.conf"
	mkdir -p "$HOME/.tmux/plugins"
	git_clone_repo "$HOME/.tmux/plugins/tpm" "$GITHUB/tmux-plugins/tpm"
	git_clone_repo "$HOME/.tmux/plugins/tmux-prefix-highlight" "$GITHUB/tmux-plugins/tmux-prefix-highlight"
	git_clone_repo "$HOME/.tmux/plugins/tmux-resurrect" "$GITHUB/tmux-plugins/tmux-resurrect"
}

install_extra() {
	### python
	apt_install_pkgs python3
	apt_install_pkgs python3-pip
	apt_install_pkgs python3-dev
	apt_install_pkgs python-is-python3
	if ! grep -qE 'mirror.sjtu.edu.cn' <<<"$(pip config get global.index-url)"; then
		mkdir -p "$HOME/.pip"
		pip config set global.index-url "https://mirror.sjtu.edu.cn/pypi/web/simple"
		pip config set install.trusted-host "mirror.sjtu.edu.cn"
	fi
	pip_install_pkg black

	### nodejs
	if [[ ! -s "/etc/apt/sources.list.d/nodesource.sources" ]]; then
		curl -fsSL "https://deb.nodesource.com/setup_lts.x" | $SUDO bash -
		$SUDO apt update
	fi
	apt_install_pkgs nodejs
	# npm config set prefix "$HOME/.npm"
	# npm config set cache "$HOME/.npm"
	npm_install_pkg prettier
	npm_install_pkg stylus

	### zsh
	curl_get_file "$HOME/.bashrc" "$GITHUBRAW/iceway/dotfiles/master/bash/bashrc"
	apt_install_pkgs zsh
	curl_get_file "$HOME/.zshrc" "$GITHUBRAW/iceway/dotfiles/master/zsh/zshrc"
	if ! git -C "$HOME/.oh-my-zsh" rev-parse --is-inside-work-tree; then
		curl -fsSL https://git.sjtu.edu.cn/sjtug/ohmyzsh/-/raw/master/tools/install.sh | REMOTE=https://git.sjtu.edu.cn/sjtug/ohmyzsh.git bash -x
	fi
	sed -ri \
		-e "s%^# (export PATH=.*)%\1%" \
		-e "s%^ZSH_THEME=\"\w+\"%ZSH_THEME=\"ys\"%" \
		"$HOME/.zshrc"
	if ! grep -qE 'zsh-history-substring-search' "$HOME/.zshrc"; then
		sed -ri \
			-e "s%^plugins=\((.*)\)%plugins=(\1 tig z colored-man-pages command-not-found zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search)%" \
			"$HOME/.zshrc"
	fi
	if ! grep -qE 'history-substring-search-up' "$HOME/.zshrc"; then
		cat <<EOF >>"$HOME/.zshrc"
bindkey "\$terminfo[kcuu1]" history-substring-search-up
bindkey "\$terminfo[kcud1]" history-substring-search-down
bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down
EOF
	fi
	mkdir -p "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
	git_clone_repo "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" "$GITHUB/zsh-users/zsh-autosuggestions"
	git_clone_repo "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" "$GITHUB/zsh-users/zsh-syntax-highlighting"
	git_clone_repo "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-history-substring-search" "$GITHUB/zsh-users/zsh-history-substring-search"
	if ! grep -qE "^$USER"'.*/usr/bin/zsh$' /etc/passwd; then
		chsh -s "$(which zsh)" "$USER"
	fi
}

install_opencode() {
	if ! command -v bun; then
		curl -fsSL https://bun.com/install | GITHUB="$GITHUB" bash -x
	fi
	if ! command -v opencode; then
		bun install -g opencode-ai
		bunx oh-my-opencode install --no-tui --claude=no --openai=no --gemini=no --copilot=no --opencode-zen=yes
	fi
	opencode_repo_dir="$HOME/.config/opencode/repos"
	opencode_skill_dir="$HOME/.config/opencode/skills"
	opencode_plugin_dir="$HOME/.config/opencode/plugins"
	mkdir -p "$opencode_repo_dir"
	mkdir -p "$opencode_skill_dir"
	mkdir -p "$opencode_plugin_dir"
	git_clone_repo "$opencode_repo_dir/anthropics-skills.git" "$GITHUB/anthropics/skills"
	ln -sf "$opencode_repo_dir/anthropics-skills.git/skills" "$opencode_skill_dir/anthropics-skills"
	# find "$opencode_repo_dir/anthropics-skills.git/skills" -mindepth 1 -maxdepth 1 -type d | while read -r x; do
	# 	ln -sf "$x" "$opencode_skill_dir/$(basename "$x")"
	# done
	git_clone_repo "$opencode_repo_dir/obra-superpowers.git" "$GITHUB/obra/superpowers"
	# find "$opencode_repo_dir/obra-superpowers.git/skills" -mindepth 1 -maxdepth 1 -type d | while read -r x; do
	# 	ln -sf "$x" "$opencode_skill_dir/$(basename "$x")"
	# done
	ln -sf "$opencode_repo_dir/obra-superpowers.git/skills" "$opencode_skill_dir/superpower-skills"
	ln -sf "$opencode_repo_dir/obra-superpowers.git/.opencode/plugins/superpowers.js" "$opencode_plugin_dir/superpowers.js"
	jq '.plugin += ["@tarquinen/opencode-dcp@latest"]' "$HOME/.config/opencode/opencode.json"
}

case "$1" in
tools)
	install_base
	install_tools
	install_extra
	;;
opencode)
	install_opencode
	;;
*)
	echo "Usage: $0 tools|opencode"
	;;
esac
