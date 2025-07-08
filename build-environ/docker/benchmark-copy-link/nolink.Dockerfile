# Dockerfile

# --- Stage 1: Builder ---
FROM ubuntu:latest AS builder

WORKDIR /app

RUN echo "Creating a 500MB test file..." && \
    dd if=/dev/zero of=bigfile.dat bs=50M count=1000 && \
    echo "Test file created."


FROM ubuntu:latest AS final-nolink

WORKDIR /data

COPY --from=builder /app/bigfile.dat .