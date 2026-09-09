# Cross-language semantic model contract

This document is the cross-language data dictionary. Julia and Lean retain
native types, but must preserve these names, meanings, and transition order.

`SPEC_ADDENDUM_AXTELL.md` is normative for Layer 0. Completion rules not fixed
by the source are documented in `docs/IMPLEMENTATION_CHOICES.md`.

## Scalar domains

| Concept | Julia | Lean | Constraint |
|---|---|---|---|
| agent ID | `AgentId` wrapping `Int` | `AgentId` wrapping `Nat` | positive/nonzero |
| firm ID | `FirmId` wrapping `Int` | `FirmId` wrapping `Nat` | positive/nonzero |
| preference | `Float64` | `ℝ` | in `[0,1]` |
| effort | `Float64` | `ℝ` | in `[0,1]` |
| finite effort level | `EffortLevel{K}` | `EffortLevel grid` | index in `0:K`, decoded as `index/K` |
| compute | `Float64` | deferred | extension state, behaviorally inert |

## Records

- `AgentState`: ID, preference, effort, firm ID, fixed neighbors, and inert
  extension scaffolding.
- `FirmState`: ID only at this milestone. Membership is canonical in agents;
  firm membership is therefore not duplicated.
- `State`: active agents, valid firms, and next unused agent ID.
- `Draw`: activated agent and explicit tie-break value.
- `Params`: population, production, neighborhood, reporting, initialization,
  optimizer, and comparison parameters.
- `Config`: all nine feature flags required by `SPEC.md`.
- `FiniteModelState`: distinct approximation carrier with bounded ID types,
  optional bounded agent slots, grid-valued preferences and efforts, finite
  neighbor/firm sets, and bounded optional next IDs. Its current finite
  partition-validity predicate requires the active-firm set to be exactly the
  set of firm IDs occupied by active agent slots. Its separate graph-validity
  predicate forbids self-neighbors and requires every neighbor slot to be
  occupied; finite transitions preserve both invariants.

## Transition composition

The canonical order is:

```text
baseline_transition
→ compute operator
→ spawning operator
→ termination operator
→ delegation operator
→ specialization operator
→ hierarchy operator
→ compute-market operator
→ compute-inheritance operator
→ mutation operator
```

Every agentic operator is currently inert. With baseline flags, the extended
event transition is exactly the semantic Axtell event transition.
