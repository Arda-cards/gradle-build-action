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

#if [ "$GITHUB_REF" = "refs/heads/main" ]; then
  echo "::group::Publish"
  ## Helm
  chart=$(ls build/helm/charts/*.tgz)
  if [ -f "${chart}" ]; then
    echo "Pushing chart ${chart}"
    echo "${GITHUB_TOKEN}" | helm registry login ghcr.io -u $ --password-stdin
    helm push "${chart}" "oci://ghcr.io/arda-cards"
  fi

  echo "::endgroup::"
#fi
