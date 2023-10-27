FROM debian:bookworm-slim
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get clean && apt-get update && apt-get dist-upgrade -yq && apt-get install -yq \
      autopoint \
      dbus \
      debhelper \
      devscripts \
      dh-autoreconf \
      dh-exec \
      fakeroot \
      gosu \
      libblkid-dev \
      libdbus-1-dev \
      libexpat1-dev \
      libext2fs-dev \
      pkg-config \
      wget \
      && apt-get clean

# Test depends on not running as root.
RUN useradd unprivileged

# TODO verify the checksum of the orig.tar.gz file..
RUN mkdir work && chown unprivileged work && \
    cd work && \
    gosu unprivileged wget https://archive.debian.org/debian/pool/main/libn/libnih/libnih_1.0.3.orig.tar.gz && \
    gosu unprivileged git clone https://salsa.debian.org/dancer/libnih.git && \
    cd libnih && \
    gosu unprivileged git checkout bookworm && \
    gosu unprivileged dpkg-buildpackage -j && \
    debi

