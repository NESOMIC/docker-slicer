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

# The NVIDIA variables route OpenGL to the card. Set without a card they leave GLX with no usable
# vendor library and Slicer does not start, so they are only exported when a GPU is present.
cat >/usr/bin/slicer <<'EOS'
#!/usr/bin/env bash
if [ -e /dev/nvidia0 ] || command -v nvidia-smi >/dev/null 2>&1; then
    echo "Starting 3D Slicer with GPU acceleration"
    export __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia
else
    echo "Starting 3D Slicer with software rendering (no GPU found)"
fi
exec /slicer/Slicer "$@"
EOS
chmod +x /usr/bin/slicer

rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*
