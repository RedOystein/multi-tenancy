#!/usr/bin/env bash

set -o errexit

: ${1?"Usage: $0 <TEAM NAME>"}
: ${2?"Usage: $0 <CLUSTER_FILE_PATH>"}
: ${3?"Usage: $0 <TEAM_GIT_URL>"}

TEAM_NAME=$1
CLUSTER_FILE_PATH=$2
GIT_URL=$3
TEMPLATE="team1"
GIT_URL_TEMPLATE="<GIT_URL>"
REPO_ROOT=$(git rev-parse --show-toplevel)
TEAM_DIR="${REPO_ROOT}/base/teams/${TEAM_NAME}/"

mkdir -p ${TEAM_DIR}

cp -r "${REPO_ROOT}/templates/${TEMPLATE}/." ${TEAM_DIR}

for f in ${TEAM_DIR}*.yaml
do
  if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "s/$TEMPLATE/$TEAM_NAME/g" ${f}
    sed -i '' "s/$GIT_URL_TEMPLATE/$GIT_URL/g" ${f}
  else
    sed -i "s/$TEMPLATE/$TEAM_NAME/g" ${f}
    sed -i "s;$GIT_URL_TEMPLATE;$GIT_URL;g" ${f}
  fi
done

echo "${TEAM_NAME} created at ${TEAM_DIR}"
echo "  - ./${TEAM_NAME}/" >> "${REPO_ROOT}/base/teams/kustomization.yaml"
echo "${TEAM_NAME} added to ${REPO_ROOT}/${CLUSTER_FILE_PATH}/kustomization.yaml"
