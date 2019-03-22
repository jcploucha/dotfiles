source ~/.bashrc

# Command prompt
export PS1="\W\\$ "

# rbenv shenanigans
eval "$(rbenv init -)"

# pyenv shenanigans
eval "$(pyenv init -)"

# Helpful functions
restaurant() {
  if [[ $1 ]]; then
    sed -i -Ee 's!https://api.chef.io/organizations/.*"!https://api.chef.io/organizations/'$1'"!' ~/.chef/knife.rb
  else
    grep -o 'organizations\/.*' ~/.chef/knife.rb | cut -f2- -d/ | sed 's/"$//'    
  fi
}

clone() {
    curl -H "Authorization: token $GITHUB_API_TOKEN" -X POST "https://api.github.com/repos/brandingbrand/$1/forks"
    git clone "git@github.com:jcploucha/$1"
    cd $1
    git remote add upstream "git@github.com:brandingbrand/$1"
    git checkout master
}

mssh() {
    if [ -z "$HOSTS" ]; then
       echo -n "Please provide of list of hosts separated by spaces [ENTER]: "
       read HOSTS
    fi

    local hosts=( $HOSTS )

    tmux new-window "ssh ${hosts[0]}"
    echo $hosts[0]
    unset hosts[0];
    for i in "${hosts[@]}"; do
        tmux split-window -h  "ssh $i"
        tmux select-layout tiled > /dev/null
    done
    tmux select-pane -t 0
    tmux set-window-option synchronize-panes on > /dev/null

}

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/Jon.Ploucha/google-cloud-sdk/path.bash.inc' ]; then . '/Users/Jon.Ploucha/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/Jon.Ploucha/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/Jon.Ploucha/google-cloud-sdk/completion.bash.inc'; fi
source <(kubectl completion bash)

# Bash completion support
source /usr/local/etc/bash_completion
