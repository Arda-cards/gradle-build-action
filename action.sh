#!/usr/bin/env bash

# Force en_US.UTF-8
sudo locale-gen en_US
sudo locale-gen en_US.UTF-8
locale -a
LANG=en_US.UTF-8
LC_ALL=en_US.UTF-8
export LANG
export LC_ALL

set -eu

gradle_arguments=()
if [ "${VERSION}" ]; then
  gradle_arguments+=("-Pversion=$VERSION")
fi

echo "::group::Build"
export IS_MAIN_BRANCH
export IS_PULL_REQUEST
if [ "${SKIP_TEST}" = "true" ]; then
  ./gradlew test buildImage helmPackage -x test "${gradle_arguments[@]}"
else
  ./gradlew test buildImage helmPackage "${gradle_arguments[@]}"
fi
echo "::endgroup::"
