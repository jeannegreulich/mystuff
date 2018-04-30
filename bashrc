# .bashrc

function vboxdel(){
  VBoxManage controlvm "$1" poweroff;
  VBoxManage unregistervm "$1" --delete;
}

function ssht(){
  ssh -L "$1":localhost:"$1" blade0"$2";
}

function gclone(){
  case $1 in
    simp-core | core)
       git clone git@github.com:simp/simp-core.git
       ;;
    simp-docs | docs | doc | simp-doc )
       git clone git@github.com:simp/simp-doc.git
       ;;
    simp-cli|cli)
      git clone git@github.com:simp/rubygem-simp-cli.git
      ;;
    *)
      git clone git@github.com:simp/pupmod-simp-${1}.git
      ;;
  esac 
}

function start_agent {
    echo "Initializing new SSH agent..."
    touch $SSH_ENV
    chmod 600 "${SSH_ENV}"
    /usr/bin/ssh-agent > "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add $HOME/.ssh/id_rsa
}

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi
# Set up ssh-agent
server=`hostname`
SSH_ENV=$HOME/sshenv.$server

# Source SSH settings, if applicable
#if [[ $server == "blade"* || $server == "ws151"* || "speedy"* ]]; then
#  if [ -f "${SSH_ENV}" ]; then
#      . "${SSH_ENV}" > /dev/null
#      kill -0 $SSH_AGENT_PID 2>/dev/null || {
#          start_agent
#      }
#  else
#      start_agent
#  fi
#else
#  echo "not starting agent"
#fi


# User specific aliases and functions

export PYTHONPATH=/usr/lib/python2.7/site-packages/:/usr/lib64/python2.7/site-packages
alias lsla='ls -la'
alias mroe='more'
alias mockit='chmod -R g+rX $1;chown -R :mock $1'
alias ssh='ssh -o UseRoaming=no'
export PATH="$PATH:$HOME/.rvm/bin:$HOME/scripts:/usr/local/bin:/usr/local/lib:/usr/local/lib64" # Add RVM to PATH for scripting
alias grep='grep --color=auto'
alias findit="grep --color=auto --exclude-dir='.git' -rli $1"
alias isobuild='SIMP_BUILD_docs=no bundle exec rake beaker:suites[rpm_docker] |& tee /tmp/isobuildoutput'
alias cd62='cd /var/jmg/code/6.2/simp-core/src/puppet/modules'
alias vnc0='ssh -L 5900:localhost:5900 blade05'
alias vnc1='ssh -L 5901:localhost:5901 blade05'
alias vnc2='ssh -L 5902:localhost:5902 blade05'
alias vnc3='ssh -L 5903:localhost:5903 blade05'
alias vnc4='ssh -L 5904:localhost:5904 blade05'
alias vnc5='ssh -L 5905:localhost:5905 blade05'
alias vnc6='ssh -L 5906:localhost:5906 blade05'
#[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

export VAGRANT_DEFAULT_PROVIDER=virtualbox
if [ -d /var/jmg ]; then
  export VAGRANT_HOME=/var/jmg/.vagrant.d
fi
export LIBVIRT_DEFAULT_URI=qemu:///system
alias vbox=VBoxManage
alias vminfo="VBoxManage showvminfo $1" 

if [ -f ~/.elasticrc ]; then
  source ~/.elasticrc
fi
