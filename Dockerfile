FROM ubuntu:22.04
MAINTAINER https://github.com/alitekin2fx/docker-arm-none-eabi

# Install prerequsites
RUN apt-get update && \
    apt-get install -y wget make bzip2

ARG TOOLCHAIN_PATH=/opt/gcc-arm-none
# https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-rm/downloads
ARG TOOLCHAIN_TARBALL_URL="https://developer.arm.com/-/media/Files/downloads/gnu-rm/10.3-2021.10/gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2"

# Install toolchain
RUN wget --progress=bar:force ${TOOLCHAIN_TARBALL_URL} \
	&& export TOOLCHAIN_TARBALL_FILENAME=$(basename "${TOOLCHAIN_TARBALL_URL}") \
	&& tar -xvf ${TOOLCHAIN_TARBALL_FILENAME} \
	&& mv $(dirname $(tar -tf ${TOOLCHAIN_TARBALL_FILENAME} | head -1)) ${TOOLCHAIN_PATH} \
	&& rm -rf ${TOOLCHAIN_PATH}/share/doc \
	&& rm ${TOOLCHAIN_TARBALL_FILENAME}
ENV PATH="${TOOLCHAIN_PATH}/bin:${PATH}"

## cleanup
RUN apt-get clean autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

