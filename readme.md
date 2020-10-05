# Quantum Graph Package Readme

This package contains an object-oriented framework for working with quantum graphs in MATLAB. The current version defines a quantum graph object and allows the following operations

* Define a quantum graph with arbitrary topology, edge lengths, and vertex conditions.
* Compute the spectral determinant symbolically (Neumann/Kirchhoff vertex conditions only, Dirichlet & Robin coming soon.)
* Define a Laplacian operator on the quantum graph, using second-order centered differences on the edges and second order vertex conditions implemented using ghost points.
* Solve cubic nonlinear Schrödinger equations, and continue branches of solutions. Switch branches.
* Beautiful and easy plots of functions defined over metric graphs, and of bifurcation diagrams.

This code is written as a MATLAB [_Project_](https://www.mathworks.com/help/simulink/project-management.html). In order to run it, first type
```>> openProject QGObject.prj``` 
at the MATLAB prompt or else click on the file `QGObject.prj` in the file listing on the left. This will open up a project window. This does two things that allow you to run the codes.

1. Set the paths.
2. Change some plotting defaults. The users defaults are saved in a `tmp` directory and are restored when the user closes the project by closing the project window.

There's some documentation:

Basic instructions are in a matlab live script `quantumGraphRoutines.mlx`, which has also been saved as an [html file](quantumGraphRoutines.html).

Some additional examples are in live scripts in directories `source/examples`, and `documentation`.

This package has been used in the following papers

* Goodman, R. H., NLS bifurcations on the bowtie combinatorial graph and the dumbbell metric graph. *Discrete & Continuous Dynamical Systems - A*, *39*(4), 2203–2232, (2019). http://doi.org/10.3934/dcds.2019093
* Kairzhan, A., Pelinovsky, D. E., & Goodman, R. H. Drift of Spectrally Stable Shifted States on Star Graphs. *SIAM Journal on Applied Dynamical Systems*, *18*(4), 1723–1755, (2019). http://doi.org/10.1137/19M1246146 (Uses modifications to code not in the package including PML to study time-dependent wave propagation on semi-infinite edges.)
* Berkolaiko, G., Marzuola, J. L., & Pelinovsky, D.M., Edge-localized states on quantum graphs in the limit of large mass.  [arXiv:1910.03449v2](https://arxiv.org/abs/1910.03449v2) (2020)
* Beck, T., Bors, I., Conte, G., Cox, G. & Marzuola, J.L., Limiting eigenfunctions of Sturm–Liouville operators subject to a spectral flow. *Ann. Math. Québec* (2020). https://doi.org/10.1007/s40316-020-00142-6 (Gracie Conte's spectrally-accurate modifcation.)

#### Coming Soon

* Secular determinants for a wider variety of vertex conditions
* Spectral (Chebyshev) implementation of Laplace operator
* Happy to consider adding features, or merge in contributions.

