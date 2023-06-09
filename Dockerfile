# Build stage
FROM ubuntu:latest AS build

WORKDIR /tmp
RUN apt-get -y update && apt -y install make wget git gcc g++ lhasa libgmp-dev \
    libmpfr-dev libmpc-dev flex bison gettext texinfo ncurses-dev autoconf \
    rsync libreadline-dev
RUN git clone https://github.com/bebbo/amiga-gcc
WORKDIR /tmp/amiga-gcc
RUN make all
RUN wget https://www.dropbox.com/s/5kougfenyw9qa4h/ndk13.lha?dl=1 -O ndk13.lha
RUN echo $(pwd) && echo $(ls -al)
RUN lha xw=/tmp ndk13.lha
RUN mv /tmp/NDK_1.3/Includes1.3/include.h /opt/amiga/m68k-kick13/ndk-include
RUN chmod a+r -R /opt/amiga/m68k-kick13/ndk-include
# Final image stage
FROM ubuntu:latest AS image

# Arguments
ARG VERSION
ARG BUILD_DATE
ARG GIT_REF

WORKDIR /opt/source

# Labels
LABEL org.opencontainers.image.authors="M. Ikäheimo <mikaheim@gmail.com>"
LABEL org.opencontainers.image.version=${VERSION}
LABEL org.opencontainers.image.created=${BUILD_DATE}
LABEL org.opencontainers.image.title="mikaheim/amiga-cc-toolchain"
LABEL org.opencontainers.image.description="Amiga Cross-Compiling Toolchain"
LABEL org.opencontainers.image.source="https://github.com/mikaheim/amiga-cc-toolchain"
LABEL org.opencontainers.image.revision=${GIT_REF}
LABEL org.opencontainers.image.documentation="docker run --rm -v ~/:/opt/source mikaheim/amiga-cc-toolchain m68k-amigaos-gcc -mcrt=nix13 examples/hello-world/hello-world.c -o examples/hello-world/hello-world.exe"

# Needed libraries
RUN apt-get -y update && apt -y install lhasa libmpc-dev libgmp-dev libmpfr-dev ncurses-dev make libreadline-dev && apt -y autoclean

RUN mkdir /opt/amiga
COPY --from=build /opt/amiga /opt/amiga
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/amiga/bin
