FROM buchgr/bazel-remote-cache

LABEL org.opencontainers.image.authors="cccuroky@gmail.com"

ENTRYPOINT [ \
  "/app/bazel-remote-base.binary",  \
  # "--dir=/data/remote-cache",       \
  # "--max_size=2",                   \
  "--http_address=:8080",           \
  "--profile_address=:6060"         \
]
