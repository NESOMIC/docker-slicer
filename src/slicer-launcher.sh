#!/usr/bin/env bash
# /usr/bin/slicer: starts 3D Slicer on the GPU when the container has one, in software otherwise.
#
# With a GPU, Slicer runs under VirtualGL with its EGL back end: OpenGL renders on the card through
# libEGL_nvidia (mounted by the NVIDIA container runtime, no X server on the GPU needed) and
# VirtualGL copies every finished frame into the KasmVNC display.
#
# NVIDIA PRIME render offload (__NV_PRIME_RENDER_OFFLOAD / __GLX_VENDOR_LIBRARY_NAME=nvidia) is NOT
# a substitute: it renders on the card too, but the frames never reach Xvnc and the Slicer window
# stays black (seen on EKS g4dn/T4, 2026-11-15).
if { [ -e /dev/nvidia0 ] || command -v nvidia-smi >/dev/null 2>&1; } && [ -x /usr/bin/vglrun ]; then
    echo "Starting 3D Slicer with GPU acceleration (VirtualGL, EGL)"
    exec /usr/bin/vglrun -d egl /slicer/Slicer "$@"
fi
echo "Starting 3D Slicer with software rendering (no GPU found)"
exec /slicer/Slicer "$@"
