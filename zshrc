# --------------ZSH--------------
ZSH=$HOME/.oh-my-zsh

# You can change the theme with another one from https://github.com/robbyrussell/oh-my-zsh/wiki/themes
ZSH_THEME="robbyrussell"

# Useful oh-my-zsh plugins
plugins=(git gitfast last-working-dir common-aliases zsh-syntax-highlighting history-substring-search)

# Disable warning about insecure completion-dependent directories
ZSH_DISABLE_COMPFIX=true

# Actually load Oh-My-Zsh
source "${ZSH}/oh-my-zsh.sh"
unalias rm # No interactive rm by default (brought by plugins/common-aliases)
unalias lt # we need `lt` for https://github.com/localtunnel/localtunnel

# --------------HOMEBREW--------------
# (macOS-only) Prevent Homebrew from reporting - https://github.com/Homebrew/brew/blob/master/docs/Analytics.md
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_AUTO_UPDATE_SECS=604800 # 7 days in seconds

# Setup Homebrew shell and suppress error messages
export HOMEBREW_DIR="/opt/homebrew"
eval "$($HOMEBREW_DIR/bin/brew shellenv 2> /dev/null)"

# --------------RUBY------------------
# Load rbenv if installed (to manage your Ruby versions)
# export PATH="${HOME}/.rbenv/bin:${PATH}" # Needed for Linux/WSL
type -a rbenv > /dev/null && eval "$(rbenv init -)"&& eval "$(rbenv virtualenv-init - 2> /dev/null)" && RUBY_VERSION='$(rbenv version-name)'

# Rails and Ruby uses the local `bin` folder to store binstubs.
# So instead of running `bin/rails` like the doc says, just run `rails`
# Same for `./node_modules/.bin` and nodejs
export PATH="./bin:./node_modules/.bin:${PATH}:/usr/local/sbin"

# --------------NODEJS----------------
# Load nvm (to manage your node versions)
export NVM_DIR="$HOMEBREW_DIR/opt/.nvm" # Change this if you didn't use Homebrew to install nvm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/etc/bash_completion.d/nvm" ] && \. "$NVM_DIR/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

autoload -U add-zsh-hook
# Call `nvm use` automatically in a directory with a `.nvmrc` file
load-nvmrc() {
  if nvm -v &> /dev/null; then
    local node_version="$(nvm version)"
    local nvmrc_path="$(nvm_find_nvmrc)"

    if [ -n "$nvmrc_path" ]; then
      local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

      if [ "$nvmrc_node_version" = "N/A" ]; then
        nvm install
      elif [ "$nvmrc_node_version" != "$node_version" ]; then
        nvm use --silent
      fi
    elif [ "$node_version" != "$(nvm version default)" ]; then
      nvm use default --silent
    fi
    NODE_VERSION='[$(node --version)]'
  fi
}
reload-versions() {
  # Reload the versions of Ruby, Node.js, and Python
  RUBY_VERSION="$(ruby -v | cut -d ' ' -f 2)"
  NODE_VERSION="$(node --version)"
  PYTHON_VERSION="$(python --version 2>&1 | cut -d ' ' -f 2)"
  RPROMPT='💎 $RUBY_VERSION | ⬢ $NODE_VERSION | 🐍 $PYTHON_VERSION'
}

type -a nvm > /dev/null && add-zsh-hook chpwd load-nvmrc
type -a nvm > /dev/null && add-zsh-hook chpwd reload-versions
type -a nvm > /dev/null && load-nvmrc

# --------------PYTHON--------------
# Setup the PATH for pyenv binaries and shims
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# Load pyenv (to manage your Python versions)
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
type -a pyenv > /dev/null && eval "$(pyenv init -)" && eval "$(pyenv virtualenv-init - 2> /dev/null)" && PYTHON_VERSION='$(pyenv version-name)'

# Set ipdb as the default Python debugger
export PYTHONBREAKPOINT=ipdb.set_trace

# --------------ETC--------------
# Store your own aliases in the ~/.aliases file and load the here.
[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"

# Encoding stuff for the terminal
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Set VSCode as default editor
export BUNDLER_EDITOR=code
export EDITOR=code

reload-versions
