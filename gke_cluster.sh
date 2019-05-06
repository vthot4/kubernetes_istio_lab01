#!/bin/bash
#########################################################################################
##
##  Author:     vthot4
##  Date:       06/05/2019
##  License:    MIT License
## 
##  Purpose: gke cluster manage
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
readonly NUM_NODES='3'

gcloud beta container \
    --project ${PROJECT_ID} clusters create ${CLUSTER_NAME} \ 
    --zone ${ZONE} \
    --username ${USER} \
    --cluster-version  ${GKE_VERSION} \
    --machine-type ${MACHINE_TYPE} \
    --image-type ${IMAGE_TYPE} \
    --disk-type "pd-standard" \
    --disk-size "100" \
    --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" \
    --num-nodes ${NUM_NODES} \
    --enable-cloud-logging \
    --enable-cloud-monitoring \ 
    --enable-ip-alias \ 
    --network "projects/${PROJECT_ID}/global/networks/default" \
    --subnetwork "projects/${PROJECT_ID}/regions/${ZONE}/subnetworks/default" \
    --addons HorizontalPodAutoscaling,HttpLoadBalancing,KubernetesDashboard \
    --enable-autoupgrade \
    --enable-autorepair 
