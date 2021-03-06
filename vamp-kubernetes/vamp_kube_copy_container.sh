#!/usr/bin/env bash

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

green=$(tput setaf 2)
yellow=$(tput setaf 3)
reset=$(tput sgr0)

step() {
    echo "${yellow}[STEP] $1${reset}"
}

ok() {
    echo "${green}[OK] $1${reset}"
}

read -p "Do you want to build vamp:katana-kubernetes locally (y/n)? "
if [[ $REPLY == 'y' ]]
then
  step "Building the magneticio/vamp:katana-kubernetes container."
  ${dir}/../build.sh -b -i=vamp-kubernetes
  ok "Finished building the magneticio/vamp:katana-kubernetes container."
fi

# save the locally published katana-kubernetes image
step "Saving katana-kubernetes to katana-kubernetes.tar."
docker save magneticio/vamp:katana-kubernetes > ${dir}/katana-kubernetes.tar

step "Retrieving minikube ip."
MINIKUBE_IP=$(minikube ip)
ok "Found minikube ip address: $MINIKUBE_IP."

# copy the katana-kubernetes.tar to minikube
step "Copying katana-kubernetes.tar to minikube virtual machine."
scp -o StrictHostKeyChecking=no -o "UserKnownHostsFile /dev/null" -i ~/.minikube/machines/minikube/id_rsa ${dir}/katana-kubernetes.tar \
  docker@$MINIKUBE_IP:~/

# load the katana-kubernetes.tar in the minikube local docker
step "Loading katana-kubernetes.tar into minikube docker."
ssh -o StrictHostKeyChecking=no -o "UserKnownHostsFile /dev/null" -t -i ~/.minikube/machines/minikube/id_rsa docker@$MINIKUBE_IP \                     \
  "docker load -i katana-kubernetes.tar"

step "Removing katana-kubernetes.tar"
rm ${dir}/katana-kubernetes.tar

ok "Finished loading magnetnicio/vamp:katana-kubernetes to minikube."
