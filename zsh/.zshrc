# Start configuration added by Zim install {{{
#
# User configuration sourced by interactive shells
#

# -----------------
# Zsh configuration
# -----------------

#
# History
#

# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS

#
# Input/output
#

# Set editor default keymap to emacs (`-e`) or vi (`-v`)
bindkey -e

# Prompt for spelling correction of commands.
#setopt CORRECT

# Customize spelling correction prompt.
#SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}


# --------------------
# Module configuration
# --------------------

#
# completion
#

# Set a custom path for the completion dump file.
# If none is provided, the default ${ZDOTDIR:-${HOME}}/.zcompdump is used.
#zstyle ':zim:completion' dumpfile "${ZDOTDIR:-${HOME}}/.zcompdump-${ZSH_VERSION}"

#
# git
#

# Set a custom prefix for the generated aliases. The default prefix is 'G'.
#zstyle ':zim:git' aliases-prefix 'g'

#
# input
#

# Append `../` to your input for each `.` you type after an initial `..`
#zstyle ':zim:input' double-dot-expand yes

#
# termtitle
#

# Set a custom terminal title format using prompt expansion escape sequences.
# See http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Simple-Prompt-Escapes
# If none is provided, the default '%n@%m: %~' is used.
#zstyle ':zim:termtitle' format '%1~'

#
# zsh-autosuggestions
#

# Customize the style that the suggestions are shown with.
# See https://github.com/zsh-users/zsh-autosuggestions/blob/master/README.md#suggestion-highlight-style
#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=10'

#
# zsh-syntax-highlighting
#

# Set what highlighters will be used.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Customize the main highlighter styles.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md#how-to-tweak-it
#typeset -A ZSH_HIGHLIGHT_STYLES
#ZSH_HIGHLIGHT_STYLES[comment]='fg=10'

# ------------------
# Initialize modules
# ------------------

if [[ ${ZIM_HOME}/init.zsh -ot ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  # Update static initialization script if it's outdated, before sourcing it
  source ${ZIM_HOME}/zimfw.zsh init -q
fi
source ${ZIM_HOME}/init.zsh

# ------------------------------
# Post-init module configuration
# ------------------------------

#
# zsh-history-substring-search
#

# Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Bind up and down keys
zmodload -F zsh/terminfo +p:terminfo
if [[ -n ${terminfo[kcuu1]} && -n ${terminfo[kcud1]} ]]; then
  bindkey ${terminfo[kcuu1]} history-substring-search-up
  bindkey ${terminfo[kcud1]} history-substring-search-down
fi

bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
# }}} End configuration added by Zim install

#-----------
# Functions
#-----------
glatexrun() {
  if [[ -z $1 ]]; then echo "usage: $0 <input>" ; return; fi
  input=${1:r}
  gitId=$(git rev-parse --short HEAD)
  latexrun ${input}
  mv ${input}.pdf ${input}-${gitId}.pdf
}

update() {
  pushd $HOME &> /dev/null
  mr up
  popd &> /dev/null
}

upgrade() {
  brew update
  brew upgrade
  brew upgrade --casks
  brew cleanup
  mas upgrade
  zimfw update
  zimfw upgrade
}

source_if_exists() {
  [[ -z $1 ]] && return
  [[ -e $1 ]] && source $1
}

path_if_exists() {
  [[ -z $1 ]] && return
  [[ -e $1 ]] && export PATH="$1:${PATH}"
}

toread() {
  cp -i "${1}" "/Volumes/GoogleDrive/My Drive/Reading/${1}"
}

kraken () {
  pgrep GitKraken &>/dev/null
  if [[ $? != 0 ]]
  then
    nohup /Applications/GitKraken.app/Contents/MacOS/GitKraken -p $(pwd) &>/dev/null &
  else
    echo "GitKraken already running"
  fi
}

repos () {
  subl ~/.config/mr/available.d/*
}

new_mr () {
  cat <<-EOF
[$HOME/Repos/${2}]
checkout = git clone ${1} ~/Repos/${2}
EOF
}

dotsave () {
  vcsh rcfiles status
  if read -s -q "choice?Press Y/y to commit and push changes"; then
    vcsh rcfiles commit -a -m "Saving dotfiles changes"
    vcsh rcfiles push
  fi
}

#--------------------
# PATH configuration
#--------------------
## ~/Applications and ~/bin
path_if_exists ${HOME}/Applications
path_if_exists ${HOME}/bin
## Homebrew make and coreutils
path_if_exists /opt/homebrew/opt/coreutils/libexec/gnubin
# MacGPG2
path_if_exists /usr/local/MacGPG2/bin
# Local PIP
path_if_exists ${HOME}/.local/bin
# Java
path_if_exists /usr/local/opt/openjdk/bin
path_if_exists ${HOME}/.local/bin

#---------
# Aliases
#---------
# alias setup
alias latexmk='latexmk -pdf -pvc'
alias cdl='cd; clear'
alias ckpt='git commit -a -m "checkpoint"; git push'
alias ping='prettyping --nolegend'
alias top='htop'
alias du='ncdu --color dark -rr -x --exclude .git --exclude node_modules'
alias dc='docker-compose'
alias dm='docker-machine'
alias d='docker'
alias tb='nc termbin.com 9999'
if type nvim > /dev/null 2>&1; then
  alias vim='nvim'
fi
alias v=vagrant
alias chmod='chmod -c'
alias chown='chown -c'
alias less='less -F'
alias meeting='busylight on red'
alias no_meeting='busylight on'
alias do_not_disturb='busylight on 0xe47200'

#-----------
# Utilities
#-----------
# 'z' command for quicker navigation
source_if_exists ~/.apps/z-jump/z.sh

# Fuzzy find for ZSH
source_if_exists ~/.fzf.zsh

# Bat theme
export BAT_THEME="Monokai Extended"

# Homebrew Github token
export HOMEBREW_GITHUB_API_TOKEN=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

# Vagrant uses VMware by default
# export VAGRANT_DEFAULT_PROVIDER="vmware_desktop"

#----------------------------
# OS-specific configurations
#----------------------------

if [[ "$(uname)" == "Darwin" ]]
then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    # iterm2 shell integration
    source_if_exists ${HOME}/.iterm2_shell_integration.zsh

    alias ls='ls -F --color=auto'
    alias cat='bat'

    export LSCOLORS='exfxcxdxbxegedabagacad'
    export LS_COLORS="$(vivid generate molokai)"
    
    # ZSH syntax highlighting
    source_if_exists /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

    # Google Cloud SDK
    source_if_exists /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc
    source_if_exists /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc

    # ZSH autosuggestions
    source_if_exists /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

    export EDITOR="subl -w"

    # Fix missing _ssh_hosts error
    autoload _ssh_hosts
fi

if [[ "$(uname)" == "Linux" ]]
then
    alias open='xdg-open'
    alias ls='ls -F --color=auto'
    if type batcat > /dev/null 2>&1; then
      alias cat='batcat'
    fi
    if type bat > /dev/null 2>&1; then
      alias cat='bat'
    fi

    export LS_COLORS='no=00:fi=00:di=36:ln=35:pi=30;44:so=35;44:do=35;44:bd=33;44:cd=37;44:or=05;37;41:mi=05;37;41:ex=01;31:*.cmd=01;31:*.exe=01;31:*.com=01;31:*.bat=01;31:*.reg=01;31:*.app=01;31:*.txt=32:*.org=32:*.md=32:*.mkd=32:*.h=32:*.c=32:*.C=32:*.cc=32:*.cpp=32:*.cxx=32:*.objc=32:*.sh=32:*.csh=32:*.zsh=32:*.el=32:*.vim=32:*.java=32:*.pl=32:*.pm=32:*.py=32:*.rb=32:*.hs=32:*.php=32:*.htm=32:*.html=32:*.shtml=32:*.erb=32:*.haml=32:*.xml=32:*.rdf=32:*.css=32:*.sass=32:*.scss=32:*.less=32:*.js=32:*.coffee=32:*.man=32:*.0=32:*.1=32:*.2=32:*.3=32:*.4=32:*.5=32:*.6=32:*.7=32:*.8=32:*.9=32:*.l=32:*.n=32:*.p=32:*.pod=32:*.tex=32:*.go=32:*.bmp=33:*.cgm=33:*.dl=33:*.dvi=33:*.emf=33:*.eps=33:*.gif=33:*.jpeg=33:*.jpg=33:*.JPG=33:*.mng=33:*.pbm=33:*.pcx=33:*.pdf=33:*.pgm=33:*.png=33:*.PNG=33:*.ppm=33:*.pps=33:*.ppsx=33:*.ps=33:*.svg=33:*.svgz=33:*.tga=33:*.tif=33:*.tiff=33:*.xbm=33:*.xcf=33:*.xpm=33:*.xwd=33:*.xwd=33:*.yuv=33:*.aac=33:*.au=33:*.flac=33:*.m4a=33:*.mid=33:*.midi=33:*.mka=33:*.mp3=33:*.mpa=33:*.mpeg=33:*.mpg=33:*.ogg=33:*.ra=33:*.wav=33:*.anx=33:*.asf=33:*.avi=33:*.axv=33:*.flc=33:*.fli=33:*.flv=33:*.gl=33:*.m2v=33:*.m4v=33:*.mkv=33:*.mov=33:*.MOV=33:*.mp4=33:*.mp4v=33:*.mpeg=33:*.mpg=33:*.nuv=33:*.ogm=33:*.ogv=33:*.ogx=33:*.qt=33:*.rm=33:*.rmvb=33:*.swf=33:*.vob=33:*.webm=33:*.wmv=33:*.doc=31:*.docx=31:*.rtf=31:*.dot=31:*.dotx=31:*.xls=31:*.xlsx=31:*.ppt=31:*.pptx=31:*.fla=31:*.psd=31:*.7z=1;35:*.apk=1;35:*.arj=1;35:*.bin=1;35:*.bz=1;35:*.bz2=1;35:*.cab=1;35:*.deb=1;35:*.dmg=1;35:*.gem=1;35:*.gz=1;35:*.iso=1;35:*.jar=1;35:*.msi=1;35:*.rar=1;35:*.rpm=1;35:*.tar=1;35:*.tbz=1;35:*.tbz2=1;35:*.tgz=1;35:*.tx=1;35:*.war=1;35:*.xpi=1;35:*.xz=1;35:*.z=1;35:*.Z=1;35:*.zip=1;35:*.ANSI-30-black=30:*.ANSI-01;30-brblack=01;30:*.ANSI-31-red=31:*.ANSI-01;31-brred=01;31:*.ANSI-32-green=32:*.ANSI-01;32-brgreen=01;32:*.ANSI-33-yellow=33:*.ANSI-01;33-bryellow=01;33:*.ANSI-34-blue=34:*.ANSI-01;34-brblue=01;34:*.ANSI-35-magenta=35:*.ANSI-01;35-brmagenta=01;35:*.ANSI-36-cyan=36:*.ANSI-01;36-brcyan=01;36:*.ANSI-37-white=37:*.ANSI-01;37-brwhite=01;37:*.log=01;34:*~=01;34:*#=01;34:*.bak=01;36:*.BAK=01;36:*.old=01;36:*.OLD=01;36:*.org_archive=01;36:*.off=01;36:*.OFF=01;36:*.dist=01;36:*.DIST=01;36:*.orig=01;36:*.ORIG=01;36:*.swp=01;36:*.swo=01;36:*,v=01;36:*.gpg=34:*.gpg=34:*.pgp=34:*.asc=34:*.3des=34:*.aes=34:*.enc=34:*.sqlite=34:'

    export LSCOLORS=${LS_COLORS}

    source_if_exists /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

    if [[ -e /etc/profile.d/apps-bin-path.sh ]]; then
      emulate sh -c 'source /etc/profile.d/apps-bin-path.sh'
    fi

fi

# Load any SSH keys into ssh-agent
#ssh-add -qk

unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi
export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye >/dev/null
gpgconf --launch gpg-agent

function swap_yubikey () {
  gpg-connect-agent "scd serialno" "learn --force" /bye
}

#--------------------------------
# system-specific customizations
#--------------------------------
source_if_exists ~/.local_profile
