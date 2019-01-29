#!/bin/sh

set -e

gcloud auth activate-service-account --key-file=/keyFile

echo "checking for existing vpc"

if eval "gcloud compute networks describe $name --project $projectId" >/dev/null 2>&1
then
  echo "found exiting vpc"
  exit
else
  echo "existing vpc not found"
fi

echo "creating vpc..."
networkCreateCmd="gcloud compute networks create $name"
networkCreateCmd=$(printf "%s --project %s" "$networkCreateCmd" "$projectId")
networkCreateCmd=$(printf "%s --bgp-routing-mode %s" "$networkCreateCmd" "$bgpRoutingMode")
networkCreateCmd=$(printf "%s --subnet-mode %s" "$networkCreateCmd" "$subnetMode")

# handle opts
if [ "$description" != " " ]; then
  networkCreateCmd=$(printf "%s --description" "$description")
fi
if [ "$range" != " " ]; then
  networkCreateCmd=$(printf "%s --range" "$range")
fi

eval "$networkCreateCmd"