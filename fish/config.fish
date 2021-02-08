#  ___ _    _     __
# | __(_)__| |_   \ \  /~~~~~~\
# | _|| (_-< ' \   > ><    /\  >
# |_| |_/__/_||_| /_/  \_   __/
#                        |/

# load .home
dothome-init | source

# Vi mode with vim cursor shapes
fish_vi_key_bindings
set fish_cursor_default block
set fish_cursor_insert line
set fish_cursor_replace_one underscore


# Allias
alias la 'ls -a'
alias ll 'ls -la'
alias q exit
alias xclip 'xclip -selection clipboard'

bind yy fish_clipboard_copy
bind Y fish_clipboard_copy
bind p fish_clipboard_paste

set -x LESS_TERMCAP_mb (printf "\033[01;32m")
set -x LESS_TERMCAP_md (printf "\033[01;32m")
set -x LESS_TERMCAP_me (printf "\033[0m")
set -x LESS_TERMCAP_se (printf "\033[0m")
set -x LESS_TERMCAP_so (printf "\033[01;45;30m")
set -x LESS_TERMCAP_ue (printf "\033[0m")
set -x LESS_TERMCAP_us (printf "\033[4;36m")

# Functions
# function info; notify-send $argv; end
# function _plz -e fish_preexec
# 	commandline -r (
# 		echo $argv[1]		 |
# 		grep -E ' ?plz$'	 |
# 		echo $argv[1]		 |
# 		sed -E 's| ?plz$||g' |
# 		sed -E 's|^|sudo |g' )
# end


# function fish_greeting
#	date '+%h %d %H:%M'
# 	echo 'Host: '(prompt_hostname)
# 	echo "User: $USER"
# end

