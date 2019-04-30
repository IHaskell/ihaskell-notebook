ARG BASE_CONTAINER=jupyter/minimal-notebook
FROM $BASE_CONTAINER

LABEL maintainer="James Brock <jamesbrock@gmail.com>"

# Examples IHaskell notebooks will be collected in this directory.
ARG EXAMPLES_PATH=/home/$NB_USER/ihaskell_examples

USER root

# The global snapshot package database will be here in the STACK_ROOT.
ENV STACK_ROOT=/opt/stack
RUN mkdir -p /opt/stack
RUN chmod 770 /opt/stack

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
        netbase \
        curl \
        && \
    rm -rf /var/lib/apt/lists/* && \
    curl -sSL https://get.haskellstack.org/ | sh && \
    fix-permissions $STACK_ROOT

# Stack global non-project-specific config stack.config.yaml
# https://docs.haskellstack.org/en/stable/yaml_configuration/#non-project-specific-config
RUN mkdir -p /etc/stack
COPY stack.config.yaml /etc/stack/config.yaml
RUN chmod 660 /etc/stack/config.yaml

# Stack global default project stack.stack.yaml
# https://docs.haskellstack.org/en/stable/yaml_configuration/#yaml-configuration
RUN mkdir -p /opt/stack/global-project
RUN chmod 770 /opt/stack/global-project
COPY stack.stack.yaml /opt/stack/global-project/stack.yaml
RUN chmod 660 /opt/stack/global-project/stack.yaml

# fix-permissions for /usr/local/share/jupyter so that we can install
# the IHaskell kernel there. Seems like the best place to install it, see
#      jupyter --paths
#      jupyter kernelspec list
RUN mkdir -p /usr/local/share/jupyter &&  \
    chown $NB_USER:$NB_GID /usr/local/share/jupyter && \
    fix-permissions /usr/local/share/jupyter && \
    mkdir -p /usr/local/share/jupyter/kernels &&  \
    chown $NB_USER:$NB_GID /usr/local/share/jupyter/kernels && \
    fix-permissions /usr/local/share/jupyter/kernels

# Now make a bin directory for installing the ihaskell executable on
# the PATH. This /opt/bin is referenced by the stack non-project-specific
# config.
RUN mkdir -p /opt/bin && \
    chown $NB_USER:$NB_GID /opt/bin && \
    fix-permissions /opt/bin
ENV PATH ${PATH}:/opt/bin

# Switch back to jovyan user
USER $NB_UID

# Install IHaskell
RUN \
    cd /opt && \
    # TODO Should we pin a specific IHaskell commit? \
    git clone https://github.com/gibiansky/IHaskell && \
    # TODO Should we pin a specific hvega commit? \
    git clone https://github.com/DougBurke/hvega.git && \
    # Copy the Stack global default project resolver from the IHaskell resolver. \
    grep 'resolver:' /opt/IHaskell/stack.yaml >> /opt/stack/global-project/stack.yaml && \
    # Note that we are NOT in the /opt/IHaskell directory here, we are installing ihaskell via the /opt/stack/global-project/stack.yaml \
    stack install ihaskell && \
    stack install ghc-parser && \
    stack install ipython-kernel && \
    # Install IHaskell.Display libraries https://github.com/gibiansky/IHaskell/tree/master/ihaskell-display \
    stack install ihaskell-aeson && \
    stack install ihaskell-blaze && \
    stack install ihaskell-gnuplot && \
    stack install ihaskell-juicypixels && \
    stack install ihaskell-widgets && \
    stack build hvega && \
    stack build ihaskell-hvega && \
    fix-permissions /opt/IHaskell && \
    fix-permissions /opt/stack && \
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
    # We can't clean /opt/IHaskell/.stack-work because it's referenced by the global default project. \
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

