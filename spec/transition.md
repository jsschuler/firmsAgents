# Transition boundary

Sampling and transition semantics are separate:

```text
sample_draw(rng, state, config, params) -> Draw
step(state, draw, config, params) -> State
```

`step` must contain no randomness. Replaying the same initial state and draw
sequence must reproduce the same trajectory without an RNG.

The distinct finite approximation follows the same separation. A
`FiniteDraw` contains a bounded activated-agent ID and bounded tie-break value;
a supplied finite choice rule returns an optional `FiniteAction`. The
deterministic transition applies that action atomically or returns the original
state when the agent or action is absent. Its partition-validity invariant says
that recorded active firms are exactly those occupied by active agents.
Successful transitions recompute that set, while identity branches preserve
it; consequently the invariant is preserved by every finite choice rule (and
hence by every admissibility-sound rule).

For finite stochastic analysis, Julia may enumerate a transition-closed state
list and a finite draw distribution, then aggregate exact draw weights into a
row-stochastic transition matrix. Lean defines the corresponding uniform-draw
kernel as a probability mass function obtained by mapping the deterministic
transition over the draw PMF. Thus normalization is structural rather than a
floating-point postcondition.

The cross-language check uses integer transition counts divided by an exact
common denominator. The Lean kernel-entry theorem expresses the probability
of a successor as the sum of uniform weights over its transition preimage;
Julia's matrix constructor performs exactly that aggregation. The shared
two-state fixture therefore compares semantics without numerical tolerance.

Multi-step dynamics repeatedly multiply Julia row distributions by the exact
transition matrix. Lean iterates the corresponding kernel with `PMF.bind`;
support induction guarantees that partition and graph invariants persist at
every finite horizon. A stationary Julia distribution is one fixed exactly by
one such matrix step.

Chain structure is defined from positive-probability kernel support. Its
reflexive-transitive closure is reachability; mutual reachability is
communication. Closed communicating classes cannot be exited by a positive
transition, while an absorbing state has a point-mass successor kernel and
therefore forms a singleton closed communicating class. Irreducibility and
eventual-return aperiodicity are explicit predicates rather than assumptions.

Julia computes these notions on exact transition matrices. Communicating
classes are the equivalence classes of mutual reachability; a class is closed
when its rows have no positive edge outside the class. Periods are computed by
the standard gcd of depth differences around positive edges. These diagnostics
must be run on a concrete finite choice rule before using irreducible-chain
uniqueness or convergence conclusions.

One draw activates one agent. The transition constructs the current firm,
distinct neighbor firms, and singleton startup; numerically maximizes effort in
each alternative; applies the documented tie rule; atomically updates effort
and membership; and removes the empty origin firm when necessary.
