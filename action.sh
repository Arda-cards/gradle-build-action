#!/usr/bin/env bash

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

echo "::group::Build"
export IS_MAIN_BRANCH
export IS_PULL_REQUEST
if [ "${SKIP_TEST}" = "true" ]; then
  ./gradlew build buildImage -x test "${gradle_arguments[@]}"
else
  ./gradlew build buildImage "${gradle_arguments[@]}"
fi
echo "::endgroup::"

if [ "$GITHUB_REF" = "refs/heads/main" ]; then

  chart=$(ls build/helm/charts/*.tgz)
  if [ -f "${chart}" ]; then
    echo "::group::Publish Helm"
    echo "Pushing chart ${chart}"
    echo "${GITHUB_TOKEN}" | helm registry login ghcr.io -u $ --password-stdin
    helm push "${chart}" "oci://ghcr.io/arda-cards/charts"
    echo "::endgroup::"
  fi

  jib_json=build/jib-image.json
  jib_tar=build/jib-image.tar
  if [ -f "${jib_json}" ] && [ -f "${jib_tar}" ]; then
    echo "::group::Publish Docker"
    image=$(jq -r '( .image + ":" + . .tags[0] )' <"${jib_json}")
    remote_image="ghcr.io/arda-cards/containers/${image}"

    echo "Pushing docker ${image} to ${remote_image}"
    echo "${GITHUB_TOKEN}" | docker login ghcr.io -u $ --password-stdin
    docker image load --input "${jib_tar}"
    docker tag "${image}" "${remote_image}"
    docker push "${remote_image}"
    echo "::endgroup::"
  fi
fi
