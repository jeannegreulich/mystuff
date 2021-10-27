# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/bin

export PATH
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

function start_agent {
    echo "Initializing new SSH agent..."
    touch $SSH_ENV
    chmod 600 "${SSH_ENV}"
    /usr/bin/ssh-agent > "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
#    /usr/bin/ssh-add $HOME/.ssh/id_rsa
}

# Set up ssh-agent
server=`hostname`
SSH_ENV=$HOME/sshenv.$server

# Source SSH settings, if applicable
who -u | grep 'jgreulich :0' -q
if [[ $? == 0 ]]; then
  echo 'using gnome session'
else
  if [[ $server == "super"* || $server == "ws"* || $server == "speedy"* || "tastybolt"* ]]; then

    if [ -f "${SSH_ENV}" ]; then
      . "${SSH_ENV}" > /dev/null
#dd      echo $SSH_AGENT_PID
      kill -0 $SSH_AGENT_PID 2>/dev/null
      if [[ $? = 0 ]]; then
        echo "Using existing agent"  > /dev/null
      else
        start_agent
      fi
    else
      start_agent
    fi
#  else
#    echo "not starting agent"
  fi
fi
