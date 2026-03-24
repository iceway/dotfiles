#!/bin/bash -x

# cur_dir="$(dirname "$(readlink -f "$0")")"
# dl_dir="$cur_dir/download"

SUDO="sudo"

if [[ -z "$GITHUB" ]]; then
	export GITHUB="https://gh-proxy.com/https://github.com"
fi
if [[ -z "$GITHUBRAW" ]]; then
	export GITHUBRAW="https://gh-proxy.org/https://raw.githubusercontent.com"
fi

apt_install_pkgs() {
	$SUDO apt -qq -y install "$@"
}

# $1: target
# $2: soruce
curl_get_file() {
	if [[ ! -s "${1:?missing arg 1}" ]]; then
		curl -fLo "${1:?missing arg 1}" --create-dirs "${2:?missing arg 2}"
	fi
}

# $1: target dir
# $2: repo url
git_clone_repo() {
	if ! git -C "${1:?missing arg 1}" rev-parse --is-inside-work-tree; then
		git clone "${2:?missing arg 2}" "${1:?missing arg 1}"
	fi
}

apt_install_pkgs grep sed gawk

if ! grep -qE 'http://mirror.sjtu.edu.cn' /etc/apt/sources.list; then
	$SUDO sed -ri -e 's#http://.*archive.ubuntu.com#http://mirror.sjtu.edu.cn#g' /etc/apt/sources.list
	$SUDO apt -qq update
fi

apt_install_pkgs file diffutils findutils dos2unix wget curl
apt_install_pkgs tar gzip bzip2 xz-utils unzip unrar p7zip-full lz4 zstd

apt_install_pkgs exa fd-find ripgrep bat jq tree lftp
apt_install_pkgs ffmpeg figlet
apt_install_pkgs iputils-ping net-tools iproute2 lsof sysstat psmisc htop lshw

apt_install_pkgs clang-format shfmt

apt_install_pkgs "fonts-noto-cjk" "fonts-arphic-ukai"

apt_install_pkgs git tig
curl_get_file "$HOME/.gitconfig" "$GITHUBRAW/iceway/dotfiles/master/git/gitconfig"

apt_install_pkgs vim
curl_get_file "$HOME/.vim/autoload/plug.vim" "$GITHUBRAW/junegunn/vim-plug/master/plug.vim"
curl_get_file "$HOME/.vimrc" "$GITHUBRAW/iceway/dotfiles/master/vim/vimrc"

apt_install_pkgs tmux
curl_get_file "$HOME/.tmux.conf" "$GITHUBRAW/iceway/dotfiles/master/tmux/tmux.conf"
mkdir -p "$HOME/.tmux/plugins"
git_clone_repo "$HOME/.tmux/plugins/tpm" "$GITHUB/tmux-plugins/tpm"
git_clone_repo "$HOME/.tmux/plugins/tmux-prefix-highlight" "$GITHUB/tmux-plugins/tmux-prefix-highlight"
git_clone_repo "$HOME/.tmux/plugins/tmux-resurrect" "$GITHUB/tmux-plugins/tmux-resurrect"

apt_install_pkgs python3 python3-pip python3-dev python-is-python3
if ! grep -qE 'mirror.sjtu.edu.cn' <<<"$(pip config get global.index-url)"; then
	mkdir -p "$HOME/.pip"
	pip config set global.index-url "https://mirror.sjtu.edu.cn/pypi/web/simple"
	pip config set install.trusted-host "mirror.sjtu.edu.cn"
fi
if ! command -v black >/dev/null 2>&1; then
	pip3 install "black"
fi

apt_install_pkgs nodejs
if ! command -v prettier >/dev/null 2>&1; then
	$SUDO npm install --unsafe-perm -g prettier
fi
if ! command -v stylus >/dev/null 2>&1; then
	$SUDO npm install --unsafe-perm -g stylus
fi

curl_get_file "$HOME/.bashrc" "$GITHUBRAW/iceway/dotfiles/master/bash/bashrc"
apt_install_pkgs zsh
curl_get_file "$HOME/.zshrc" "$GITHUBRAW/iceway/dotfiles/master/zsh/zshrc"
if ! git -C "$HOME/.oh-my-zsh" rev-parse --is-inside-work-tree; then
	curl -fsSL https://git.sjtu.edu.cn/sjtug/ohmyzsh/-/raw/master/tools/install.sh | REMOTE=https://git.sjtu.edu.cn/sjtug/ohmyzsh.git bash -x
fi
mkdir -p "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
git_clone_repo "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" "$GITHUB/zsh-users/zsh-autosuggestions"
git_clone_repo "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" "$GITHUB/zsh-users/zsh-syntax-highlighting"
git_clone_repo "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-history-substring-search" "$GITHUB/zsh-users/zsh-history-substring-search"

# curl -fsSL https://bun.com/install | GITHUB="https://gh-proxy.com/https://github.com" bash -x
# bun install -g opencode-ai
# bunx oh-my-opencode install --no-tui --claude=no --openai=no --gemini=no --copilot=no --opencode-zen=yes
# opencode_repo_dir="$HOME/.config/opencode/repos"
# opencode_skill_dir="$HOME/.config/opencode/skills"
# mkdir -p "$opencode_repo_dir"
# mkdir -p "$opencode_skill_dir"
# git_clone_repo "$opencode_repo_dir/anthropics-skills.git" "$GITHUB/anthropics/skills"
# ln -sf "$opencode_repo_dir/anthropics-skills.git/skills" "$opencode_skill_dir/anthropics-skills"
# git_clone_repo "$opencode_repo_dir/obra-superpowers.git" "$GITHUB/obra/superpowers"
# ln -sf "$opencode_repo_dir/obra-superpowers.git/skills" "$opencode_skill_dir/obra-superpowers"
