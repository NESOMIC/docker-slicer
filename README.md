# docker-slicer

This repository holds a Docker image configured to run the 3D Slicer application in a VNC server compatible with 3D acceleration using Nvidia GPUs. It also includes a WebDAV server with a web UI running on port 8085.

## Nesomic

Branch `nesomic` is the image used for the per-user sessions of the Nesomic
[Slicer Hub](https://github.com/NESOMIC/3dslicerhub): current stable 3D Slicer, GPU rendering
through VirtualGL's EGL back end when the container has an NVIDIA card and software rendering
otherwise (see `src/slicer-launcher.sh`), and
scenes / DICOM database defaulting to `~/Documents`, the directory the hub persists. The `k8s/`
directory is the original single-session deployment and is not used by the hub.

## Instructions

Build the image locally:

```bash
cd src
docker build -t slicer --build-arg BASE_IMAGE="vnc-base:latest" .
```

Run the image locally:

```bash
docker run --rm -it --gpus all --shm-size=512m -p 6901:6901 -p 8085:8085 -e VNC_DISABLE_AUTH=true --user root slicer
```

To access 3D Slicer locally through VNC:
- Open a browser and go to: http://localhost:6901

To access the WebDAV UI locally:
- Open a browser and go to: http://localhost:8085

## Configuration

Available environment variables:

| Variable                                  | Description                                                                                   | Default     |
|-------------------------------------------|-----------------------------------------------------------------------------------------------|-------------|
| VNC_DISABLE_AUTH                          | Disable VNC authentication (no user/password required, use with caution)                      | false       |
| VNC_PW                                    | Password for the basic auth (the user is always: "user")                                      | vncpassword |
| VNC_PORT                                  | VNC port                                                                                      | 6901        |
| VNC_ALLOW_CLIENT_TO_OVERRIDE_VNC_SETTINGS | Enable/disable the client to override the VNC settings, it does not have effect on the web UI | false       |

## Deployment

To deploy the application to a Kubernetes cluster:

```bash
cd k8s
kubectl apply -k .     
```

## License, authors and funding

BSD 3-Clause License, the same as the rest of the NESOMIC platform: see `LICENSE`. Copyright
belongs to the NESOMIC authors listed in `AUTHORS`.

Started in the OpenDx28 project and continued under a commission from the Cabildo de Gran
Canaria.
Based on [OpenDx28/docker-slicer](https://github.com/OpenDx28/docker-slicer). Bundled third-party code keeps
its own license, listed below.

## Third-party copyright notices

License for files `.devcontainer/library-scripts/common-debian.sh` and `.devcontainer/library-scripts/docker-debian.sh`

    MIT License

    Copyright (c) Microsoft Corporation. All rights reserved.

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE


License for EasyDAV (`src/easydav`)

    License
    -------

    Copyright 2010-2012 Petteri Aimonen <jpa at wd.mail.kapsi.fi>

    Redistribution and use in source and binary forms, with or without modification, are
    permitted provided that the following conditions are met:

       1. Redistributions of source code must retain the above copyright notice, this list of
          conditions and the following disclaimer.

       2. Redistributions in binary form must reproduce the above copyright notice, this list
          of conditions and the following disclaimer in the documentation and/or other materials
          provided with the distribution.

