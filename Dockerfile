ARG BASE_CONTAINER=jupyter/base-notebook:307ad2bb5fce
FROM $BASE_CONTAINER
# https://hub.docker.com/r/jupyter/base-notebook/tags

LABEL maintainer="James Brock <jamesbrock@gmail.com>"

# Extra arguments to `stack build`. Used to build --fast, see Makefile.
ARG STACK_ARGS=

USER root

# The global snapshot package database will be here in the STACK_ROOT.
ENV STACK_ROOT=/opt/stack
RUN mkdir -p $STACK_ROOT
RUN fix-permissions $STACK_ROOT

# Install Haskell Stack and its dependencies
RUN apt-get update && apt-get install -yq --no-install-recommends \
        python3-pip \
        git \
        libtinfo-dev \
        libzmq3-dev \
        libcairo2-dev \
        libpango1.0-dev \
        libmagic-dev \
        libblas-dev \
        liblapack-dev \
        libffi-dev \
        libgmp-dev \
        gnupg \
        netbase \
# for ihaskell-graphviz
        graphviz \
# for Stack download
        curl \
# Stack Debian/Ubuntu manual install dependencies
# https://docs.haskellstack.org/en/stable/install_and_upgrade/#linux-generic
        g++ \
        gcc \
        libc6-dev \
        libffi-dev \
        libgmp-dev \
        make \
        xz-utils \
        zlib1g-dev \
        git \
        gnupg \
        netbase && \
# Clean up apt
    rm -rf /var/lib/apt/lists/*

# Stack Linux (generic) Manual download
# https://docs.haskellstack.org/en/stable/install_and_upgrade/#linux-generic
#
# So that we can control Stack version, we do manual install instead of
# automatic install:
#
#    curl -sSL https://get.haskellstack.org/ | sh
#
ARG STACK_VERSION="2.1.3"
ARG STACK_BINDIST="stack-${STACK_VERSION}-linux-x86_64"
RUN    cd /tmp \
    && curl -sSL --output ${STACK_BINDIST}.tar.gz https://github.com/commercialhaskell/stack/releases/download/v${STACK_VERSION}/${STACK_BINDIST}.tar.gz \
    && tar zxf ${STACK_BINDIST}.tar.gz \
    && cp ${STACK_BINDIST}/stack /usr/bin/stack \
    && rm -rf ${STACK_BINDIST}.tar.gz ${STACK_BINDIST} \
    && stack --version

# Stack global non-project-specific config stack.config.yaml
# https://docs.haskellstack.org/en/stable/yaml_configuration/#non-project-specific-config
RUN mkdir -p /etc/stack
COPY stack.config.yaml /etc/stack/config.yaml
RUN fix-permissions /etc/stack

# Stack global project stack.stack.yaml
# https://docs.haskellstack.org/en/stable/yaml_configuration/#yaml-configuration
RUN mkdir -p $STACK_ROOT/global-project
COPY stack.stack.yaml $STACK_ROOT/global-project/stack.yaml
RUN    chown --recursive $NB_UID:users $STACK_ROOT/global-project \
    && fix-permissions $STACK_ROOT/global-project

# fix-permissions for /usr/local/share/jupyter so that we can install
# the IHaskell kernel there. Seems like the best place to install it, see
#      jupyter --paths
#      jupyter kernelspec list
RUN    mkdir -p /usr/local/share/jupyter \
    && fix-permissions /usr/local/share/jupyter \
    && mkdir -p /usr/local/share/jupyter/kernels \
    && fix-permissions /usr/local/share/jupyter/kernels

# Now make a bin directory for installing the ihaskell executable on
# the PATH. This /opt/bin is referenced by the stack non-project-specific
# config.
RUN    mkdir -p /opt/bin \
    && fix-permissions /opt/bin
ENV PATH ${PATH}:/opt/bin

# Switch back to jovyan user
USER $NB_UID

# Specify a git branch for IHaskell (can be branch or tag).
# The resolver for all stack builds will be chosen from
# the IHaskell/stack.yaml in this commit.
ARG IHASKELL_COMMIT=master

# Specify a git branch for hvega
ARG HVEGA_COMMIT=master

# Change this line to invalidate the Docker cache so that the IHaskell and
# hvega repos are forced to pull and rebuild when built on DockerHub.
# This is inelegant, but is there a better way? (IHASKELL_COMMIT=hash
# doesn't work.)
RUN echo "build on 2019-10-16"

# Install IHaskell
RUN    cd /opt \
    && git clone --depth 1 --branch $IHASKELL_COMMIT https://github.com/gibiansky/IHaskell \
    && git clone --depth 1 --branch $HVEGA_COMMIT https://github.com/DougBurke/hvega.git \
# Copy the Stack global project resolver from the IHaskell resolver.
    && grep 'resolver:' /opt/IHaskell/stack.yaml >> $STACK_ROOT/global-project/stack.yaml \
# Note that we are NOT in the /opt/IHaskell directory here, we are
# installing ihaskell via the /opt/stack/global-project/stack.yaml
    && stack setup \
    && stack build $STACK_ARGS ihaskell \
    && stack build $STACK_ARGS ghc-parser \
    && stack build $STACK_ARGS ipython-kernel \
# Install IHaskell.Display libraries
# https://github.com/gibiansky/IHaskell/tree/master/ihaskell-display
    && stack build $STACK_ARGS ihaskell-aeson \
    && stack build $STACK_ARGS ihaskell-blaze \
    && stack build $STACK_ARGS ihaskell-gnuplot \
    && stack build $STACK_ARGS ihaskell-juicypixels \
# Skip install of ihaskell-widgets, they don't work.
# See https://github.com/gibiansky/IHaskell/issues/870
#   && stack build $STACK_ARGS ihaskell-widgets \
    && stack build $STACK_ARGS ihaskell-graphviz \
    && stack build $STACK_ARGS hvega \
    && stack build $STACK_ARGS ihaskell-hvega \
    && fix-permissions /opt/IHaskell \
    && fix-permissions $STACK_ROOT \
    && fix-permissions /opt/hvega \
# Install the kernel at /usr/local/share/jupyter/kernels, which is
# in `jupyter --paths` data:
    && stack exec ihaskell -- install --stack --prefix=/usr/local \
# Install the ihaskell_labextension for JupyterLab syntax highlighting
    && npm install -g typescript \
    && cd IHaskell/ihaskell_labextension \
    && npm install \
    && npm run build \
    && jupyter labextension install . \
# Cleanup
    && npm cache clean --force \
    && rm -rf /home/$NB_USER/.cache/yarn \
# Don't clean IHaskell/.stack-work, 7GB, this causes issue #5
#   && rm -rf $(find /opt/IHaskell -type d -name .stack-work) \
# Don't clean /opt/hvega
# Clean ghc html docs, 259MB
    && rm -rf $(stack path --snapshot-doc-root)/* \
# Clean ihaskell_labextensions/node_nodemodules, 86MB
    && rm -rf /opt/IHaskell/ihaskell_labextensions/node_modules

# Install system-level ghc using the ghc which was installed by stack
# using the IHaskell resolver.
RUN mkdir -p /opt/ghc && ln -s `stack path --compiler-bin` /opt/ghc/bin
ENV PATH ${PATH}:/opt/ghc/bin

# Example IHaskell notebooks will be collected in this directory.
ARG EXAMPLES_PATH=/home/$NB_USER/ihaskell_examples

# Collect all the IHaskell example notebooks in EXAMPLES_PATH.
RUN    mkdir -p $EXAMPLES_PATH \
    && cd $EXAMPLES_PATH \
    && mkdir -p ihaskell \
    && cp --recursive /opt/IHaskell/notebooks/* ihaskell/ \
    && mkdir -p ihaskell-juicypixels \
    && cp /opt/IHaskell/ihaskell-display/ihaskell-juicypixels/*.ipynb ihaskell-juicypixels/ \
# Don't install these examples for these non-working libraries.
#   && mkdir -p ihaskell-charts \
#   && cp /opt/IHaskell/ihaskell-display/ihaskell-charts/*.ipynb ihaskell-charts/ \
#   && mkdir -p ihaskell-diagrams \
#   && cp /opt/IHaskell/ihaskell-display/ihaskell-diagrams/*.ipynb ihaskell-diagrams/ \
#   && mkdir -p ihaskell-widgets \
#   && cp --recursive /opt/IHaskell/ihaskell-display/ihaskell-widgets/Examples/* ihaskell-widgets/ \
    && mkdir -p ihaskell-hvega \
    && cp /opt/hvega/notebooks/*.ipynb ihaskell-hvega/ \
    && cp /opt/hvega/notebooks/*.tsv ihaskell-hvega/ \
    && fix-permissions $EXAMPLES_PATH

