build_and_push_docker_image() {(
    set -e
    docker build -t $1 .
    docker push $1
)}

alias pipu="pip install --upgrade pip"
alias zshconfig="vi ~/.zshrc"


login_as_sa() {
    sa=$1
    key_file_name=./temp_key.json
    {
        gcloud iam service-accounts keys create $key_file_name --iam-account=$1
        gcloud auth activate-service-account $1 --key-file=$key_file_name
    } || {
        echo "error logging in"
    }
    rm -f $key_file_name
} 

# requires fnm installation (brew)
eval "$(fnm env --use-on-cd)"

# requires pyenv installation
eval "$(pyenv init -)"

# requires spaceship
source "/opt/homebrew/opt/spaceship/spaceship.zsh"