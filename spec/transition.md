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

One draw activates one agent. The transition constructs the current firm,
distinct neighbor firms, and singleton startup; numerically maximizes effort in
each alternative; applies the documented tie rule; atomically updates effort
and membership; and removes the empty origin firm when necessary.
