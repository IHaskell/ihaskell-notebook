# ihaskell-notebook

A community maintained
[Jupyter Docker Stacks](https://github.com/jupyter/docker-stacks)
image which
provides the Jupyter [IHaskell](https://github.com/gibiansky/IHaskell) kernel
in a Docker image which composes well with other Jupyter Docker Stacks.

Includes installation of most of the 


With this IHaskell installation, we avoid putting anything in /home/jovyan.

The ihaskell executable, the ihaskell library, the ghc-parser library,
and the ipython-kernel library are built and installed at the level
of the Stack Default Global Project. This means that the ihaskell
environment is available for all users for any PWD inside the
container.

See https://github.com/gibiansky/IHaskell/issues/715

When setting up a new Jupyter notebook stack project, it's probably
a good idea to copy /opt/stack/global-project/stack.yaml
See also /opt/IHaskell/stack.yaml





## Examples

The example notebooks are collected together in the JupyterLab container at `/home/jovyan/ihaskell_examples`.

## Dependencies

### Stack default global project `/opt/stack/global-project/stack.yaml`

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

Then you can install the missing package from the terminal in your JupyterLab container:

~~
stack install deque
~~

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

#### [IHaskell.Display](https://www.stackage.org/haddock/lts-12.26/ihaskell-0.9.1.0/IHaskell-Display.html)

Some libraries in [`IHaskell/ihaskell-display`](https://github.com/gibiansky/IHaskell/tree/master/ihaskell-display)
are pre-installed in the JupyterLab container, if they appeared to be working at the time the JupyterLab Docker image was built. You can try to install the other `IHaskell/ihaskell-display` libraries, and they will be built from the `/opt/IHaskell` source in the container.

```
stack install ihaskell-diagrams
```

See the Stack global default project `/opt/stack/global-project/stack.yaml` for information about the `/opt/IHaskell` source in the container.

You can see which libraries are installed by running `ghc-pkg`:

```
stack exec ghc-pkg -- list | grep ihaskell
    ihaskell-0.9.1.0
    ihaskell-aeson-0.3.0.1
    ihaskell-blaze-0.3.0.1
    ihaskell-gnuplot-0.1.0.1
    ihaskell-hvega-0.2.0.0
    ihaskell-juicypixels-1.1.0.1
    ihaskell-widgets-0.2.3.2
```

#### Local Stack Projects

You can run a IHaskell `.ipynb` in a stack project `PWD` which has a `stack.yaml`.

You should
copy the the contents of the container's Stack global default project `/opt/stack/global-project/stack.yaml` into the local project's `stack.yaml`. That will give you the same `resolver` as the global IHaskell installation, and it will also allow you to install libraries from `IHaskell` and `IHaskell/ihaskell-display`.

After your `stack.yaml` is configured, run `:! stack build` and then ↻ restart your Jupyter Haskell kernel.

If you want to run an IHaskell `.ipynb` in a `PWD` with a `stack.yaml` that has a `resolver` different from the `resolver` in `/opt/stack/global-project/stack.yaml` then that is Undefined Behavior, as they say in C++. Maybe it will work, maybe not.


References


[IHaskell on Hackage](http://hackage.haskell.org/package/ihaskell)
[IHaskell on Stackage](https://www.stackage.org/package/ihaskell/snapshots)

[IHaskell Wiki with Exemplary IHaskell Notebooks](https://github.com/gibiansky/IHaskell/wiki)

[When Is Haskell More Useful Than R Or Python In Data Science?](https://www.quora.com/What-are-some-use-cases-for-which-it-would-be-beneficial-to-use-Haskell-rather-than-R-or-Python-in-data-science)

