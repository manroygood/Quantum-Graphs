# QGLAB Readme

QGLAB is an object-oriented framework for working with quantum graphs in MATLAB. The current version defines a quantum graph object and allows the following operations

* Define a finite quantum graph with arbitrary topology, edge lengths, and vertex conditions.
* Compute the spectral determinant symbolically for a variety of verex conditions
* Define a Laplacian operator on the quantum graph, using two methods:
   * Second-order centered differences on the edges and second order vertex conditions implemented using ghost points.
   * Chebyshev spectral methods
* Solve nonlinear Schrödinger equations, and continue branches of solutions. Switch branches.
* Solve various time dependent PDE posed on a quantum graph
* Beautiful and easy plots of functions defined over metric graphs, and of bifurcation diagrams

This code is written as a MATLAB [_Project_](https://www.mathworks.com/help/simulink/project-management.html). In order to run it, first type
```>> openProject QGObject.prj``` 
at the MATLAB prompt or else click on the file `QGObject.prj` in the file listing on the left. 
This will open up a project window. This does three things that allow you to run the codes:

1. Set the paths.
2. Change some plotting defaults. The users defaults are saved in a `tmp` directory and are restored when the user closes the project by closing the project window.
3. Verify that certain MATLAB toolboxes are installed that are necessary for certain functioning of the package.

#### The preprint

In December, 2023, we submitted a paper entitled "QGLAB: A MATLAB Package for Computations on Quantum Graphs" describing the algorithms underlying QGLAB to a journal for publication. A slightly-modified version has been posted to the [arXiv](https://arxiv.org/abs/2401.00561).

#### Documentation

Basic instructions are in a Matlab live script quantumGraphRoutines.mlx, which has also been saved as an [HTML file](quantumGraphRoutines.html).

Many additional examples are presented in live scripts in directories `source/examples` and its subdirectories, and in `documentation`.

A wide variety of graphs are implemented in `source/templates`. These are demonstrated in `source/templates/templateGallery.mlx`.

If it doesn't make sense, just ask me.

#### Reproducibility

There is a live script to reproduce every figure in the preprint that was produced using QGLAB. Some of the figures were edited interactively for clarity after being created by a script so that formatting may differ slightly. The following table lists the figures (numbered as on the arXiV while the paper remains under review).

| Figure      | Description                                                  | file                                                         |
| ----------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 2.2         | Layout and Laplacian matrix ($\mathbf{L}_{\mathrm{VC}}$) nonzero pattern for lollipop graph | `documentation/figures_from_the_paper/figure2p2.mlx`         |
| 2.4         | Same as 2.2 but for Chebyshev and includes interpolation matrix $\mathbf{V}_0$ | `documentation/figures_from_the_paper/figure2p4.mlx`         |
| 2.5 and A.1 | Four eigenfunctions and spectral determinant for a Y-shaped graph | `documentation/figures_from_the_paper/figure2p5.mlx`         |
| 2.6         | Stationary NLS solutions on dumbbell and spiderweb graphs    | `documentation/figures_from_the_paper/figure2p6.mlx`         |
| 2.7 & A.6   | Continuation study of NLS solutions on the necklace graph and two eigenfunctions | `source/examples/stationary/necklaceBifurcationDiagram.mlx`  |
| 2.8 and A.9 | Soliton solutions colliding with a vertex on balanced and unbalanced star graphs. | `source/examples/evolution/NLSOnBalancedStar23t.mlx` and `source/examples/evolution/NLSOnUnbalancedStar23t.mlx` |
| 2.9         | KPP equation on a honeycomb                                  | `source/examples/evolution/KPPonHoneycomb.mlx`               |
| 3.1         | Function plotting on graphs with 2D and 3D layout            | `documentation/figures_from_the_paper/figure3p1.mlx`         |
| A.2         | QGLAB log (ground state of L-shaped quantum graph)           | In  `/documentation/templateGallery.mlx`                     |
| A.3         | Solution of Poisson equation on a 3-node graph               | `source/examples/stationary/poissonExample.mlx` and `source/examples/chebyshev/poissonExampleChebyshev.mlx` |
| A.4         | Cubic NLS continuation study on a dumbbell graph             | `documentation/continuationInstructions.mlx` contains these images and many more useful plotting routines for continuation studies |
| A.5         | Cubic-Quintic NLS continuation on a dumbbell graph           | `source/examples/stationary/dumbbellContinuation35.mlx`      |
| A.7         | Heat equation solution on dumbbell                           | `source/examples/evolution/heatOnDumbbell.mlx` also see `source/examples/evolution/heatOnDumbbellTestOrder.mlx`  for convergence study |
| A.8         | sine-Gordon equation on tetrahedron (flattened to Mercedes-Benz logo for plotting) | `source/examples/evolution/sineGordonOnTetra.mlx`            |
| B.2         | Visualization of a function defined on a random graph using `plot` and `pcolor` | Code in text                                                 |
| B.3         | The "bubble tower" graph                                     | Code in text                                                 |

#### QGLAB in action

This package (or earlier versions) has been used in the following papers:

* Goodman, R. H., [NLS bifurcations on the bowtie combinatorial graph and the dumbbell metric graph](http://doi.org/10.3934/dcds.2019093). *Discrete & Continuous Dynamical Systems - A*, *39*(4), 2203–2232, (2019). 
* Kairzhan, A., Pelinovsky, D. E., & Goodman, R. H., [Drift of Spectrally Stable Shifted States on Star Graphs](http://doi.org/10.1137/19M1246146). *SIAM Journal on Applied Dynamical Systems*, *18*(4), 1723–1755, (2019).  (Much of this is reproduced in `source/examples/shiftedStates`.)
* Berkolaiko, G., Marzuola, J. L., & Pelinovsky, D. E., [Edge-localized states on quantum graphs in the limit of large mass](https://doi.org/10.1016/j.anihpc.2020.11.003), _Annales de l'Institut Henri Poincaré C, Analyse non linéaire,_ 2020.
* Beck, T., Bors, I., Conte, G., Cox, G. & Marzuola, J.L., [Limiting eigenfunctions of Sturm–Liouville operators subject to a spectral flow](https://doi.org/10.1007/s40316-020-00142-6). *Ann. Math. Québec* (2020).  
* Kairzhan, A. & Pelinovsky, D. E., [Multi-pulse edge-localized states on quantum graphs](https://doi.org/10.1007/s13324-021-00603-3), *Anal. Math. Phys.* *11,* 171 (2021).
* A. Kairzhan, D. Noja, and D.E. Pelinovsky, [Standing waves on quantum graphs](https://doi.org/10.1088/1751-8121/ac6c60), J. Phys. A: Math. Theor. 55 (2022) 243001. 

and in the [2022 doctoral dissertation](https://cdr.lib.unc.edu/concern/dissertations/8623j7218?locale=en) of Grace Conte at the University of North Carolina.

#### Planned additions and feature requests

* Deflated continuation in order to locate nonlinear branches in a neighborhood of high-codimension bifurcations that arise in quantum graphs with large discrete symmetry groups.
* More advanced IMEX time-steppers
* More general vertex conditions

We are happy to consider adding features and/or merging contributions.

If you use the package for published work, please cite it as

```bibtex
@misc{qgpackage,
    author       = {R. H. Goodman and G. Conte and J. L. Marzuola},
    title        = {Quantum Graphs Package},
    year         = 2021,
    doi          = {https://doi.org/10.5281/zenodo.4898112},
    version      = {0.96},
    publisher    = {Zenodo},
    url          = {https://doi.org/10.5281/zenodo.4898112}
    }
```



```
[![DOI](https://zenodo.org/badge/298713469.svg)](https://zenodo.org/badge/latestdoi/298713469)
```

