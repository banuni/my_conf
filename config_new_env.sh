export PROJ=kov-demo
export EMAIL=nuni@kovrr.com

# configure the new gcloud context
gcloud config configurations create $PROJ
gcloud config set account $EMAIL
gcloud config set project $PROJ

# infer the cluster's name and location
export CLUSTER=$(gcloud container clusters list --format="value(name)") # assume there's one cluster
export ZONE=$(gcloud container clusters list --format="value(zone)") # assume there's one cluster
gcloud config set compute/zone $ZONE
export FULL_CLUSTER_NAME=gke_$PROJ\_$ZONE\_$CLUSTER

# create the kubernetes context and rename to something readable
gcloud container clusters get-credentials $CLUSTER --region=$ZONE
kubectl config rename-context $FULL_CLUSTER_NAME $PROJ
kubectl config set-cluster $FULL_CLUSTER_NAME --server="https://kubernetes:4433"