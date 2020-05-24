if type -q asdf
  source /usr/local/opt/asdf/asdf.fish
end

if type -q fd && type -q rg
  set -gx FZF_DEFAULT_COMMAND 'fd -tf'
end

if type -q mvim
  set -gx EDITOR 'mvim -v'
end

set -U fish_user_paths $fish_user_paths ~/.dotfiles/bin
#set -gxp PATH '.git/safe/../../bin' '.git/safe/../../node_modules/.bin' '/usr/local/sbin'
