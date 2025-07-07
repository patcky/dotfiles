# --------------RUBY------------------
if test -e ~/.rbenv
  set -x PATH $HOME/.rbenv/bin $PATH
  status --is-interactive; and . (rbenv init -|psub) and . (rbenv virtualenv-init - 2> /dev/null |psub)
end

[ -f /usr/share/autojump/autojump.fish ]; and source /usr/share/autojump/autojump.fish
type -q starship; and starship init fish | source

set -x EDITOR code

# --------------HOMEBREW--------------
# (macOS-only) Prevent Homebrew from reporting - https://github.com/Homebrew/brew/blob/master/docs/Analytics.md
set -x HOMEBREW_NO_ANALYTICS 1
set -x HOMEBREW_AUTO_UPDATE_SECS 604800 # 7 days in seconds

# Setup Homebrew shell and suppress error messages
set -x HOMEBREW_DIR "/opt/homebrew"
eval "$($HOMEBREW_DIR/bin/brew shellenv 2> /dev/null)"
