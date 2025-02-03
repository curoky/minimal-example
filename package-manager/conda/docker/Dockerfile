ARG OS="ubuntu:22.04"
FROM ${OS}

LABEL Author=cccuroky@gmail.com

ENV PATH=/opt/conda/bin:$PATH
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq \
  && apt-get install -y -qq --no-install-recommends \
    wget gcc g++ make ca-certificates \
  # 1. https://docs.conda.io/en/latest/miniconda.html
  # 2. https://hub.docker.com/r/continuumio/miniconda/dockerfile
  && wget "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh" \
    --output-document="/tmp/miniconda.sh" --no-verbose \
  && bash /tmp/miniconda.sh -bfp /opt/conda 1>/dev/null \
  && rm /tmp/miniconda.sh \
  && conda config --system --prepend channels conda-forge \
  && conda config --system --set auto_update_conda false \
  && conda config --system --set show_channel_urls true \
  && conda config --system --set channel_priority strict \
  && conda update -y conda \
  && conda update -y python \
  && conda update -y --all \
  && conda clean --all -f -y \
  && apt-get autoremove -y -qq && apt-get clean -qq
