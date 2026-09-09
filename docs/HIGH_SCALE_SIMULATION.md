# High-scale simulation plan

## Decision

Development of the high-throughput simulation backend will move to an x86-64
platform and run inside an Apptainer container. The existing Julia model and
Lean formalization remain the semantic references. The optimized backend may
use different data structures and execution machinery, but it must be checked
against the reference transition on identical initial states and draw streams
at tractable population sizes.

Target workstation capacity is 16 CPU cores and 128 GiB of RAM. The eventual
scale target is 100 million agents.

## Feasibility assessment

Holding 100 million agents in 128 GiB is feasible only with a compact,
structure-of-arrays representation. An indicative layout uses primitive arrays
for firm IDs, fixed-width neighbor IDs, preferences, efforts, and status flags,
plus incrementally maintained firm counts and total efforts. A carefully
implemented backend may require roughly 8--20 GiB for core state and working
indexes; a more conservative 30--50 GiB design would still fit in memory.

The present proof-oriented Julia representation is not suitable at this scale.
It stores heap-backed neighbor vectors, reconstructs immutable global states,
and repeatedly scans agents to recover firm membership. Its work is therefore
approximately linear in population per activation and quadratic per simulated
period. Moving the same code to a larger-memory machine would not solve this
algorithmic bottleneck.

One period at the target scale contains 100 million asynchronous activations.
Indicative event-loop targets are:

| Sustained throughput | Time per period | Time per 1,000 periods |
|---:|---:|---:|
| 1 million events/s | 100 seconds | 27.8 hours |
| 5 million events/s | 20 seconds | 5.6 hours |
| 10 million events/s | 10 seconds | 2.8 hours |

These figures exclude initialization, checkpoints, and final analysis. They are
planning targets, not measured performance claims.

## Backend requirements

The fast backend should provide:

- structure-of-arrays storage using explicitly sized primitive types;
- fixed-width neighbor storage and constant-time agent lookup;
- incrementally maintained firm membership counts and aggregate effort;
- in-place event updates with no allocation in the hot loop;
- an analytic, table-driven, or otherwise accelerated best response;
- deterministic counter-based or splittable random-number streams;
- streaming diagnostics instead of retained full-state histories;
- periodic, atomic, resumable checkpoints;
- explicit overflow checks for identifiers and counters;
- benchmark and provenance metadata embedded in every result.

Exact asynchronous dynamics contain sequential dependencies. Sixteen cores can
always run independent replications, but one trajectory cannot be parallelized
naively without changing its semantics. Intra-trajectory parallelism may use
conflict-free batches of activations, provided the batching algorithm preserves
the specified event ordering or is explicitly treated as a separate model.

## Apptainer environment

The container should pin:

- an x86-64 Julia release and project manifest;
- compiler and native-library versions;
- CPU-target policy, with a portable default and an optional host-optimized
  image or runtime setting;
- test, benchmark, checkpoint, and analysis entry points;
- immutable source revision and container-definition metadata.

The definition file should build without privileged runtime access after the
image is produced. Simulation outputs and checkpoints should live in mounted
host directories rather than inside the image. The container must expose a
small smoke test that runs without cluster-specific paths.

## Verification strategy

Optimization is accepted only after differential tests establish agreement
with the reference Julia implementation. Tests should compare:

1. initialized state projections;
2. candidate firms and best-response choices;
3. every state after each event for fixed draw streams;
4. tie-breaking behavior and firm-identity allocation;
5. period diagnostics and distribution summaries;
6. restart behavior across a checkpoint boundary.

Pathwise comparisons should cover small populations, adversarial ties, firm
entry and exit, and long seeded streams. Lean continues to specify the exact
semantic layer; it is not expected to share the optimized memory layout.

## Staged scale gates

1. Establish pathwise equivalence and allocation-free stepping at `N = 10^3`.
2. Benchmark throughput and memory at `N = 10^5`.
3. Repeat at `N = 10^6`, including checkpoint and restart tests.
4. Run `N = 10^7` long enough to measure sustained throughput, memory headroom,
   and diagnostic overhead.
5. Extrapolate measured costs and approve or reject the `N = 10^8` attempt.
6. At `N = 10^8`, begin with initialization and one-period validation before
   committing to a long production run.

Each gate records resident memory, initialization time, events per second,
checkpoint size and duration, restart equality, and diagnostic overhead. A
100-million-agent long run will not be scheduled solely from theoretical
memory estimates.

## Current conclusion

The target is plausible on 16 x86-64 cores with 128 GiB of RAM after a major
backend redesign. Memory is unlikely to be the binding constraint. Sustained
event throughput and preservation of asynchronous semantics are the principal
engineering risks. Multiple target-scale replications may require longer jobs
or additional machines even if one trajectory is feasible.
