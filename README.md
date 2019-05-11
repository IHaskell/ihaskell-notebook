# ihaskell-notebook

[![Build Status](https://travis-ci.org/jamesdbrock/ihaskell-notebook.svg?branch=master)](https://travis-ci.org/jamesdbrock/ihaskell-notebook)

A [Community Jupyter Docker Stacks](https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html#community-stacks) image. Provides the Jupyter [IHaskell](https://github.com/gibiansky/IHaskell) kernel in a Docker image which composes well with other Jupyter Docker Stacks. Pre-built images are published at [DockerHub crosscompass/ihaskell-notebook](https://hub.docker.com/r/crosscompass/ihaskell-notebook).


`docker run` it right now with this shell command, then open [http://localhost:8888?token=x](http://localhost:8888?token=x).

```bash
    docker run --rm -p 8888:8888 --env JUPYTER_ENABLE_LAB=yes --env JUPYTER_TOKEN=x --name ihaskell_notebook crosscompass/ihaskell-notebook:latest
```

This image includes:

* [__Haskell Stack__](https://docs.haskellstack.org/en/stable/README/) package manager, with [Glasgow Haskell Compiler](https://www.haskell.org/ghc/).
* [__IHaskell__](https://github.com/gibiansky/IHaskell) Jupyter kernel
* [__ihaskell_labextension__](https://github.com/gibiansky/IHaskell/tree/master/ihaskell_labextension) JupyterLab extension for Haskell syntax highlighting in notebooks
* Haskell libraries for instances of [IHaskell.Display](https://www.stackage.org/haddock/lts-12.26/ihaskell-0.9.1.0/IHaskell-Display.html)
  * __ihaskell-aeson__ for [Aeson](http://hackage.haskell.org/package/aeson) JSON display
  * __ihaskell-blaze__ for [Blaze](http://hackage.haskell.org/package/blaze-html) HTML display
  * __ihaskell-gnuplot__ for [gnuplot](http://www.gnuplot.info/) display
  * __ihaskell-juicypixels__ for [JuicyPixels](http://hackage.haskell.org/package/JuicyPixels) image display
  * [__DougBurke/ihaskell-hvega__](https://github.com/DougBurke/hvega) for [Vega/Vega-Lite rendering, natively supported by JupyterLab](https://jupyterlab.readthedocs.io/en/stable/user/file_formats.html#vega-lite)

To ensure that this image composes well with any authentication and storage configuration 
(for example [SystemUserSpawner](https://github.com/jupyterhub/dockerspawner#systemuserspawner)) 
or notebook directory structure, we try to avoid installing any binaries in the Docker image in `/home/jovyan`. 

This image is made with JupyterLab in mind, but it works well for classic notebooks.

Example notebooks are collected together in the container at `/home/jovyan/ihaskell_examples`.

## `IHaskell.Display`

Some libraries for instances of [`IHaskell.Display`](https://www.stackage.org/haddock/lts-12.26/ihaskell-0.9.1.0/IHaskell-Display.html) are pre-installed in the JupyterLab container.

The installed libraries mostly come from  mostly from [`IHaskell/ihaskell-display`](https://github.com/gibiansky/IHaskell/tree/master/ihaskell-display), and are installed if they appeared to be working at the time the JupyterLab Docker image was built. You can try to install the other `IHaskell/ihaskell-display` libraries, and they will be built from the `/opt/IHaskell` source in the container.

```bash
stack install ihaskell-diagrams
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
```

## Stack *global project*

The `ihaskell` executable, the `ihaskell` library, the `ghc-parser` library,
and the `ipython-kernel` library are built and installed at the level
of the [Stack *global project*](https://docs.haskellstack.org/en/stable/yaml_configuration/#yaml-configuration) in `/opt/stack/global-project`.

This means that the `ihaskell` environment is available for all users anywhere for any `PWD` inside the
Docker container. (The `PWD` of a notebook is the always the directory in which the notebook is saved.)

The Stack *global project* `resolver`
is determined by the IHaskell project `resolver`, and all included Haskell
libraries are built using that stack `resolver`.

You can install libraries with `stack install`. For example, if you encounter a notebook error like:

```
<interactive>:1:1: error:
   Could not find module ‘Deque’
   Use -v to see a list of the files searched for.
```

Then you can install the missing package from the terminal in your container:

```bash
stack install deque
```

Or, in a notebook, you can use the [GHCi-style shell commands](https://github.com/gibiansky/IHaskell/wiki#shelling-out):

```
:!stack install deque
```

And then <kbd>↻</kbd> restart your IHaskell kernel.

You can use this technique to create a list of package dependencies at the top of a notebook:

```
:!stack install deque
import Deque
Deque.head $ fromList [1,2,3]
```

~~~
Just 1
~~~

Sadly, this doesn't work quite as frictionlessly as we would like. The first time you run the notebook, the packages will be installed, but then the kernel not load them. You must <kbd>↻</kbd> restart the kernel to load the newly-installed packages.

## Local Stack Projects

You can run a IHaskell `.ipynb` in a stack project `PWD` which has a `stack.yaml`.

You should copy the the contents of the container's Stack *global project* `/opt/stack/global-project/stack.yaml` into the local project's `stack.yaml`. That will give you the same `resolver` as the *global project* IHaskell installation, and it will also allow you to install libraries from `IHaskell` and `IHaskell/ihaskell-display`.

After your `stack.yaml` is configured, run `:! stack build` and then <kbd>↻</kbd> restart your IHaskell kernel.

You can try to run a IHaskell `.ipynb` in a `PWD` with a `stack.yaml` that has a `resolver` different from the `resolver` in `/opt/stack/global-project/stack.yaml`, but that is Undefined Behavior, as we say in C++.

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

This Docker image was made for use by, and with the support of, [Cross Compass](https://www.cross-compass.com/) in Tokyo.
