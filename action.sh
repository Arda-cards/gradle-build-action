#!/usr/bin/env bash

[ "${RUNNER_DEBUG}" == 1 ] && set -xv

set -eu

echo "::group::Initialize locale"
# Force en_US.UTF-8
sudo locale-gen en_US
sudo locale-gen en_US.UTF-8
locale -a
LANG=en_US.UTF-8
LC_ALL=en_US.UTF-8
export LANG
export LC_ALL
echo "::endgroup::"

gradle_arguments=()
if [ "${VERSION}" ]; then
  gradle_arguments+=("-Pversion=$VERSION")
fi

if [ "${SKIP_TEST}" = "true" ]; then
  gradle_arguments+=("-x" "test")
fi

case "${KIND}" in
test) ;;
publish)
  gradle_arguments+=("publish")
  if [ -z "${VERSION}" ]; then
    echo "::error Version required to publish"
    exit 1
  fi
  ;;
*)
  echo "::error Unknown value ${KIND}, has to be one of (publish|test)"
  exit 1
  ;;
esac

echo "::group::Build"
./gradlew build "${gradle_arguments[@]}"
echo "::endgroup::"

if [ "${KIND}" = "publish" ]; then

  # Assuming a single chart in the module...
  readonly chartDir=build/helm/charts
  # Creating the dir to prevent error when there no charts
  mkdir -p ${chartDir}
  chartTgz=$(find ${chartDir} -name '*.tgz')
  if [ -f "${chartTgz}" ]; then
    echo "::group::Publish Helm"
    echo "Pushing chart ${chartTgz} to ${HELM_REGISTRY}"
    echo "${GITHUB_TOKEN}" | helm registry login ghcr.io -u $ --password-stdin
    helm push "${chartTgz}" "${HELM_REGISTRY}"

    declare -A chartProperties
    # read file line by line and populate the array.   Field separator is ":"
    while IFS=':' read -r k v; do
      [[ -n $k ]] && chartProperties["$k"]="${v## }"
    done <${chartDir}/*/Chart.yaml
    echo "chart_name=${chartProperties[name]}" >>"${GITHUB_OUTPUT}"
    echo "chart_version=${chartProperties[version]}" >>"${GITHUB_OUTPUT}"
    echo "::endgroup::"
  fi

  jib_json=build/jib-image.json
  jib_tar=build/jib-image.tar
  if [ -f "${jib_json}" ] && [ -f "${jib_tar}" ]; then
    echo "::group::Publish Docker"
    image=$(jq -r '( .image + ":" + . .tags[0] )' <"${jib_json}")
    remote_image="${DOCKER_REGISTRY}/${image}"

    echo "Pushing docker ${image} to ${remote_image}"
    echo "${GITHUB_TOKEN}" | docker login ghcr.io -u $ --password-stdin
    docker image load --input "${jib_tar}"
    docker tag "${image}" "${remote_image}"
    docker push "${remote_image}"
    echo "::endgroup::"
  fi
fi
