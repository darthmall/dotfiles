# Author: Evan Sheehan <darth_mall@pm.me>
# Description: fish configuration
# vim: set fdm=marker fdl=0 ts=2 sw=2 tw=80 :

if status is-login
	pyenv init --path | source
end

if status is-interactive
	# No greeting
	set -g fish_greeting

	fish_add_path ~/.local/bin ~/.cargo/bin

	if type -q nvim
		set -gx EDITOR nvim
	else
		set -gx EDITOR vim
	end

	set --universal nvm_default_version lts

	abbr --add --global pbcopy 'xclip -in -selection clipboard'
	abbr --add --global pbpaste 'xclip -out -selection clipboard'
	abbr --add --global open 'xdg-open &>/dev/null'

	abbr --add --global rm 'rm -I'

	abbr --add --global l 'eza --long --header --git'
	abbr --add --global ll 'eza --long --header --git --all'
	abbr --add --global lt 'eza --long --header --git --all --tree'
	abbr --add --global tree 'eza --tree'

	if type -q fdfind
		abbr --add --global fd 'fdfind'
	end

	abbr --add --global 'dci' 'docker rmi (docker images -a --filter=dangling=true -q)'

	abbr --add --global p 'procs'

	if type -q batcat
		abbr --add --global c 'batcat'
	else if type -q bat
		abbr --add --global c 'bat'
	end
end

if test -e ~/.config/fish/local.fish
	source ~/.config/fish/local.fish
end
