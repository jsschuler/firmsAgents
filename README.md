# AgenticAxtell

A semantic implementation of the continuous-effort Axtell firm-formation model
with a formally separated, feature-gated agentic extension boundary.

The implementation is split into:

- `julia/`: executable reference package and tests.
- `lean/`: Lean 4 specification and structural proofs.
- `spec/`: the shared data dictionary and transition contract.

The two implementations use native types. They share semantics through the
written schema and acceptance examples rather than generated shared source.

## Current semantic baseline

Julia implements continuous effort, Axtell production and Cobb-Douglas utility,
equal sharing, local neighbor-firm search, singleton startup, empty-firm removal,
fixed population, and asynchronous activation. Numerical completion rules not
fixed by the source are listed in `docs/IMPLEMENTATION_CHOICES.md`.

The simulation layer records reproducibility metadata and reporting-period
states. Diagnostics cover firm size/output, growth and size-conditioned growth
dispersion, firm lifetimes, effort, income, utility, and aggregate productivity.

Lean specifies the mathematical primitives over `ℝ`, local candidates, a sound
deterministic choice-rule boundary, and exact agentic baseline recovery. The
finite approximation is intentionally deferred and must remain a distinct
model family.

## Julia

```sh
julia --project=julia -e 'using Pkg; Pkg.test()'
```

Run the configurable multi-seed baseline diagnostic with:

```sh
julia --project=julia julia/scripts/validate_baseline.jl 40 10 101,202,303
```

Arguments are reporting periods, burn-in periods, and comma-separated seeds.

For independent seed-level consistency diagnostics, use multiple Julia threads:

```sh
JULIA_NUM_THREADS=4 julia --project=julia \
  julia/scripts/validate_many_seeds.jl 40 10 101:120
```

## Lean

With `elan`/`lake` installed:

```sh
cd lean
lake update
lake build
```
