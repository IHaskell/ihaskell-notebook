# ihaskell-notebook

A community maintained
[Jupyter Docker Stacks](https://github.com/jupyter/docker-stacks)
image.
Provides the Jupyter [IHaskell](https://github.com/gibiansky/IHaskell) kernel
in a Docker image which composes well with other Jupyter Docker Stacks.


`docker run` it right now with this shell command, then open <http://localhost:8888?token=x>.

~~~bash
    docker run --rm -p 8888:8888 --env JUPYTER_ENABLE_LAB=yes --env JUPYTER_TOKEN=x --name ihaskell_notebook jamesbrock/ihaskell-notebook:latest
~~~

This image includes:

* [__Haskell Stack__](https://docs.haskellstack.org/en/stable/README/) package manager, with [Glasgow Haskell Compiler](https://www.haskell.org/ghc/).
* [__IHaskell__](https://github.com/gibiansky/IHaskell) Jupyter kernel
* [__ihaskell_labextension__](https://github.com/gibiansky/IHaskell/tree/master/ihaskell_labextension) JupyterLab extension for Haskell syntax highlighting in notebooks
* Haskell libraries for instances of [IHaskell.Display](https://www.stackage.org/haddock/lts-12.26/ihaskell-0.9.1.0/IHaskell-Display.html)
  * __IHaskell/ihaskell-display/ihaskell-aeson__ for [Aeson](http://hackage.haskell.org/package/aeson) JSON.
  * __IHaskell/ihaskell-display/ihaskell-blaze__ for [Blaze](http://hackage.haskell.org/package/blaze-html) HTML.
  * __IHaskell/ihaskell-display/ihaskell-gnuplot__ For [gnuplot](http://www.gnuplot.info/).
  * __IHaskell/ihaskell-display/ihaskell-juicypixels__ For [JuicyPixels](http://hackage.haskell.org/package/JuicyPixels) image serialization.
  * [__IHaskell/ihaskell-display/ihaskell-widgets__](https://github.com/gibiansky/IHaskell/tree/master/ihaskell-display/ihaskell-widgets) For [ipython widgets](https://github.com/ipython/ipywidgets).
  * [__DougBurke/ihaskell-hvega__](https://github.com/DougBurke/hvega) for [Vega/Vega-Lite rendering, natively supported by JupyterLab](https://jupyterlab.readthedocs.io/en/stable/user/file_formats.html#vega-lite).

With this Docker image, we try to avoid installing anything
locally in `/home/jovyan`. Instead, all Haskell is installed at the level
of the Stack default global project. The Stack default global project `resolver`
is determined by the IHaskell project `resolver`, and all included Haskell
libraries are built using that stack `resolver`.

This image is made with JupyterLab in mind, but it works well for classic notebooks.

Example notebooks are collected together in the container at `/home/jovyan/ihaskell_examples`.

## Stack default global project `/opt/stack/global-project/stack.yaml`

The `ihaskell` executable, the `ihaskell` library, the `ghc-parser` library,
and the `ipython-kernel` library are built and installed at the level
of the [Stack default global project](https://docs.haskellstack.org/en/stable/yaml_configuration/#yaml-configuration). This means that the `ihaskell`
environment is available for all users anywhere for any `PWD` inside the
container. (The `PWD` of a notebook is the always the directory in which the notebook is saved.)

You can install libraries with `stack install`. For example, if you encounter a notebook error like:

> ~~~
> <interactive>:1:1: error:
>    Could not find module ‘Deque’
>    Use -v to see a list of the files searched for.
> ~~~

Then you can install the missing package from the terminal in your container:

~~~bash
stack install deque
~~~

Or, in a notebook, you can use the GHCi-style shell commands:

> ~~~
> :!stack install deque
> ~~~

And then ↻ restart your Jupyter Haskell kernel.

You can use this technique to create a list of package dependencies at the top of a notebook:

> ~~~
> :!stack install deque
> import Deque
> Deque.head $ fromList [1,2,3]
> ~~~

> ~~~
> Just 1
> ~~~

Sadly, this doesn't work quite as frictionlessly as we would like. The first time you run the notebook, the packages will be installed, but then the kernel will fail to find them. You must ↻ restart the kernel and then run the notebook again, and it will succeed.

## [IHaskell.Display](https://www.stackage.org/haddock/lts-12.26/ihaskell-0.9.1.0/IHaskell-Display.html)

Some libraries in [`IHaskell/ihaskell-display`](https://github.com/gibiansky/IHaskell/tree/master/ihaskell-display)
are pre-installed in the JupyterLab container, if they appeared to be working at the time the JupyterLab Docker image was built. You can try to install the other `IHaskell/ihaskell-display` libraries, and they will be built from the `/opt/IHaskell` source in the container.

~~~bash
stack install ihaskell-diagrams
~~~

See the Stack global default project `/opt/stack/global-project/stack.yaml` for information about the `/opt/IHaskell` source in the container.

You can see which libraries are installed by running `ghc-pkg`:

~~~bash
stack exec ghc-pkg -- list | grep ihaskell
    ihaskell-0.9.1.0
    ihaskell-aeson-0.3.0.1
    ihaskell-blaze-0.3.0.1
    ihaskell-gnuplot-0.1.0.1
    ihaskell-hvega-0.2.0.0
    ihaskell-juicypixels-1.1.0.1
    ihaskell-widgets-0.2.3.2
~~~

## Local Stack Projects

You can run a IHaskell `.ipynb` in a stack project `PWD` which has a `stack.yaml`.

You should
copy the the contents of the container's Stack global default project `/opt/stack/global-project/stack.yaml` into the local project's `stack.yaml`. That will give you the same `resolver` as the global IHaskell installation, and it will also allow you to install libraries from `IHaskell` and `IHaskell/ihaskell-display`.

After your `stack.yaml` is configured, run `:! stack build` and then ↻ restart your Jupyter Haskell kernel.

You can try to run a IHaskell `.ipynb` in a `PWD` with a `stack.yaml` that has a `resolver` different from the `resolver` in `/opt/stack/global-project/stack.yaml`, but that is Undefined Behavior, as we say in C++.


## References and Links

[IHaskell on Hackage](http://hackage.haskell.org/package/ihaskell)

[IHaskell on Stackage](https://www.stackage.org/package/ihaskell/snapshots)

[IHaskell Wiki with Exemplary IHaskell Notebooks](https://github.com/gibiansky/IHaskell/wiki)

[When Is Haskell More Useful Than R Or Python In Data Science?](https://www.quora.com/What-are-some-use-cases-for-which-it-would-be-beneficial-to-use-Haskell-rather-than-R-or-Python-in-data-science)

[datahaskell.org](http://www.datahaskell.org/)

This Docker image was made for use by, and with the support of, [Cross Compass](https://www.cross-compass.com/) in Tokyo.
