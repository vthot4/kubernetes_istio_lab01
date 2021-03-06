#!/bin/bash
#########################################################################################
##
##  Author:     vthot4
##  Date:       06/05/2019
##  License:    MIT License
## 
##  Purpose: gke cluster basic management
##
##########################################################################################

## CONSTANTS ##

readonly PROJECT_ID='hackio'
readonly CLUSTER_NAME='lab01'
readonly ZONE='europe-west3-c'
readonly USER='admin'
readonly GKE_VERSION='1.11.8-gke.6'
readonly MACHINE_TYPE='n1-standard-1'
readonly IMAGE_TYPE='COS'
readonly NUM_NODES='1'


help()
{
	echo ""
	echo $0:
	echo "	create	Create a cluster gke with the specifications in CONSTANTS."
	echo "	delete	Delete gke cluster"
	echo "	resize  Resize cluster ( resize N)"
	echo "	connect	Connect with Kubernetes's new environment"
	echo "	help	show help"

	echo ""		
}

case $1 in
create)
	gcloud beta container \
	--project ${PROJECT_ID} clusters create ${CLUSTER_NAME} \
	--zone ${ZONE} \
	--username ${USER} \
	--cluster-version ${GKE_VERSION} \
	--machine-type ${MACHINE_TYPE} \
	--image-type "COS" \
	--disk-type "pd-standard" \
	--disk-size "100" \
	--scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" \
	--num-nodes ${NUM_NODES} \
	--enable-cloud-logging \
	--enable-cloud-monitoring \
	--no-enable-ip-alias \
	--network "projects/hackio/global/networks/default" \
	--subnetwork "projects/hackio/regions/europe-west3/subnetworks/default" \
	--addons HorizontalPodAutoscaling,HttpLoadBalancing,KubernetesDashboard \
	--enable-autoupgrade \
	--enable-autorepair
	;;

delete)
	    gcloud container clusters delete ${CLUSTER_NAME} --zone ${ZONE}
    ;;

resize)
    if [ -z "$2" ]; then
        echo "You must provide a valid number of nodes"
    else
        gcloud container clusters resize ${CLUSTER_NAME} --size=$2 --zone ${ZONE}
    fi
    ;;

connect)
	gcloud container clusters get-credentials ${CLUSTER_NAME} --zone ${ZONE} --project ${PROJECT_ID}
	kubectl config current-context
	;;
info)
	echo ""
	echo " Actual context:"
	echo " ---------------"
	kubectl config current-context
	echo ""
	echo " Cluster info:"
	echo " -------------"
	kubectl cluster-info
	echo ""
	echo " Cluster nodes:"
	echo " -------------"
	kubectl get nodes
	echo ""
	;;
*)
	help
	;;
esac

