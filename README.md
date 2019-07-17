# ihaskell-notebook

[![Build Status](https://travis-ci.org/jamesdbrock/ihaskell-notebook.svg?branch=master)](https://travis-ci.org/jamesdbrock/ihaskell-notebook)
[![launch Learn You a Haskell for Great Good!](https://img.shields.io/badge/launch-Learn%20You%20A%20Haskell%20For%20Great%20Good!-579ACA.svg?logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAFkAAABZCAMAAABi1XidAAAB8lBMVEX///9XmsrmZYH1olJXmsr1olJXmsrmZYH1olJXmsr1olJXmsrmZYH1olL1olJXmsr1olJXmsrmZYH1olL1olJXmsrmZYH1olJXmsr1olL1olJXmsrmZYH1olL1olJXmsrmZYH1olL1olL0nFf1olJXmsrmZYH1olJXmsq8dZb1olJXmsrmZYH1olJXmspXmspXmsr1olL1olJXmsrmZYH1olJXmsr1olL1olJXmsrmZYH1olL1olLeaIVXmsrmZYH1olL1olL1olJXmsrmZYH1olLna31Xmsr1olJXmsr1olJXmsrmZYH1olLqoVr1olJXmsr1olJXmsrmZYH1olL1olKkfaPobXvviGabgadXmsqThKuofKHmZ4Dobnr1olJXmsr1olJXmspXmsr1olJXmsrfZ4TuhWn1olL1olJXmsqBi7X1olJXmspZmslbmMhbmsdemsVfl8ZgmsNim8Jpk8F0m7R4m7F5nLB6jbh7jbiDirOEibOGnKaMhq+PnaCVg6qWg6qegKaff6WhnpKofKGtnomxeZy3noG6dZi+n3vCcpPDcpPGn3bLb4/Mb47UbIrVa4rYoGjdaIbeaIXhoWHmZYHobXvpcHjqdHXreHLroVrsfG/uhGnuh2bwj2Hxk17yl1vzmljzm1j0nlX1olL3AJXWAAAAbXRSTlMAEBAQHx8gICAuLjAwMDw9PUBAQEpQUFBXV1hgYGBkcHBwcXl8gICAgoiIkJCQlJicnJ2goKCmqK+wsLC4usDAwMjP0NDQ1NbW3Nzg4ODi5+3v8PDw8/T09PX29vb39/f5+fr7+/z8/Pz9/v7+zczCxgAABC5JREFUeAHN1ul3k0UUBvCb1CTVpmpaitAGSLSpSuKCLWpbTKNJFGlcSMAFF63iUmRccNG6gLbuxkXU66JAUef/9LSpmXnyLr3T5AO/rzl5zj137p136BISy44fKJXuGN/d19PUfYeO67Znqtf2KH33Id1psXoFdW30sPZ1sMvs2D060AHqws4FHeJojLZqnw53cmfvg+XR8mC0OEjuxrXEkX5ydeVJLVIlV0e10PXk5k7dYeHu7Cj1j+49uKg7uLU61tGLw1lq27ugQYlclHC4bgv7VQ+TAyj5Zc/UjsPvs1sd5cWryWObtvWT2EPa4rtnWW3JkpjggEpbOsPr7F7EyNewtpBIslA7p43HCsnwooXTEc3UmPmCNn5lrqTJxy6nRmcavGZVt/3Da2pD5NHvsOHJCrdc1G2r3DITpU7yic7w/7Rxnjc0kt5GC4djiv2Sz3Fb2iEZg41/ddsFDoyuYrIkmFehz0HR2thPgQqMyQYb2OtB0WxsZ3BeG3+wpRb1vzl2UYBog8FfGhttFKjtAclnZYrRo9ryG9uG/FZQU4AEg8ZE9LjGMzTmqKXPLnlWVnIlQQTvxJf8ip7VgjZjyVPrjw1te5otM7RmP7xm+sK2Gv9I8Gi++BRbEkR9EBw8zRUcKxwp73xkaLiqQb+kGduJTNHG72zcW9LoJgqQxpP3/Tj//c3yB0tqzaml05/+orHLksVO+95kX7/7qgJvnjlrfr2Ggsyx0eoy9uPzN5SPd86aXggOsEKW2Prz7du3VID3/tzs/sSRs2w7ovVHKtjrX2pd7ZMlTxAYfBAL9jiDwfLkq55Tm7ifhMlTGPyCAs7RFRhn47JnlcB9RM5T97ASuZXIcVNuUDIndpDbdsfrqsOppeXl5Y+XVKdjFCTh+zGaVuj0d9zy05PPK3QzBamxdwtTCrzyg/2Rvf2EstUjordGwa/kx9mSJLr8mLLtCW8HHGJc2R5hS219IiF6PnTusOqcMl57gm0Z8kanKMAQg0qSyuZfn7zItsbGyO9QlnxY0eCuD1XL2ys/MsrQhltE7Ug0uFOzufJFE2PxBo/YAx8XPPdDwWN0MrDRYIZF0mSMKCNHgaIVFoBbNoLJ7tEQDKxGF0kcLQimojCZopv0OkNOyWCCg9XMVAi7ARJzQdM2QUh0gmBozjc3Skg6dSBRqDGYSUOu66Zg+I2fNZs/M3/f/Grl/XnyF1Gw3VKCez0PN5IUfFLqvgUN4C0qNqYs5YhPL+aVZYDE4IpUk57oSFnJm4FyCqqOE0jhY2SMyLFoo56zyo6becOS5UVDdj7Vih0zp+tcMhwRpBeLyqtIjlJKAIZSbI8SGSF3k0pA3mR5tHuwPFoa7N7reoq2bqCsAk1HqCu5uvI1n6JuRXI+S1Mco54YmYTwcn6Aeic+kssXi8XpXC4V3t7/ADuTNKaQJdScAAAAAElFTkSuQmCC)](https://mybinder.org/v2/gh/jamesdbrock/learn-you-a-haskell-notebook/master?urlpath=lab/tree/learn_you_a_haskell/00-preface.ipynb)

A [Community Jupyter Docker Stacks](https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html#community-stacks) image. Provides the Jupyter [IHaskell](https://github.com/gibiansky/IHaskell) kernel in a Docker image which composes well with other Jupyter Docker Stacks. Images are published at [DockerHub crosscompass/ihaskell-notebook](https://hub.docker.com/r/crosscompass/ihaskell-notebook).


`docker run` the latest image right now with the following shell command, then open [http://localhost:8888?token=x](http://localhost:8888?token=x) to try out the Jupyter notebook. Your current working directory on your host computer will be mounted at __Home / pwd__ in JupyterLab.

```bash
    docker run --rm \
      -p 8888:8888 \
      -v $PWD:/home/jovyan/pwd \
      --env JUPYTER_ENABLE_LAB=yes \
      --env JUPYTER_TOKEN=x \
      --name ihaskell_notebook \
      crosscompass/ihaskell-notebook:latest
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
libraries are built using that Stack `resolver`.

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

You can run a IHaskell `.ipynb` in a Stack project `PWD` which has a `stack.yaml`.

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

This Docker image was made at [Cross Compass](https://www.cross-compass.com/) in Tokyo.
