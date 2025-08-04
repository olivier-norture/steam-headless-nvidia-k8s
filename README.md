# steam-headless-nvidia-k8s

[![Publish Docker image](https://github.com/olivier-norture/steam-headless-nvidia-k8s/actions/workflows/publish.yml/badge.svg)](https://github.com/olivier-norture/steam-headless-nvidia-k8s/actions/workflows/publish.yml)

This project provides a Docker image for running a headless Steam client with NVIDIA GPU support, designed for use in a Kubernetes environment. It is based on the excellent [docker-steam-headless](https://github.com/Steam-Headless/docker-steam-headless) project.

The key feature of this image is the inclusion of NVIDIA drivers, allowing you to schedule the container on a Kubernetes node and grant it access to a physical GPU.

## Features

*   Based on the popular `docker-steam-headless` image.
*   Includes NVIDIA drivers for hardware acceleration in a container.
*   Designed for deployment in Kubernetes with GPU resource requests.
*   Automated builds and publishing to GitHub Container Registry (GHCR).

## A Note on NVIDIA Drivers

While the standard practice for GPU-accelerated containers in Kubernetes is to rely on the NVIDIA Operator to inject driver libraries at runtime, this image intentionally includes the full NVIDIA driver stack. This design choice is necessary to support a full desktop environment within the container.

Running graphical applications and desktop environments requires a complete and consistent set of user-space driver components (OpenGL, Vulkan, X11, etc.) that are perfectly aligned with the kernel driver on the host. Relying on runtime injection can lead to instability and failures when initializing a graphical session. By baking the drivers into the image, we ensure the necessary components are present and correctly configured, providing a stable platform for running a remote desktop environment.

This approach creates a tight coupling between the image and the host's driver version. If you update the NVIDIA drivers on your Kubernetes nodes, you will need to rebuild this Docker image to match.

## Getting Started

### Prerequisites

*   A Kubernetes cluster with NVIDIA GPU nodes.
*   The [NVIDIA device plugin for Kubernetes](https://github.com/NVIDIA/k8s-device-plugin) must be installed and configured in your cluster.

### Usage

You can pull the pre-built image from the GitHub Container Registry.

**Image Registry:** `ghcr.io/olivier-norture/steam-headless-nvidia-k8s`

Here is an example of a Kubernetes StatefulSet to run this container:

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: steam-headless
  namespace: steam-headless
spec:
  serviceName: "steam-headless"
  replicas: 1
  selector:
    matchLabels:
      app: steam-headless
  template:
    metadata:
      labels:
        app: steam-headless
    spec:
      hostNetwork: true
      securityContext:
        fsGroup: 1000
      containers:
      - name: steam-headless
        securityContext:
          privileged: true
        image: ghcr.io/olivier-norture/steam-headless-nvidia-k8s:latest
        imagePullPolicy: Always
        ports:
        - containerPort: 8083
          name: http
          protocol: TCP
        resources: #Change CPU and Memory below
          requests:
            memory: "20G"
            cpu: "12"
            nvidia.com/gpu: 1 #If you're using a nvidia GPU, add it here
          limits:
            memory: "30G"
            cpu: "14"
            nvidia.com/gpu: 1 #If you're using a nvidia GPU, add it here
        volumeMounts:
        - name: home-dir
          mountPath: /home/default/
        - name: games-dir
          mountPath: /mnt/games/
        - name: input-devices
          mountPath: /dev/input/
        - name: uinput
          mountPath: /dev/uinput
          readOnly: false
        - name: dshm
          mountPath: /dev/shm
        env: #Environmental Vars
        - name: NAME
          value: 'SteamHeadless'
        - name: TZ
          value: 'Europe/Paris'
        - name: USER_LOCALES
          value: 'en_US.UTF-8 UTF-8'
        - name: DISPLAY
          value: ':55'
        - name: SHM_SIZE
          value: '2G'
        - name: DOCKER_RUNTIME
          value: 'nvidia'
        - name: PUID
          value: '1000'
        - name: PGID
          value: '1000'
        - name: UMASK
          value: '000'
        - name: USER_PASSWORD
          value: 'CHANGE_ME' #changeme
        - name: MODE
          value: 'primary'
        - name: WEB_UI_MODE
          value: 'vnc'
        - name: ENABLE_VNC_AUDIO
          value: 'false'
        - name: PORT_NOVNC_WEB
          value: '8083'
        - name: NEKO_NAT1TO1
          value: ''
        - name: ENABLE_SUNSHINE
          value: 'true'
        - name: SUNSHINE_USER
          value: 'sam'
        - name: SUNSHINE_PASS
          value: 'CHANGE_ME'
        - name: ENABLE_EVDEV_INPUTS
          value: 'true'
        - name: NVIDIA_DRIVER_CAPABILITIES
          value: 'all'
        - name: NVIDIA_VISIBLE_DEVICES
          value: 'all'
      volumes:
      - name: home-dir
        persistentVolumeClaim:
          claimName: home
      - name: games-dir
        hostPath:
          path: /var/steam-games
          type: DirectoryOrCreate
      - name: input-devices
        hostPath:
          path: /dev/input/
      - name: uinput
        hostPath:
          path: /dev/uinput
          type: CharDevice
      - name: dshm
        emptyDir:
          medium: Memory
```

## Building from Source

The pre-built images are configured with a specific NVIDIA driver version. If the nodes in your cluster use a different driver version, you may need to build the image yourself.

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/olivier-norture/steam-headless-nvidia-k8s.git
    cd steam-headless-nvidia-k8s
    ```

2.  **Update the NVIDIA driver version:**
    Edit the `Dockerfile` and change the `NVIDIA_VERSION` build argument to match your environment.
    ```Dockerfile
    # Example:
    ARG NVIDIA_VERSION=570
    ```

3.  **Build the Docker image:**
    ```bash
    docker build -t steam-headless-nvidia-k8s .
    ```

## Versioning

The `docker-steam-headless` base image does not have traditional versioning and publishes releases under the `latest` tag.

To provide some level of version tracking, the images in this repository are tagged using the following scheme:

`<date>-<nvidia_driver_version>`

For example: `20250804-570`

The `latest` tag always points to the most recently built image.

## Acknowledgments

*   This project is heavily based on the work of the [docker-steam-headless](https://github.com/Steam-Headless/docker-steam-headless) team.