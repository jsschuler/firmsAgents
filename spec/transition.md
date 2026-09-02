# Transition boundary

Sampling and transition semantics are separate:

```text
sample_draw(rng, state, config, params) -> Draw
step(state, draw, config, params) -> State
```

`step` must contain no randomness. Replaying the same initial state and draw
sequence must reproduce the same trajectory without an RNG.

One draw activates one agent. The transition constructs the current firm,
distinct neighbor firms, and singleton startup; numerically maximizes effort in
each alternative; applies the documented tie rule; atomically updates effort
and membership; and removes the empty origin firm when necessary.
