#!/usr/bin/env bash

set -ex

cd "$(dirname "$0")"

apt-get update
# libgl1-mesa-dri: software OpenGL (llvmpipe), used when the container has no GPU.
# libxcb-* / libxkbcommon-x11-0: runtime dependencies of the Qt xcb platform plugin bundled with Slicer.
apt-get install -y libpulse-dev libnss3 libglu1-mesa libgl1-mesa-dri \
    libxcb-icccm4 libxcb-image0 libxcb-keysyms1 libxcb-randr0 libxcb-render-util0 \
    libxcb-shape0 libxcb-xkb1 libxkbcommon-x11-0
apt-get install -y --reinstall libxcb-xinerama0
apt-get clean

wget "$SLICER_DOWNLOAD_URL" -O slicer.tar.gz

mkdir /slicer
tar -xf slicer.tar.gz -C /slicer --strip-components 1
rm slicer.tar.gz

# The launcher, /usr/bin/slicer, is slicer-launcher.sh (copied by the Dockerfile).

rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*
