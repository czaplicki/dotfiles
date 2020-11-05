#  ___ _    _     __
# | __(_)__| |_   \ \  /~~~~~~\
# | _|| (_-< ' \   > ><    /\  >
# |_| |_/__/_||_| /_/  \_   __/
#                        |/


set EDITOR nvim
set PAGER less

function fish_greeting
	date '+%h %d %H:%M'
	echo 'Host: '(prompt_hostname)
	echo "User: $USER"

end

function segment
	set_color      $argv[1]
	printf    '%s' $argv[2..-1]
end
function fish_prompt
	segment 3F5    (prompt_pwd)
	echo
	segment F67    '><,^> '
	segment normal ' $ '
end
