ARG NVIDIA_VERSION=570
ARG NVIDIA_VERSION_EXTENDED="=570.148.08-0ubuntu1"
ARG STEAM_HEADLESS_VERSION="latest"

FROM josh5/steam-headless:${STEAM_HEADLESS_VERSION}

ARG NVIDIA_VERSION
ARG NVIDIA_VERSION_EXTENDED



# Install CUDA keyring and update APT
RUN apt-get update && apt-get install -y wget gnupg ca-certificates && \
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb && \
    dpkg -i cuda-keyring_1.1-1_all.deb && \
    apt-get update

# Install required NVIDIA libraries for OpenGL and X
RUN apt-get install -y \
    libnvidia-gl-${NVIDIA_VERSION}${NVIDIA_VERSION_EXTENDED} \
    libnvidia-gl-${NVIDIA_VERSION}:i386${NVIDIA_VERSION_EXTENDED} \
    nvidia-utils-${NVIDIA_VERSION}${NVIDIA_VERSION_EXTENDED} \
    libnvidia-compute-${NVIDIA_VERSION}${NVIDIA_VERSION_EXTENDED} \
    libnvidia-compute-${NVIDIA_VERSION}:i386${NVIDIA_VERSION_EXTENDED} \
    libnvidia-cfg1-${NVIDIA_VERSION}${NVIDIA_VERSION_EXTENDED} \
    libnvidia-decode-${NVIDIA_VERSION}${NVIDIA_VERSION_EXTENDED} \
    libnvidia-decode-${NVIDIA_VERSION}:i386${NVIDIA_VERSION_EXTENDED} \
    xserver-xorg-video-nvidia-${NVIDIA_VERSION}${NVIDIA_VERSION_EXTENDED} \
    x11-xserver-utils \
    nvidia-persistenced${NVIDIA_VERSION_EXTENDED} \
    libnvidia-encode-${NVIDIA_VERSION}${NVIDIA_VERSION_EXTENDED} \
    libnvidia-encode-${NVIDIA_VERSION}:i386${NVIDIA_VERSION_EXTENDED} \
    libnvidia-fbc1-${NVIDIA_VERSION}${NVIDIA_VERSION_EXTENDED} \
    libnvidia-fbc1-${NVIDIA_VERSION}:i386${NVIDIA_VERSION_EXTENDED} \
    nvidia-xconfig && \
    apt-mark hold libnvidia-gl-${NVIDIA_VERSION} nvidia-utils-${NVIDIA_VERSION} libnvidia-compute-${NVIDIA_VERSION} \
                  libnvidia-cfg1-${NVIDIA_VERSION} libnvidia-decode-${NVIDIA_VERSION} \
                  xserver-xorg-video-nvidia-${NVIDIA_VERSION} nvidia-persistenced

RUN nvidia-xconfig --preserve-busid --enable-all-gpus

RUN rm -f /etc/cont-init.d/60-configure_gpu_driver.sh

COPY overlay/etc/cont-init.d/* /etc/cont-init.d/
COPY overlay/usr/local/bin/* /usr/local/bin/