# .bashrc

function vboxdel(){
  VBoxManage controlvm "$1" poweroff;
  VBoxManage unregistervm "$1" --delete;
}

function ssht(){
  ssh -L "$1":localhost:"$1" blade0"$2";
}

function cdgem(){
  dir="${HOME}/.rvm/gems/ruby-${1}/gems"
  cd $dir
}

function gclone(){
  case $1 in
    f)
      git clone git@github.com:simp/${2}
      ;;
    *)
      git clone git@github.com:simp/pupmod-simp-${1}.git $1
       ;;
  esac
}


function start_agent {
    touch $SSH_ENV
    chmod 600 "${SSH_ENV}"
    /usr/bin/ssh-agent > "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
#    /usr/bin/ssh-add $HOME/.ssh/id_rsa
}

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi
# Set up ssh-agent
server=$(hostname -f)
SSH_ENV="$HOME/.ssh/sshenv.${server}"
SOCK="$HOME/.ssh/auth_sock.${server}"

# Source SSH settings, if applicable
#echo "Server is: $server"
if [ ! -e $SOCK ] > /dev/null; then
  ssh-agent -a $SOCK > $SSH_ENV
#  /usr/bin/ssh-add $HOME/.ssh/id_rsa
fi

if [ -f $SSH_ENV ]; then 
      . "${SSH_ENV}" > /dev/null
fi


# User specific aliases and functions

alias lsla='ls -la'
alias mroe='more'
alias puppetit='chmod -R g+rX $1;chown -R root:puppet $1'
alias ssh='ssh -o UseRoaming=no'
export PATH="$PATH:$HOME/.rvm/bin:$HOME/scripts:/usr/local/bin:/usr/local/lib:/usr/local/lib64" # Add RVM to PATH for scripting
alias grep='grep --color=auto'
alias findit="grep --color=auto --exclude-dir='.git' -rli $1"
#alias isorhbuild='BEAKER_RHSM_USER=continentalop99 BEAKER_RHSM_PASS=P@ssw0rdP@ssw0rd SIMP_BUILD_isos=/net/ISO/Distribution_ISOs SIMP_BUILD_docs=no bundle exec rake beaker:suites[rpm_docker,rhel7] |& tee /tmp/iso7buildoutput'
alias isorhbuild='BEAKER_RHSM_USER=continentalop99 BEAKER_RHSM_PASS=P@ssw0rdP@ssw0rd SIMP_BUILD_docs=no bundle exec rake beaker:suites[rpm_docker,rhel7] |& tee /tmp/iso7buildoutput'
alias iso7build='SIMP_BUILD_docs=no bundle exec rake beaker:suites[rpm_docker,el7] |& tee /tmp/iso7buildoutput'
#alias iso7build='SIMP_BUILD_isos=/net/ISO/Distribution_ISOs SIMP_BUILD_docs=no bundle exec rake beaker:suites[rpm_docker,el7] |& tee /tmp/iso7buildoutput'
alias iso6build='SIMP_BUILD_isos=/net/ISO/Distribution_ISOs SIMP_BUILD_docs=no SIMP_RPM_dist=.el6 bundle exec rake beaker:suites[rpm_docker,el6] |& tee /tmp/iso6buildoutput'
alias iso6yum='SIMP_BUILD_yum_dir=build/distributions/CentOS/6/x86_64 SIMP_BUILD_update_packages=yes rake build:yum:sync[CenOS,6]'
alias iso7yum='SIMP_BUILD_yum_dir=build/distributions/CentOS/7/x86_64 SIMP_BUILD_update_packages=yes rake build:yum:sync[CenOS,7]'
alias cd65='cd /var/jmg/code/6.5/simp-core/src/puppet/modules'
alias cd66='cd /var/jmg/code/6.6/simp-core/src/puppet/modules'
alias vnc0='ssh -L 5900:localhost:5900 store04'
alias vnc1='ssh -L 5901:localhost:5901 store04'
alias cdrvm='cd $HOME/.rvm/gems/ruby-2.5.7/gems'
alias pydoc='source $HOME/python_virtual_envs/py3env/bin/activate'
alias refup='bundle exec puppet strings generate --format markdown --out REFERENCE.md'
alias sshpassword='ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no'
alias virtman="virt-manager -c qemu+ssh://jgreulich@store04/system?socket=/var/run/libvirt/libvirt-sock"
alias fixscroll='tput rmcup'
alias ldapdate='echo $(($(date --utc --date "$1" +%s)/86400))'
#[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

export VAGRANT_DEFAULT_PROVIDER=virtualbox
if [ -d /var/jmg ]; then
  export VAGRANT_HOME=/var/jmg/.vagrant.d
fi
export LIBVIRT_DEFAULT_URI=qemu:///system
alias vbox=VBoxManage
alias vminfo="VBoxManage showvminfo $1"

export VBOX_USER_HOME=/var/jmg/config/VirtualBox
if [ -d /var/jmg ]; then
  if [ ! -d /var/jmg/config/VirtualBox ]; then
    mkdir -p /var/jmg/config/VirtualBox
  fi
#  vmdir=`vbox list systemproperties | grep 'Default machine folder' | cut -f 2 -d':'  | sed 's/^[[:blank:]]*//;s/[[:blank:]]*$//'`
fi

if [ -f ~/.elasticrc ]; then
  source ~/.elasticrc
fi

if declare -p rvm_path &> /dev/null; then
  source ${rvm_path}/scripts/rvm;
else
  if [ -f $HOME/.rvm/scripts/rvm ]; then
    source $HOME/.rvm/scripts/rvm
  else
    if [ -f /etc/profile.d/rvm.sh ]; then
      source /etc/profile.d/rvm.sh;
    fi
  fi
fi
