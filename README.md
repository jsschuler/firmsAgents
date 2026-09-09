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
finite approximation is a distinct model family with bounded states, exact
stochastic kernels, arbitrary-horizon validity preservation, and bounded
firm-size tail observables. Julia mirrors it with exact rational transition
matrices, stationary-distribution checks, and firm-size CCDF diagnostics.

The planned 100-million-agent backend will target x86-64 and be distributed in
an Apptainer container. Its feasibility envelope, performance gates, and
reference-equivalence requirements are documented in
[`docs/HIGH_SCALE_SIMULATION.md`](docs/HIGH_SCALE_SIMULATION.md).

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

Run the population-scaling diagnostic with comma-separated population sizes,
reporting periods, burn-in, and seeds:

```sh
JULIA_NUM_THREADS=4 julia --project=julia \
  julia/scripts/study_population_scaling.jl 100,250,500,1000 40 10 101,102,103,104,105
```

To distinguish population scaling from slow convergence in simulated time,
run one long trajectory per seed and inspect nested trailing-half windows:

```sh
JULIA_NUM_THREADS=4 julia --project=julia \
  julia/scripts/study_horizon_scaling.jl 1000 20,40,80 101,102,103,104,105
```

Estimate Hill tail indices, cutoff-truncated second moments, and seed-bootstrap
uncertainty with:

```sh
JULIA_NUM_THREADS=4 julia --project=julia \
  julia/scripts/study_tail_moments.jl 1000 40 10 101,102,103,104,105,106,107,108,109,110
```

Estimate cross-population scaling of extremes relative to the median and of
second moments under cutoffs that grow with population:

```sh
JULIA_NUM_THREADS=4 julia --project=julia \
  julia/scripts/study_extreme_scaling.jl 100,250,500,1000 40 10 101,102,103,104,105
```

Measure how many independent replications are needed for the period-balanced
mean firm size to attain specified relative confidence-interval widths:

```sh
JULIA_NUM_THREADS=6 julia --project=julia \
  julia/scripts/study_mean_stabilization.jl 100,250,500,1000 40 10 30 1001
```

Track instantaneous and trailing-window distribution statistics over a very
long small-population trajectory with:

```sh
julia --project=julia \
  julia/scripts/study_long_time_drift.jl 100 5000 20260909 100
```

## Lean

With `elan`/`lake` installed:

```sh
cd lean
lake update
lake build
```
