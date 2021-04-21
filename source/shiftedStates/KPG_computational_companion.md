# A Computational Companion to Kairzhan, Pelinovsky, Goodman 2019

$ \DeclareMathOperator{\sech}{sech}xyz$

This note describes a time-dependent PDE problem that one of us (Roy Goodman) solved numerically using the tools developed for the Quantum Graph package. I provide a description of the problem, and the numerical approach to solving it below.

In 2018, I began working with Adilbek Kairzhan and Dmitry Pelinovsky to verify and illuminate some analytical results they had obtained for the solution to a PDE on a quantum graph. The results appeared in 

Kairzhan, A., Pelinovsky, D. E., & Goodman, R. H. (2019). [Drift of Spectrally Stable Shifted States on Star Graphs](https://epubs.siam.org/doi/10.1137/19M1246146). **SIAM Journal on Applied Dynamical Systems**, 18(4), 1723–1755

## Problem setup

A natural question to ask about quantum graphs is "What happens to my favorite PDE when I place it on a quantum graph?" In a series of papers, Kairzhan and Pelinovsky considered the propagation of waves satisfying the cubic NLS equation on star-shaped quantum graphs. A fundamental property of the cubic NLS 
$$
i u_t + u_{xx} + 2 \lvert u \rvert^2 u = 0 \label{NLS}
$$
is that it possesses an infinite set of conservation laws. Consider the star graph consisting of $N$ half-lines emanating from a single vertex, with Kirchhoff boundary conditions. When NLS is defined on the star graph subject to Kirchhoff boundary condition 
$$
u_1(0,t)=u_2(0,t) = \ldots u_N(0,t);\\
\sum_{n=1}^N \partial_x u_j(0,t) = 0,
$$


it is easy to show that the $L^2$ norm and the energy are conserved, but that momentum conservation fails. We can define a so called _balanced  star graph_, by introducing a weighted Kirchhoff boundary condition of the form
$$
u_1(0,t)=u_2(0,t) = \ldots u_N(0,t);\\
(N-1)\partial_x u_1(0,t) + \sum_{n=2}^N \partial_x u_j(0,t) = 0.
$$
On the balanced star graph, conservation of momentum does not hold in general. However, if we consider only solutions lying on an invariant subspace defined by
$$
u_2(x,t)=u_3(x,t)=\ldots u_N(x,t), \label{symmetry_assumption}
$$
then the dynamics on the quantum graph reduce to the dynamics of the cubic NLS on the line (with the dynamics on edge 1 representing $x<0$ and the dynamics on the other edges representing $x>0$).[^scaling] Since the dynamics on this subspace are equivalent to those of the standard NLS, all conservation laws, including momentum conservation, hold for solutions on this subspace.

[^scaling]:Kairzhan and Pelinovsky use an alternate formulation where the weight is applied to the nonlinearity in the PDE, rather than to the flux boundary condition.  The formulation used here fits more easily with the quantum graph package.

Kairzhan and Pelinovsky refer to edge $1$ as the _incoming_ edge and the remaining $N-1$ edges as the _outgoing_ edges. Thus such solutions automatically satisfy the other conservations laws of NLS including momentum conservation.

In order to make the analogy with NLS on $\mathbb{R}$ more exact and to simplify notation, we take $-\infty<x<0$ on edge $1$ and $0<x<\infty$ on the remaining edges. Note that his changes the flux condition at the vertex to 
$$
-(N-1)u_1'(0) + \sum_{n=2}^N u_j'(0) = 0
$$


## Shifted states

Cubic NLS on the real line has a stationary soliton solution 
$$
u = \sech{(x-x_0)}
$$
which gives rise to the stationary solution known as the _shifted state_ 
$$
\begin{aligned}
u_1 &= \sech{(x+x_0)}; \\
u_n &= \sech{(x-x_0)},\ n=2,\ldots,N.
\end{aligned}
$$
If $x_0<0$, then the non-monotonic part of the solution lies on the incoming edge, and the solution on each outgoing edge consists of a monotonic tail. If $x_0>0$ then the function on each of the outgoing edges has a maximum at $x=x_0$. 

## Main analytical result

In the case $x_0<0$ the shifted state was known to be linearly (spectrally) stable, while in the case $x_0>0$ the shifted state is linearly unstable. Adilbek and Dmitry showed that in the case $x_0<0$ the shifted state is in fact _nonlinearly unstable_, to perturbations that break the symmetry assumption $(\ref{symmetry_assumption})$.

Further they showed that the momentum of such solutions is generically positive, causing the perturbed shifted state to drift slowly toward the vertex at $x=0$, whereupon the solution becomes linearly unstable and quickly moves away from the origin.

This is verified in the following two computations. In the first, corresponding to Figure 3 of the paper, $x_0 = 0.55>0$ and the perturbed shifted state immediately acquires positive momentum and escapes along one of the outgoing edges.

[Figure 3 Computational Supplement](KPG_Figure3.mlx)

In the second, corresponding to Figure 4, $x_0 = -0.55<0$ so that the shifted state is linearly stable but nonlinearly unstable. It slowly drifts toward the vertex. An oscillation is easily visible in the dynamics due to the dominant purely imaginary eigenvalue. When the solution reaches the vertex, it acquires positive momentum and escapes along one of the outgoing edges.

[Figure 4 Computational Supplement](KPG_Figure4.mlx)

Finally, I show a recomputation of Figure 6. In this case we consider a solitary wave initially centered at $x=0,$ but given a perturbation that imparts negative momentum, pushing it onto the incoming edge. The results of the paper show that for such a solution $\frac{dP}{dt}>0$, so we were attempting to show that this acceleration could eventually pull the solitary wave back to the vertex, where it would acquire $O(1)$ momentum and escape along one of the outgoing edges. That is indeed what we found.

[Figure 6 Computational Supplement](KPG_Figure6.mlx)

## About the numerics

The theorems proved in this paper apply to star graphs consisting of three or more half lines that meet at a single vertex. We truncated each edge to a finite length $L$ and then modified the Laplacian operator on a small segment near the end, using the method of _perfectly matched layers_ following a paper of Nissen and Kreiss.[^Nissen] I remember that at the time I was working at this, I found that radiation shed by the solution was reflected off the endpoints of the truncated half lines and changing the results. In reproducing the results for inclusion with this package, I’m not finding that problem. The solution does depend sensitively on whether PML is used. In the following live script, we turn off the PML in the computation for Figure 4. The basic behavior is unchanged, but note that the traveling wave escapes along edge 2, whereas when the PML is included, it escapes along edge 3.

[Figure 4 without PML](KPG_Figure4_no_PML.mlx)

[^Nissen]:    Nissen, A. & Kreiss, G. [An Optimized Perfectly Matched Layer for the Schrödinger Equation](https://www.cambridge.org/core/journals/communications-in-computational-physics/article/abs/an-optimized-perfectly-matched-layer-for-the-schrodinger-equation/B4CBF60CE69B43C8417E0EB09FABF867). *Communications in Computational Physics* **9**, 147–179 (2015).

For the time stepping, we used a split-step method due to Weidemann and Herbst.[^Weidemann] The two terms on the right-hand side of Eq. ($\ref{NLS}$) are handled separately. At each time step of length $\Delta t,$ one first evolves the linear part of the equation by a time step of length $\frac{\Delta t}{2}$ using the Crank-Nicholson method.  Note that in our implementation of the finite difference scheme, the central vertex lies halfway between spatial grid points, and there is no need to explicitly satisfy the boundary condition. Then one evolves the nonlinearity by a time step of length $\Delta t$. Putting $u(t)$ into polar coordinates, this is simply a pointwise update of the phase. One then evolves the linear part by another time step of length $\frac{\Delta t}{2}$. Using the standard trick, we may combine all the intermediate half-time-steps, and perform half as many linear solves over the course of the solution.

[^Weidemann]:    [Weideman, J. A. C. & Herbst, B. M. Split-Step Methods for the Solution of the Nonlinear Schrödinger Equation](https://doi.org/10.1137/0723033). *SIAM Journal on Numerical Analysis* **23**, 485–507 (1986).