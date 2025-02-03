# https://hub.docker.com/r/linuxbrew/linuxbrew/dockerfile
# https://github.com/Homebrew/brew/blob/master/Dockerfile
# https://github.com/Linuxbrew/docker/blob/master/bionic/Dockerfile
# https://github.com/Linuxbrew/docker/blob/master/debian10/Dockerfile
# https://discourse.brew.sh/t/why-do-bottles-need-to-be-in-home-linuxbrew-linuxbrew/4346

ARG OS="ubuntu:22.04"
FROM ${OS}
ARG OS

LABEL Author=cccuroky@gmail.com

ARG HOMEBREW_PREFIX=/home/linuxbrew
ARG HOMEBREW_GIT=https://github.com/Homebrew/brew

ENV PATH=${HOMEBREW_PREFIX}/.linuxbrew/bin:${HOMEBREW_PREFIX}/.linuxbrew/sbin:$PATH \
  HOMEBREW_NO_ANALYTICS=1 \
  HOMEBREW_NO_AUTO_UPDATE=1 \
  HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1 \
  DEBIAN_FRONTEND=noninteractive

RUN if [ "${OS}" == "ubuntu:16.04" ]; then \
    apt-get update \
    && apt-get install -y --no-install-recommends software-properties-common \
    && add-apt-repository -y ppa:git-core/ppa ; \
  fi

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
    curl ca-certificates git file g++ locales make uuid-runtime patch sudo \
	&& rm -rf /var/lib/apt/lists/* \
  && localedef -i en_US -f UTF-8 en_US.UTF-8 \
  && useradd -m -s /bin/bash linuxbrew \
  && echo 'linuxbrew ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers

WORKDIR ${HOMEBREW_PREFIX}
RUN git clone --depth=1 ${HOMEBREW_GIT} ${HOMEBREW_PREFIX}/.linuxbrew/Homebrew \
  && cd ${HOMEBREW_PREFIX}/.linuxbrew \
  && mkdir -p bin etc include lib opt sbin share var/homebrew/linked Cellar \
  && ln -s ../Homebrew/bin/brew ${HOMEBREW_PREFIX}/.linuxbrew/bin/ \
  && brew tap homebrew/core \
  && brew install-bundler-gems \
  && brew cleanup \
  && { git -C ${HOMEBREW_PREFIX}/.linuxbrew/Homebrew config --unset gc.auto; true; } \
  && { git -C ${HOMEBREW_PREFIX}/.linuxbrew/Homebrew config --unset homebrew.devcmdrun; true; } \
  && rm -rf ~/.cache \
  && chown -R linuxbrew: ${HOMEBREW_PREFIX}/.linuxbrew \
  && chmod -R g+w,o-w ${HOMEBREW_PREFIX}/.linuxbrew
