if status is-interactive
#-----------
# Functions
#-----------

function update
  pushd $HOME &> /dev/null
  mr up
  popd &> /dev/null # $HOME
end

function source_if_exists
  if test -f $argv[1]
    source $argv[1]
  end
end

function path_if_exists
  if test -d $argv[1]
    fish_add_path $argv[1]
  end
end

function swap_yubikey
  gpg-connect-agent "scd serialno" "learn --force" /bye
end

#--------------------
# PATH configuration
#--------------------

path_if_exists $HOME/Applications
path_if_exists $HOME/bin
path_if_exists $HOME/.local/bin
path_if_exists $HOME/.npm-global/bin

#---------
# Aliases
#---------

# alias setup
alias cdl='cd; clear'
alias ckpt='git commit -a -m "checkpoint"; git push'
alias ping='prettyping --nolegend'
alias top='btop'
alias du='ncdu --color dark -rr -x --exclude .git --exclude node_modules'
alias dc='docker-compose'
alias dm='docker-machine'
alias d='docker'
alias v=vagrant
alias chmod='chmod -c'
alias chown='chown -c'
alias less='less -F'

#-----------
# Utilities
#-----------

set -gx BAT_THEME "Solarized (dark)"

#----------------------------
# OS-specific configurations
#----------------------------
alias open='xdg-open'
alias ls='ls -F --color=auto'
if type batcat &> /dev/null
  alias cat='batcat'
end
if type bat &> /dev/null
  alias cat='bat'
end

set -gx LS_COLORS 'rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:'
set -gx LSCOLORS {$LS_COLORS}

set -gx EDITOR 'emacsclient -t'
set -gx VISUAL 'emacsclient -t'

# Start or re-use a gpg-agent.
#
gpgconf --launch gpg-agent

# Ensure that GPG Agent is used as the SSH agent
set -e SSH_AUTH_SOCK
set -g -x SSH_AUTH_SOCK /run/user/1000/gnupg/S.gpg-agent.ssh

# golang stuff
set -gx GOPATH $HOME/go
fish_add_path $GOPATH/bin

# Debian packaging variables
set -gx DEBFULLNAME "Tom Moyer"
set -gx DEBEMAIL "tommoyer@gmail.com"

#--------------------------------
# system-specific customizations
#--------------------------------
source_if_exists ~/.local_profile

set -gx pure_color_mute brcyan

end # is-interactive
