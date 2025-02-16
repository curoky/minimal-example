FROM ubuntu:24.04

RUN apt-get update -y \
  && apt-get install -y sudo curl git perl zip unzip tar

# setup user
RUN useradd --create-home --user-group ci \
  && usermod -aG sudo ci \
  && echo "ci ALL=(ALL:ALL) NOPASSWD:ALL" >>/etc/sudoers.d/nopasswd_user

# setup go-task
RUN curl -sSL https://github.com/go-task/task/releases/download/v3.41.0/task_linux_amd64.tar.gz | tar -xz -C /usr/local/bin \
  && chmod +x /usr/local/bin/task

# setup gcc 13 as default
RUN apt-get install -y gcc-13 g++-13 \
  && ln -sf /usr/bin/gcc-13 /usr/bin/gcc \
  && ln -sf /usr/bin/g++-13 /usr/bin/g++

# setup extra build tools
RUN apt-get install -y pkg-config autoconf libtool make cmake ninja-build lld ccache

# setup python3
ENV PATH=$PATH:/usr/local/conda/bin
RUN curl -sSL -o /tmp/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-py312_24.7.1-0-Linux-x86_64.sh \
  && bash /tmp/miniconda.sh -b -u -p /usr/local/conda

# switch user
USER ci
WORKDIR /home/ci/workspace

# setup user's local dir
ENV PATH=$PATH:/home/ci/.local/bin
RUN mkdir -p /home/ci/.local/bin
############################ end setup ############################

COPY --chown=ci:ci .  .

RUN task cpm \
  && task default
