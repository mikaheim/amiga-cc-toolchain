# Build stage
FROM ubuntu:latest AS build

WORKDIR /tmp
RUN apt-get -y update && apt -y install make wget git gcc g++ lhasa libgmp-dev \
    libmpfr-dev libmpc-dev flex bison gettext texinfo ncurses-dev autoconf \
    rsync libreadline-dev
RUN git clone https://github.com/mikaheim/amiga-gcc
WORKDIR /tmp/amiga-gcc
RUN make all

# Final image stage
FROM ubuntu:latest AS image

# Arguments
ARG VERSION
ARG BUILD_DATE
ARG GIT_REF

WORKDIR /opt/source

# Labels
LABEL maintainer="mikaheim@gmail.com"
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.version=${VERSION}
LABEL org.label-schema.build-date=${BUILD_DATE}
LABEL org.label-schema.name="mikaheim/amiga-cc-toolchain"
LABEL org.label-schema.description="Amiga Cross-Compiling Toolchain"
LABEL org.label-schema.vcs-url="https://github.com/mikaheim/amiga-cc-toolchain"
LABEL org.label-schema.vcs-ref=${GIT_REF}
LABEL org.label-schema.docker.cmd="docker run --rm -v ~/:/opt/source mikaheim/amiga-cc-toolchain m68k-amigaos-gcc -mcrt=nix13 examples/hello-world/hello-world.c -o examples/hello-world/hello-world.exe"

# Needed libraries
RUN apt-get -y update && apt -y install lhasa libmpc-dev libgmp-dev libmpfr-dev ncurses-dev make libreadline-dev && apt -y autoclean

RUN mkdir /opt/amiga
COPY --from=build /opt/amiga /opt/amiga
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/amiga/bin
