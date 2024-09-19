# QGLAB Readme

QGLAB is an object-oriented framework for working with quantum graphs in MATLAB. The current version defines a quantum graph object and allows the following operations

* Define a finite quantum graph with arbitrary topology, edge lengths, and vertex conditions.
* Compute the spectral determinant symbolically for a variety of vertex conditions
* Define a Laplacian operator on the quantum graph, using two methods:
   * Second-order centered differences on the edges and second-order vertex conditions implemented using ghost points.
   * Chebyshev spectral methods
* Solve nonlinear Schrödinger equations, and continue branches of solutions. Switch branches.
* Solve various time-dependent PDE posed on a quantum graph
* Plots of functions defined over metric graphs and bifurcation diagrams easily and beautifully.

This code is written as a MATLAB [_Project_](https://www.mathworks.com/help/simulink/project-management.html). To run it, first type
```>> openProject QGObject.prj``` 
at the MATLAB prompt or click on the file `QGObject.prj` in the file listing on the left. 
This will open up a project window. This does three things that allow you to run the codes:

1. Set the paths.
2. Change some plotting defaults. The user's defaults are saved in a `tmp` directory and are restored when the user closes the project by closing the project window.
3. Verify that certain MATLAB addons are installed that are necessary for certain functions of the package. These are: 
   1. The Symbolic Mathematics Toolbox.
   2. The *arrow3* package is used to add annotation arrows to plots.


#### The preprint

In December 2023, we submitted a paper entitled “QGLAB: A MATLAB Package for Computations on Quantum Graphs” to a journal for publication. The paper describes the algorithms underlying QGLAB. A slightly modified version has been posted to the [arXiv](https://arxiv.org/abs/2401.00561).

#### Documentation

Basic instructions are in a Matlab live script `documentation/quantumGraphRoutines.mlx`, also saved as an [HTML file](documentation/quantumGraphRoutines.html). 

This has been expanded further into a tutorial that was entered into the 2024 SIAM Dynamical Systems Tutorial Contest. It is saved as a [PDF](documentation/Tutorial/QGLABtutorial.pdf).

Many additional examples are presented in live scripts in the directory `source/examples`, its subdirectories, and `documentation`.

A wide variety of graphs are implemented in `source/templates`. These are demonstrated in `source/templates/templateGallery.mlx`.

If it doesn't make sense, ask me.

#### Reproducibility

We provide a live script to reproduce each figure in the preprint generated using QGLAB. Some figures were edited interactively for clarity after being created by a script so that formatting may differ slightly. The following table lists the figures (numbered as on the arXiv while the paper remains under review).

| Figure/Section                        | Description                                                  | file                                                         |
| ------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Fig. 1.1 and Sec. 4.1                 | Example graph and Poisson problem                            | `source/examples/stationary/poissonSchrodingerExample.mlx`   |
| Fig. 2.2                              | Layout and Laplacian matrix ($\mathbf{L}_{\mathrm{VC}}$) nonzero pattern for lollipop graph | `documentation/figures_from_the_paper/figure2p2.mlx`         |
| Fig. 2.4                              | Same as 2.2 but for Chebyshev and includes interpolation matrix $\mathbf{V}_0$ | `documentation/figures_from_the_paper/figure2p4.mlx`         |
| Fig. 2.5 and 4.1, Secs. 4.2 and A.1.1 | Four eigenfunctions and spectral determinant for a Y-shaped graph | `documentation/figures_from_the_paper/figure2p5.mlx`         |
| Fig. 2.6                              | Stationary NLS solutions on the dumbbell and spiderweb graphs | `documentation/figures_from_the_paper/figure2p6.mlx`         |
| Fig. 2.7 and A.3                      | Continuation study of NLS solutions on the necklace graph and two eigenfunctions | `source/examples/stationary/necklaceBifurcationDiagram.mlx`  |
| Fig. 2.8, Sec 4.3                     | Soliton solutions colliding with a vertex on balanced and unbalanced star graphs. | `source/examples/evolution/NLSOnBalancedStarSDIRK443.mlx` and `source/examples/evolution/NLSOnUnbalancedStarSDIRK443.mlx` |
| Fig. 3.1                              | Function plotting on graphs with 2D and 3D layout            | `documentation/figures_from_the_paper/figure3p1.mlx`         |
| Fig. A.1                              | Cubic NLS continuation study on a dumbbell graph             | `documentation/continuationInstructions.mlx` contains these images and many more useful plotting routines for continuation studies |
| Fig. A.2                              | Cubic-Quintic NLS continuation on a dumbbell graph           | `source/examples/stationary/dumbbellContinuation35.mlx`      |
| Fig. A.4                              | Heat equation solution on dumbbell                           | `source/examples/evolution/heatOnDumbbell.mlx` also see `source/examples/evolution/heatOnDumbbellTestOrder.mlx`  for convergence study |
| Fig. A.5                              | sine-Gordon equation on tetrahedron (flattened to Mercedes-Benz logo for plotting) | `source/examples/evolution/sineGordonOnTetra.mlx`            |
| Fig. B.2                              | Visualization of a function defined on a random graph using `plot` and `pcolor` | `source/documentation/figures_from_the_paper/figureB2_figureB3.mlx` |
| Fig. B.3                              | The "bubble tower" graph                                     | `source/documentation/figures_from_the_paper/figureB2_figureB3.mlx` |

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
* Semi-infinite edges

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



[![DOI](https://zenodo.org/badge/298713469.svg)](https://zenodo.org/badge/latestdoi/298713469)

