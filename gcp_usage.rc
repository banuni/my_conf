export GCP_PROJECT=""
PS3="Choose a GCP project: "
env_options=("sme-testing" "sme-staging" "sme-modeling" "sme-prod-eu" "sme-shared" "kov-dev" "kov-test" "kov-prod")
options_len=${#env_options[@]}
select choice in "${env_options[@]}";
do
  if (($REPLY >= 1)) && (($REPLY <= $options_len)); then
    echo -e "\nyou picked $choice ($REPLY)"
    export GCP_PROJECT=$choice
    export GCP_ENV=$choice
    export GCP_ZONE=us-central1-a
    export KUBECONFIG=/Users/nadnu/.kube/${GCP_PROJECT}_config
    if [ "$choice" = "sme-prod-eu" ] || [ "$choice" = "kov-prod" ] 
    then
      echo "yay"
      export GCP_ZONE=europe-west1-b
    fi
    break;
  else
    echo "invalid choice"
  fi
done
​
gcloud config set project ${GCP_PROJECT}
gcloud auth application-default login --project="${GCP_ENV}"
gcloud container clusters get-credentials asscluster --zone="$GCP_ZONE" --project="${GCP_ENV}"
sed -i "" -e "s/\(server\: \)\(.*\)/\1https:\/\/kubernetes:4433/" ${KUBECONFIG}
​
_kovrr_port_fwd(){
  while true; do `gcloud compute ssh port-forwarder --zone "$GCP_ZONE" --ssh-flag="-ServerAliveInterval=30" -- -N -L 4433:$(gcloud container clusters describe asscluster --region "$GCP_ZONE" | grep endpoint: | cut -d " " -f2):443 -L 6379:ass-store:6379`; done;
}
alias kovrr_port_fwd=_kovrr_port_fwd 
echo "Ready! Use kovrr_port_fwd command to connect to cluster through port forwarder."