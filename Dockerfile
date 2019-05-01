ARG BASE_CONTAINER=jupyter/minimal-notebook
FROM $BASE_CONTAINER

LABEL maintainer="James Brock <jamesbrock@gmail.com>"

# Examples IHaskell notebooks will be collected in this directory.
ARG EXAMPLES_PATH=/home/$NB_USER/ihaskell_examples

# Specify a git commit for IHaskell (can be branch, tag, or hash).
# The resolver for all stack builds will be chosen from
# the IHaskell/stack.yaml in this commit.
ARG IHASKELL_COMMIT=master

# Specify a git commit for hvega
ARG HVEGA_COMMIT=master

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
        # for ihaskell-graphviz \
        graphviz \
        # for stack installation \
        curl \
        && \
    rm -rf /var/lib/apt/lists/* && \
    curl -sSL https://get.haskellstack.org/ | sh && \
    fix-permissions $STACK_ROOT

# Stack global non-project-specific config stack.config.yaml
# https://docs.haskellstack.org/en/stable/yaml_configuration/#non-project-specific-config
RUN mkdir -p /etc/stack
COPY stack.config.yaml /etc/stack/config.yaml
RUN fix-permissions /etc/stack

# Stack global project stack.stack.yaml
# https://docs.haskellstack.org/en/stable/yaml_configuration/#yaml-configuration
RUN mkdir -p $STACK_ROOT/global-project
COPY stack.stack.yaml $STACK_ROOT/global-project/stack.yaml
RUN fix-permissions $STACK_ROOT/global-project

# fix-permissions for /usr/local/share/jupyter so that we can install
# the IHaskell kernel there. Seems like the best place to install it, see
#      jupyter --paths
#      jupyter kernelspec list
RUN mkdir -p /usr/local/share/jupyter &&  \
    fix-permissions /usr/local/share/jupyter && \
    mkdir -p /usr/local/share/jupyter/kernels &&  \
    fix-permissions /usr/local/share/jupyter/kernels

# Now make a bin directory for installing the ihaskell executable on
# the PATH. This /opt/bin is referenced by the stack non-project-specific
# config.
RUN mkdir -p /opt/bin && \
    fix-permissions /opt/bin
ENV PATH ${PATH}:/opt/bin

# Switch back to jovyan user
USER $NB_UID

# Install IHaskell
RUN \
    cd /opt && \
    git clone --depth 1 --branch $IHASKELL_COMMIT https://github.com/gibiansky/IHaskell && \
    git clone --depth 1 --branch $HVEGA_COMMIT https://github.com/DougBurke/hvega.git && \
    # Copy the Stack global project resolver from the IHaskell resolver. \
    grep 'resolver:' /opt/IHaskell/stack.yaml >> $STACK_ROOT/global-project/stack.yaml && \
    # Note that we are NOT in the /opt/IHaskell directory here, we are installing ihaskell via the /opt/stack/global-project/stack.yaml \
    stack install ihaskell && \
    stack build ghc-parser && \
    stack build ipython-kernel && \
    # Install IHaskell.Display libraries https://github.com/gibiansky/IHaskell/tree/master/ihaskell-display \
    stack build ihaskell-aeson && \
    stack build ihaskell-blaze && \
    stack build ihaskell-gnuplot && \
    stack build ihaskell-juicypixels && \
    stack build ihaskell-widgets && \
    stack build ihaskell-graphviz && \
    stack build hvega && \
    stack build ihaskell-hvega && \
    fix-permissions /opt/IHaskell && \
    fix-permissions $STACK_ROOT && \
    fix-permissions /opt/hvega && \
    # Install the kernel at /usr/local/share/jupyter/kernels, which is in `jupyter --paths` data: \
    ihaskell install --stack --prefix=/usr/local && \
    # Install the ihaskell_labextension for JupyterLab syntax highlighting \
    npm install -g typescript && \
    cd IHaskell/ihaskell_labextension && \
    npm install && \
    npm run build && \
    jupyter labextension install . && \
    # Cleanup \
    npm cache clean --force && \
    rm -rf /home/$NB_USER/.cache/yarn && \
    # IHaskell/.stack-work, 120MB \
    # We can't clean /opt/IHaskell/.stack-work because it's referenced by the global project. \
    # Clean ghc html docs, 259MB \
    rm -rf $(stack path --snapshot-doc-root)/* && \
    # Clean ihaskell_labextensions/node_nodemodules, 86MB \
    rm -rf /opt/IHaskell/ihaskell_labextensions/node_modules

# Collect all the IHaskell example notebooks in EXAMPLES_PATH.
RUN \
    mkdir -p $EXAMPLES_PATH && \
    cd $EXAMPLES_PATH && \
    mkdir -p ihaskell && \
    cp --recursive /opt/IHaskell/notebooks/* ihaskell/ && \
    mkdir -p ihaskell-juicypixels && \
    cp /opt/IHaskell/ihaskell-display/ihaskell-juicypixels/*.ipynb ihaskell-juicypixels/ && \
#    mkdir -p ihaskell-charts && \
#    cp /opt/IHaskell/ihaskell-display/ihaskell-charts/*.ipynb ihaskell-charts/ && \
#    mkdir -p ihaskell-diagrams && \
#    cp /opt/IHaskell/ihaskell-display/ihaskell-diagrams/*.ipynb ihaskell-diagrams/ && \
    mkdir -p ihaskell-widgets && \
    cp --recursive /opt/IHaskell/ihaskell-display/ihaskell-widgets/Examples/* ihaskell-widgets/ && \
    mkdir -p ihaskell-hvega && \
    cp /opt/hvega/notebooks/*.ipynb ihaskell-hvega/ && \
    cp /opt/hvega/notebooks/*.tsv ihaskell-hvega/ && \
    fix-permissions $EXAMPLES_PATH

