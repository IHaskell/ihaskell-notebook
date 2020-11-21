# ihaskell-notebook

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/jamesdbrock/learn-you-a-haskell-notebook/master?urlpath=lab/tree/ihaskell_examples/ihaskell/IHaskell.ipynb)

A [Community Jupyter Docker Stacks](https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html#community-stacks) image. Provides the Jupyter [IHaskell](https://github.com/gibiansky/IHaskell) kernel in a Docker image which composes well with other Jupyter Docker Stacks. Images are published at [DockerHub crosscompass/ihaskell-notebook](https://hub.docker.com/r/crosscompass/ihaskell-notebook).


`docker run` the latest image right now with the following shell command, then open [http://localhost:8888](http://localhost:8888) to try out the Jupyter notebook. Your current working directory on your host computer will be mounted at __Home / pwd__ in JupyterLab.

```bash
docker run --rm -p 8888:8888 -v $PWD:/home/jovyan/pwd --name ihaskell_notebook crosscompass/ihaskell-notebook:latest jupyter lab --LabApp.token=''
```

Or with `podman`:

```bash
podman run --privileged --userns=keep-id --rm -p 8888:8888 -v $PWD:/home/jovyan/pwd --name ihaskell_notebook crosscompass/ihaskell-notebook:latest jupyter lab --LabApp.token=''
```


This image includes:

* [__JupyterLab 2__](https://jupyterlab.readthedocs.io/en/stable/)
* [__IHaskell__](https://github.com/gibiansky/IHaskell) Jupyter kernel
* Haskell libraries for instances of [IHaskell.Display](https://www.stackage.org/haddock/lts-12.26/ihaskell-0.9.1.0/IHaskell-Display.html)
  * __ihaskell-aeson__ for [Aeson](http://hackage.haskell.org/package/aeson) JSON display
  * __ihaskell-blaze__ for [Blaze](http://hackage.haskell.org/package/blaze-html) HTML display
  * __ihaskell-gnuplot__ for [gnuplot](http://www.gnuplot.info/) display
  * __ihaskell-juicypixels__ for [JuicyPixels](http://hackage.haskell.org/package/JuicyPixels) image display
  * __ihaskell-graphviz__ for [Graphviz](https://www.graphviz.org/) display
  * __ihaskell-diagrams__ for [diagrams](https://archives.haskell.org/projects.haskell.org/diagrams/) display
  * __ihaskell-charts__ for [Chart](https://github.com/timbod7/haskell-chart/wiki) display
  * __ihaskell-hatex__ for [HaTeX](http://daniel-diaz.github.io/projects/hatex/hatex-guide.html) LaTeX display
  * [__DougBurke/ihaskell-hvega__](https://github.com/DougBurke/hvega) for [Vega/Vega-Lite rendering, natively supported by JupyterLab](https://jupyterlab.readthedocs.io/en/stable/user/file_formats.html#vega-lite)
* [__Haskell Stack__](https://docs.haskellstack.org/en/stable/README/) package manager, with [Glasgow Haskell Compiler](https://www.haskell.org/ghc/).

To ensure that this image composes well with any authentication and storage configuration
(for example [SystemUserSpawner](https://github.com/jupyterhub/dockerspawner#systemuserspawner))
or notebook directory structure, we try to avoid installing anything in the Docker image in `/home/jovyan`.

This image is made with JupyterLab in mind, but it works well for classic notebooks.

Example notebooks are collected together in the container at `/home/jovyan/ihaskell_examples`.

## `IHaskell.Display`

Some libraries for instances of [`IHaskell.Display`](https://www.stackage.org/haddock/lts-12.26/ihaskell-0.9.1.0/IHaskell-Display.html) are pre-installed in the JupyterLab container.

The installed libraries mostly come from  mostly from [`IHaskell/ihaskell-display`](https://github.com/gibiansky/IHaskell/tree/master/ihaskell-display), and are installed if they appeared to be working at the time the JupyterLab Docker image was built. You can try to install the other `IHaskell/ihaskell-display` libraries, and they will be built from the `/opt/IHaskell` source in the container.

```bash
stack install ihaskell-magic
```

See the Stack *global project* `/opt/stack/global-project/stack.yaml` for information about the `/opt/IHaskell` source in the container.

You can see which libraries are installed by running `ghc-pkg`:

```bash
stack exec ghc-pkg -- list | grep ihaskell
    ihaskell-0.9.1.0
    ihaskell-aeson-0.3.0.1
    ihaskell-blaze-0.3.0.1
    ihaskell-gnuplot-0.1.0.1
    ihaskell-hvega-0.2.0.0
    ihaskell-juicypixels-1.1.0.1
    ...
```

## Stack *global project*

The `ihaskell` executable, the `ihaskell` library, the `ghc-parser` library,
and the `ipython-kernel` library are built and installed at the level
of the [Stack *global project*](https://docs.haskellstack.org/en/stable/yaml_configuration/#yaml-configuration) in `/opt/stack/global-project`.
This design choice was discussed in [IHaskell issue #715](https://github.com/gibiansky/IHaskell/issues/715#issuecomment-338580095).

This means that the `ihaskell` environment is available for all users in any directory mounted in the
Docker container, so you can __save and run `.ipynb` notebook files in any directory__, which is one of the main advantage of this IHaskell Docker image.
The present working directory (`PWD`) of a Jupyter notebook is the always the directory in which the notebook
is saved.

The Stack *global project* `resolver`
is determined by the IHaskell project `resolver`, and all included Haskell
libraries are built using that Stack `resolver`.

You can install libraries with `stack install`. For example, if you encounter a notebook error like:

```
<interactive>:1:1: error:
   Could not find module ‘Numeric.LinearAlgebra’
   Use -v to see a list of the files searched for.
```

Then you can install the missing package from the terminal in your container:

```bash
stack install hmatrix
```

Or, in a notebook, you can use the [GHCi-style shell commands](https://github.com/gibiansky/IHaskell/wiki#shelling-out):

```
:!stack install hmatrix
```

And then <kbd>⭮</kbd> restart your IHaskell kernel.

You can use this technique to create a list of package dependencies at the top of a notebook:

```
:!stack install hmatrix
import Numeric.LinearAlgebra
ident 3
```

~~~
(3><3)
 [ 1.0, 0.0, 0.0
 , 0.0, 1.0, 0.0
 , 0.0, 0.0, 1.0 ]
~~~

Sadly, this doesn't work quite as frictionlessly as we would like. The first time you run the notebook, the packages will be installed, but then the kernel not load them. You must <kbd>⭮</kbd> restart the kernel to load the newly-installed packages.

## Local Stack Projects

You can run a IHaskell `.ipynb` in a Stack project `PWD` which has a `stack.yaml`.

You should copy the entire contents of the container's Stack *global project* `/opt/stack/global-project/stack.yaml` into the local project's `stack.yaml` as a starting point. That will give you the same `resolver` as the *global project* IHaskell installation, and it will also allow you to install libraries from `IHaskell` and `IHaskell/ihaskell-display`. You can add `extra-deps` to your local project `stack.yaml` for packages which are not in the Stack `resolver`.

You probably shouldn't run a IHaskell `.ipynb` in a `PWD` with a `stack.yaml` that has a `resolver` different from the `resolver` in `/opt/stack/global-project/stack.yaml`.

After your `stack.yaml` is configured, run `:! stack build` and then <kbd>⭮</kbd> restart your IHaskell kernel.

## System GHC

The GHC version specified by the IHaskell Stack `resolver` is also installed
in the container at the system level, that is, on the executable `PATH`.

## Composition with Docker Stacks

Rebase the IHaskell `Dockerfile` on top of another Jupyter Docker Stack image, for example the `scipy-notebook`:

```
docker build --build-arg BASE_CONTAINER=jupyter/scipy-notebook --rm --force-rm -t ihaskell_scipy_notebook:latest .
```


## References, Links, Credits

[IHaskell on Hackage](http://hackage.haskell.org/package/ihaskell)

[IHaskell on Stackage](https://www.stackage.org/package/ihaskell/snapshots)

[IHaskell Wiki with Exemplary IHaskell Notebooks](https://github.com/gibiansky/IHaskell/wiki)

[When Is Haskell More Useful Than R Or Python In Data Science?](https://www.quora.com/What-are-some-use-cases-for-which-it-would-be-beneficial-to-use-Haskell-rather-than-R-or-Python-in-data-science) by [Tikhon Jelvis](https://github.com/TikhonJelvis)

[datahaskell.org](http://www.datahaskell.org/)

This Docker image was made at [Cross Compass](https://www.cross-compass.com/) in Tokyo.
