#!/bin/bash
set -e -o pipefail
read -ra arr <<< "$@"
version=${arr[1]}
trap 0 1 2 ERR
# Extract DISTRO details for tagging
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO="$ID-$VERSION_ID"
    if [ "$VERSION_CODENAME" != "" ]; then
        DISTRO="$ID-$VERSION_CODENAME"
    fi
fi
current_dir="$PWD"
echo $DISTRO > .distro_zab.txt
# Ensure sudo is installed along with utilities to build rpm and deb packages
apt-get update && apt-get install sudo -y
bash /tmp/linux-on-ibm-z-scripts/Bazel/${version}/build_bazel.sh -y
tar cvfz bazel-${version}-linux-s390x.tar.gz -C $PWD/bazel/bazel-bin/src bazel
exit 0
