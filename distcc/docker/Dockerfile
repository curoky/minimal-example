FROM debian:11

LABEL Author=cccuroky@gmail.com

USER root
WORKDIR /root

RUN apt-get update \
  && apt-get install -y -qq --no-install-recommends \
    ca-certificates wget gnupg2 \
  && echo "deb http://apt.llvm.org/bullseye/ llvm-toolchain-bullseye main" >>/etc/apt/sources.list \
  && wget -qO - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - \
  && apt-get update \
  && apt-get install -y -qq --no-install-recommends \
    distcc ccache gcc-10 g++-10 clang-11 \
  && ln -sf /usr/bin/gcc-10 /usr/bin/gcc \
  && ln -sf /usr/bin/g++-10 /usr/bin/g++ \
  && ln -sf /usr/bin/clang-11 /usr/bin/clang \
  && ln -sf /usr/bin/clang++-11 /usr/bin/clang++ \
  && apt-get -y autoremove && apt-get clean \
  && rm -rf /root/* /tmp/*

# copy from https://github.com/kwk/distcc-docker-images/blob/master/Dockerfile
# ref: https://medium.com/@wilsonhong/distcc-using-ccache-on-distcc-server-6abebe906971
#      https://stackoverflow.com/questions/6249620/how-to-get-ccache-to-not-pass-the-full-path-to-the-compiler-to-distcc/37381243#37381243

# prepare ccache
RUN mkdir -p /opt/ccache \
  && ln -sf /usr/bin/ccache /opt/ccache/gcc       \
  && ln -sf /usr/bin/ccache /opt/ccache/gcc-10    \
  && ln -sf /usr/bin/ccache /opt/ccache/g++       \
  && ln -sf /usr/bin/ccache /opt/ccache/g++-10    \
  && ln -sf /usr/bin/ccache /opt/ccache/clang     \
  && ln -sf /usr/bin/ccache /opt/ccache/clang-11  \
  && ln -sf /usr/bin/ccache /opt/ccache/clang++   \
  && ln -sf /usr/bin/ccache /opt/ccache/clang++-11

COPY ./conf/cmdlist.conf /etc/distcc/cmdlist.config
COPY ./conf/ccache.conf /etc/ccache.conf

ENV DISTCC_CMDLIST=/etc/distcc/cmdlist.config
ENV TMPDIR=/dev/shm

# Define how to start distccd by default
# (see "man distccd" for more information)
ENTRYPOINT [ \
  "distccd"      ,                          \
  "--daemon"     ,                          \
  "--user"       , "distccd",                \
  "--listen"     , "0.0.0.0",               \
  "--port"       , "23632",                 \
  "--stats"      ,                          \
  "--stats-port" , "23633",                 \
  "--log-file"   , "/var/log/distccd.log",  \
  "--log-level"  , "info",                  \
  "--no-detach"                             \
  ]

# By default the distcc server will accept clients from everywhere.
# Feel free to run the docker image with different values for the
# following params.
CMD [ \
  "--nice", "5", \
  #   "--jobs", "5", \
  "--allow", "0.0.0.0/0" \
  ]

EXPOSE \
  23632/tcp \
  23633/tcp
