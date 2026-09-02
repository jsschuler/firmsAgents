# Addendum to `SPEC.md`: Faithful Axtell Baseline

## Status

This addendum is normative. Where it conflicts with the earlier `SPEC.md`, this addendum governs the implementation of **Layer 0 — Axtell baseline**.

The source for the baseline is Robert Axtell, *The Emergence of Firms in a Population of Agents: Local Increasing Returns, Unstable Nash Equilibria, and Power Law Size Distributions* (1999 working paper).

The purpose of this addendum is to replace generic placeholders in the original specification with the actual Axtell primitives, while preserving the larger goal:

\[
\text{Axtell baseline} \subset \text{Agentic-AI extension}
\]

with exact recovery by feature flags.

---

# 1. Important Correction to the Original Specification

The faithful Axtell baseline is **not a finite-state model**.

Axtell assumes:

- a finite, fixed population of agents;
- continuous effort
  \[
  e_i\in[0,1];
  \]
- heterogeneous preference parameters
  \[
  \theta_i\in[0,1],
  \]
  with the computational base case drawing
  \[
  \theta_i\sim U[0,1].
  \]

Therefore, the exact Axtell baseline and a finite-state Markov-chain approximation must be treated as distinct objects.

We require two model families:

\[
M_A
\]

for the faithful continuous-effort Axtell model, and

\[
M_A^{(K)}
\]

for a deliberately discretized finite approximation used for finite-state convergence proofs.

The discretization must **not** be silently incorporated into the Axtell baseline.

Consequently:

```text
faithful_axtell = true
```

means continuous effort semantics.

A separate approximation parameter or model constructor may define a grid such as

\[
\mathcal E_K=\left\{0,\frac1K,\ldots,1\right\}.
\]

The theorem

\[
M_{\text{extended}}(\phi_A)=M_A
\]

must concern the faithful baseline, not the discretized approximation.

Finite-state ergodicity theorems concern \(M_A^{(K)}\) or corresponding finite agentic extensions unless and until a theorem for the continuous-state process is proved.

---

# 2. Axtell Baseline Primitives

## 2.1 Agents

There is a finite, fixed set of agents

\[
\mathcal A=\{1,\ldots,A\}.
\]

Each agent \(i\) has:

- preference parameter \(\theta_i\in[0,1]\);
- effort \(e_i\in[0,1]\);
- current firm membership \(f_i\);
- a fixed social network / neighbor set \(N_i\);
- previous-period income;
- previous-period utility;
- optionally accumulated wealth, as in Axtell's implementation bookkeeping.

The base computational case uses

\[
A=1000,
\qquad
\theta_i\overset{iid}{\sim}U[0,1],
\qquad
|N_i|=\nu_i=2.
\]

The social network is assigned randomly at initialization and remains fixed in the base case.

The Julia and Lean state specifications should distinguish **behaviorally essential state** from **diagnostic/bookkeeping state**. Previous income, utility, wealth, founder identity, growth rates, etc. should not be allowed to alter the transition law unless the relevant Axtell rule actually uses them.

---

# 3. Firm Technology

For firm \(F\), define total effort

\[
E_F=\sum_{i\in F}e_i.
\]

The analytical model begins with

\[
O(E)=aE+bE^2.
\]

The computational model generalizes this to

\[
\boxed{
O(E)=aE+bE^\beta,
\qquad \beta\geq1.
}
\]

Interpretation:

- \(aE\): constant-returns component;
- \(bE^\beta\): cooperative increasing-returns component;
- \(b=0\): constant returns to cooperation;
- \(b>0,\ \beta>1\): increasing returns to cooperation.

The Axtell base case is

\[
a=1,\qquad b=1,\qquad \beta=2.
\]

This exact production function must replace the generic `F_A` placeholder in `SPEC.md`.

---

# 4. Compensation

Firm output is divided equally among all current members.

For firm \(F\),

\[
N_F=|F|,
\]

and every member receives income

\[
\boxed{
y_i=\frac{O(E_F)}{N_F}.
}
\]

Equal sharing is part of the baseline and must be the default when all non-baseline flags are disabled.

Alternative compensation rules belong in later feature flags / experimental variants.

---

# 5. Preferences and Utility

Each agent has Cobb-Douglas preferences over income and leisure.

Leisure is

\[
1-e_i.
\]

Given candidate effort \(e_i\), effort supplied by everyone else in the candidate firm

\[
E_{-i},
\]

and candidate firm size \(N\), utility is

\[
\boxed{
U_i(e_i;\theta_i,E_{-i},N)
=
\left(
\frac{O(e_i+E_{-i})}{N}
\right)^{\theta_i}
(1-e_i)^{1-\theta_i}.
}
\]

The baseline effort decision is

\[
e_i^*
\in
\arg\max_{e\in[0,1]}
U_i(e;\theta_i,E_{-i},N).
\]

The formal specification should define the optimization problem first. The closed-form best response derived in the analytical section may then be proved equivalent where applicable.

This is preferable to making the closed-form expression the primitive definition.

---

# 6. Information Available to an Activated Agent

The baseline is explicitly local and myopic.

When activated, an agent uses information about:

- its current firm's size;
- its current firm's output;
- its own previous effort;
- the firms of agents in its social network.

The agent does **not** search globally over all firms.

The candidate destination set is therefore constructed from:

\[
\{\text{current firm}\}
\cup
\{\text{friends' firms}\}
\cup
\{\text{new singleton startup}\}.
\]

This local candidate set is part of Axtell's bounded-information architecture and must not be replaced by global maximization in the baseline.

---

# 7. Baseline Choice Rule

On activation, agent \(i\) evaluates:

1. staying in its current firm;
2. joining each firm represented among its \(\nu_i\) neighbors;
3. founding a new singleton firm.

For each candidate organizational choice, the agent determines its utility-maximizing effort.

It then chooses the candidate producing the greatest welfare.

Schematically,

\[
(f_i',e_i')
\in
\arg\max_{(f,e)\in\mathcal C_i(x)}
U_i(e;f,x),
\]

where \(\mathcal C_i(x)\) is the locally available candidate set.

The transition can therefore change both

\[
e_i
\]

and

\[
f_i
\]

in one activation.

### Tie-breaking

The paper does not appear to specify a canonical tie-breaking rule in the passages used for this implementation specification.

Therefore tie-breaking must be:

1. explicit;
2. deterministic conditional on a primitive random draw if randomized;
3. represented in the shared Julia/Lean transition semantics;
4. documented as an implementation completion rule rather than attributed to Axtell.

A recommended canonical rule is to include a `tie_break` component in \(\omega\), allowing the transition map to remain deterministic conditional on the full draw.

---

# 8. Effort Optimization: Mathematical Semantics vs Historical Implementation

Axtell's computational implementation performs a line search over feasible effort rather than directly applying the analytical closed-form best response. This was done so that arbitrary preferences could later be substituted.

For our purposes, distinguish:

### Semantic baseline

\[
e_i^*
\in\arg\max_{e\in[0,1]} U_i(e;\cdot).
\]

### Historical numerical implementation

A numerical line search over \([0,1]\).

The project must not claim exact pathwise replication of Axtell's original Macintosh implementation unless the original line-search algorithm, tolerances, floating-point behavior, random generator, and tie behavior are recovered.

Instead we require two notions of fidelity:

```text
axtell_semantic_baseline
axtell_historical_replication
```

The first is mandatory.

The second is optional and requires additional archival implementation details.

The exact sub-model theorem in Lean should target the **semantic baseline defined by this repository**.

---

# 9. Activation Process

Axtell uses asynchronous random activation.

Conceptually each agent has a Poisson clock. In the implementation, agents are selected randomly for activation.

A model period in the base case is defined as

\[
M=1000
\]

agent activations.

Because

\[
A=1000
\]

in the base case, there is an average of one activation per agent per period, but the realized activation counts are heterogeneous.

This must not be replaced by synchronous updating.

The primitive random draw should therefore include at least the activated-agent identifier:

\[
\omega_t=(i_t,\ldots).
\]

At the finest event-time scale, define one transition per activation:

\[
X_{n+1}=T(X_n,\omega_n).
\]

A reported "period" is then an aggregation of \(M\) activation events.

This event-time formulation is strongly preferred for Lean because it makes the transition law unambiguous and avoids mixing model dynamics with reporting intervals.

---

# 10. Initialization

The base case initializes every agent as a singleton entrepreneur:

\[
f_i(0)=i,
\]

so initially there are

\[
A
\]

firms, each of size one.

Thus

\[
N_F(0)=1
\]

for every initial firm.

The baseline initialization procedure must also generate:

- heterogeneous \(\theta_i\);
- fixed social neighbors;
- initial effort values according to an explicitly documented rule.

If the paper does not uniquely specify a required initial effort realization, this must remain an explicit implementation choice rather than being attributed to Axtell.

---

# 11. Firm Birth and Death

Baseline firm birth occurs when an existing agent chooses the startup option.

This creates a **new firm without creating a new agent**.

Baseline firm death occurs when the final member of a firm leaves it.

This distinction is crucial for the Agentic-AI extension:

\[
\boxed{
\text{Axtell startup}
\neq
\text{agent spawning}.
}
\]

Axtell startup changes the partition of a fixed agent population.

Agentic spawning changes the population itself.

These must be separate transition operators and separate feature flags.

---

# 12. Required Baseline State

A minimal semantic state should contain enough information to evaluate the next activation exactly:

\[
X=
(
\theta,
e,
f,
N_{\text{social}},
\mathcal F,
\ldots
).
\]

A possible Julia representation is:

```julia
struct AxtellAgentStatic{T}
    theta::T
    neighbors::Vector{Int}
end

struct AxtellDynamic{T}
    effort::Vector{T}
    firm_of::Vector{Int}
end

struct AxtellParams{T}
    a::T
    b::T
    beta::T
end

struct AxtellState{T}
    dynamic::AxtellDynamic{T}
    # Derived/cached firm information may live here,
    # but must remain consistent with firm_of.
end
```

The actual implementation should prefer compact arrays and canonical identifiers over reproducing Axtell's historical object-oriented pointer structure.

The historical object model is evidence about semantics, not a requirement to reproduce 1990s implementation architecture.

---

# 13. Derived Firm Objects

Firm membership should have a single canonical source of truth.

Recommended:

\[
f:\mathcal A\to\mathcal I_F
\]

is canonical.

Firm member lists, sizes, outputs, mean effort, and related objects are derived views or validated caches.

Required invariants include:

\[
\forall i,\quad i\text{ belongs to exactly one active firm},
\]

\[
N_F=\#\{i:f_i=F\},
\]

\[
E_F=\sum_{i:f_i=F}e_i,
\]

\[
O_F=aE_F+bE_F^\beta.
\]

No empty firm may remain active after an event.

---

# 14. Baseline Transition Kernel

The canonical event-level baseline transition is

\[
T_A:S_A\times\Omega_A\to S_A.
\]

For one activation:

1. select activated agent \(i\);
2. construct its local candidate-firm set;
3. evaluate optimal effort and welfare in its current firm;
4. evaluate optimal effort and welfare in each neighbor's firm;
5. evaluate optimal effort and welfare as a singleton startup;
6. choose the welfare-maximizing alternative;
7. update effort and membership;
8. destroy an origin firm if it becomes empty;
9. update derived firm quantities / caches.

Firm output, income, and welfare statistics may be updated after each event or at reporting boundaries provided the behavioral semantics are identical. Any cached value used for a subsequent decision must correspond to the information timing specified by the baseline.

The implementation must document the exact timing convention.

---

# 15. Randomness Must Be More Explicit Than in the Paper

For reproducibility and Lean correspondence, all stochasticity must be represented by primitive draws.

At minimum:

\[
\omega_n
=
(
i_n,\tau_n
),
\]

where

- \(i_n\): activated agent;
- \(\tau_n\): any tie-breaking randomness.

Initialization randomness is separate:

\[
\omega_0^{init}
=
(
\theta_1,\ldots,\theta_A,
N_1,\ldots,N_A,
\ldots
).
\]

No Julia function inside the deterministic transition layer may call a global RNG.

Required split:

```julia
sample_draw(rng, state, config, params) -> Draw
step(state, draw, config, params) -> State
```

Lean should formalize the same deterministic `step`.

---

# 16. Analytical Results That Should Become Lean Targets

The paper gives analytical structure that can now replace generic theorem placeholders.

## 16.1 Best-response existence

For fixed candidate group composition and other-agent effort, prove existence of an optimal effort:

\[
\exists e_i^*\in[0,1]
\quad
e_i^*\in\arg\max U_i.
\]

Compactness of \([0,1]\) and continuity of utility provide the natural route.

---

## 16.2 Nash effort equilibrium for fixed group composition

For a fixed group, Axtell establishes existence of a Nash equilibrium in effort levels.

For the baseline Cobb-Douglas specification, the best-response function is continuous and decreasing in other-agent effort.

A Lean target should formalize a fixed-group equilibrium theorem.

Do not confuse this with a stationary equilibrium of the full firm-formation process.

---

## 16.3 Inefficiency of Nash effort equilibrium

The paper argues that fixed-group Nash effort equilibria are Pareto dominated by configurations involving greater effort, although those dominating configurations are not individually rational.

This is a useful secondary formalization target after the basic model has stabilized.

---

## 16.4 Stability boundary for sufficiently large groups

Under Axtell's myopic best-response effort dynamics, the fixed-group system has a Jacobian with zero diagonal and non-positive off-diagonal effects.

Axtell shows that sufficiently large groups have dynamically unstable Nash effort equilibria.

The theorem program should include a formal version of:

\[
\exists N_{\max}
\quad
N>N_{\max}
\Rightarrow
\text{local instability}.
\]

This is a particularly attractive Lean theorem because it is closer to the paper's actual analytical contribution than immediately attempting a global stochastic convergence theorem.

A more general appendix result shows that an upper bound on stable group size persists for a class of effort-adjustment functions that are non-increasing in other-agent effort, with strict decrease providing the relevant sufficient condition.

---

# 17. Consequence for the "Convergence Theorem" Program

The phrase **convergence theorem** must now be disambiguated.

Axtell explicitly emphasizes micro-level non-equilibrium dynamics and reports stationary **aggregate distributions**, rather than convergence of individual firms or agents to a static equilibrium.

Therefore there are at least four mathematically distinct targets.

## Target A — Fixed-group effort dynamics

Study convergence or instability of

\[
e(t+1)=BR(e(t))
\]

for fixed membership.

This connects directly to Axtell's Jacobian analysis.

---

## Target B — Finite discretized full model

For

\[
M_A^{(K)}
\]

or a bounded finite agentic extension, prove Markov-chain properties such as:

- existence of stationary distributions;
- communicating-class structure;
- irreducibility under explicit assumptions;
- aperiodicity under explicit assumptions;
- uniqueness of stationary distribution;
- convergence in total variation.

This is the easiest genuine stochastic convergence theorem.

---

## Target C — Faithful continuous-effort Axtell process

Treat the event-level model as a Markov process on a hybrid state space containing:

- continuous effort coordinates;
- discrete partitions / firm memberships.

Potential theorem tools include Feller properties, invariant measures, Harris recurrence, drift/minorization, coupling, or contraction on suitable subspaces.

No such theorem should be presumed in advance.

---

## Target D — Approximation theorem

Relate finite approximations to the faithful process.

For example, seek conditions under which

\[
M_A^{(K)}\Rightarrow M_A
\]

over finite horizons as the effort grid is refined, and subsequently study whether invariant measures satisfy

\[
\pi_K\Rightarrow\pi.
\]

This would connect the tractable Lean finite-state theorem to the economically faithful model.

---

# 18. Aggregate Phenomena the Julia Baseline Must Attempt to Reproduce

The baseline validation suite should not use only firm-size plots.

Axtell reports the emergence of stationary aggregate distributions despite perpetual micro-level adaptation.

The Julia implementation should compute and test at least:

### Firm size

By number of agents:

\[
S_F=|F|.
\]

Target: right-skewed / approximately scaling distribution in the relevant parameter regime.

### Firm output

\[
O_F=aE_F+bE_F^\beta.
\]

### Firm growth rates

The paper reports approximately Laplace / double-exponential log growth rates.

### Size dependence of growth-rate dispersion

The standard deviation of growth rates decreases with firm size.

### Firm lifetimes

Track birth and death times and construct lifetime distributions.

### Aggregate productivity

The paper reports near constant returns at the aggregate level despite increasing returns at the firm-production level.

### Micro diagnostics

Track:

- effort distributions;
- free riders;
- firm life cycles;
- agent job changes / career paths;
- income;
- utility;
- firm composition by \(\theta\).

These are validation diagnostics, not theorem assumptions.

---

# 19. Base-Case Regression Configuration

The repository must provide a named baseline parameter set:

```text
AxtellBaseCase
```

with:

```text
A = 1000
a = 1
b = 1
beta = 2
theta_distribution = Uniform(0, 1)
sharing_rule = equal
neighbors_per_agent = 2
activation = random_asynchronous
activations_per_period = 1000
initial_firms = singleton
```

All agentic extension flags must be `false`.

The base case should be executable with a fixed seed and emit a complete metadata record sufficient to reproduce the run.

---

# 20. Corrected Exact-Recovery Requirement

The extended model should factor conceptually as

\[
T_{\text{ext}}
=
T_{\text{agentic}}\circ T_A
\]

only when such sequential factoring preserves semantics.

More generally, define a common transition function

\[
T_{\phi}.
\]

The required theorem is:

\[
\boxed{
\forall x,\omega,\qquad
T_{\phi_A}(x,\omega)=T_A(x,\omega).
}
\]

Here \(\phi_A\) must imply:

```text
allow_compute = false
allow_spawn = false
allow_termination = false
allow_delegation = false
allow_specialization = false
allow_hierarchy = false
allow_compute_market = false
allow_compute_inheritance = false
allow_agent_mutation = false
```

It must **not** disable any genuine Axtell mechanism:

- effort optimization;
- local social network search;
- movement between firms;
- startup of new firms;
- destruction of empty firms;
- asynchronous activation;
- heterogeneous preferences;
- increasing returns;
- equal sharing.

---

# 21. Agentic-AI Extension Must Preserve Axtell Semantics

The first agentic extension adds compute and spawning without rewriting the baseline variables.

An extended agent may contain

\[
(\theta_i,e_i,f_i;c_i,p_i,\ldots).
\]

The semicolon is conceptual:

- left side = Axtell state;
- right side = extension state.

Compute must initially remain distinct from effort.

Spawning must initially remain distinct from startup.

Thus:

\[
\text{startup}:
A_t\mapsto A_t,
\quad
F_t\mapsto F_t+1,
\]

whereas

\[
\text{spawn}:
A_t\mapsto A_t+1.
\]

This distinction should be reflected in types, functions, tests, and theorem names.

---

# 22. Recommended Lean Module Revision

```text
lean/
  AgenticAxtell/
    Baseline/
      Types.lean
      Production.lean
      Utility.lean
      BestResponse.lean
      CandidateFirms.lean
      Activation.lean
      Transition.lean
      FixedGroupEquilibrium.lean
      Stability.lean

    Approx/
      EffortGrid.lean
      FiniteState.lean
      Markov.lean
      Stationary.lean
      Convergence.lean

    Agentic/
      Compute.lean
      Spawn.lean
      Lineage.lean
      Transition.lean

    Recovery.lean
```

The key architectural separation is:

```text
Baseline ≠ Approx
```

The finite approximation imports the baseline mathematical definitions and discretizes them explicitly.

---

# 23. Recommended Julia Module Revision

```text
julia/
  src/
    AgenticAxtell.jl

    baseline/
      types.jl
      production.jl
      utility.jl
      best_response.jl
      candidates.jl
      transition.jl
      initialization.jl

    approx/
      effort_grid.jl
      enumerate_states.jl
      transition_matrix.jl
      stationary.jl

    agentic/
      compute.jl
      spawn.jl
      lineage.jl
      transition.jl

    simulation/
      draws.jl
      run.jl
      observables.jl

    diagnostics/
      firm_size.jl
      growth.jl
      lifetime.jl
      productivity.jl
```

No Agents.jl or other ABM framework is permitted.

---

# 24. Acceptance Tests Added by This Addendum

## A. Production

For any firm:

```text
output == a * total_effort + b * total_effort^beta
```

within numeric tolerance.

## B. Equal sharing

For a firm of size \(N\):

```text
income[i] == output / N
```

for every member.

## C. Local candidate set

An activated baseline agent may consider only:

```text
current firm
neighbor firms
new singleton firm
```

unless a non-baseline search feature is explicitly enabled.

## D. Fixed population

With spawning disabled:

\[
A_t=A_0
\quad\forall t.
\]

## E. Partition invariant

Every baseline agent belongs to exactly one firm.

## F. No empty firms

After every activation event, every active firm contains at least one agent.

## G. Baseline initialization

`AxtellBaseCase` begins with 1000 singleton firms and 1000 agents.

## H. Asynchronous activation

One event activates one agent. A reporting period aggregates 1000 activation events in the base case.

## I. RNG purity

`step` performs no hidden random draw.

## J. Exact agentic recovery

With all agentic flags disabled, the agentic transition equals the baseline transition for the same state and draw.

## K. Approximation is explicit

No theorem or test may call a discretized effort-grid model simply `"Axtell"`.

Use names such as:

```text
AxtellFiniteApprox
AxtellGridApprox
```

---

# 25. Revised Implementation Milestones

## Milestone 0 — Source-faithful mathematical baseline

Implement and test:

- \(O(E)=aE+bE^\beta\);
- Cobb-Douglas utility;
- equal sharing;
- local social-network candidate firms;
- singleton startup;
- fixed population;
- event-level random asynchronous activation.

Do not implement compute or spawning yet.

---

## Milestone 1 — Julia semantic reproduction

Implement a complete pure-Julia baseline simulation.

Validate qualitative and quantitative diagnostics against the paper where the paper provides enough information.

Document every completion rule not uniquely specified by the paper.

---

## Milestone 2 — Lean baseline definitions

Formalize:

- bounded effort;
- firm partitions;
- production;
- utility;
- candidate actions;
- one-agent transition;
- structural invariants.

---

## Milestone 3 — Analytical Lean theorems

Prioritize:

1. continuity / best-response existence;
2. fixed-group Nash equilibrium existence;
3. selected monotonicity properties of best response;
4. sufficient conditions for instability above a maximum group size.

These are source-grounded theorem targets.

---

## Milestone 4 — Finite approximation

Introduce an explicit effort grid and any other finite approximations needed.

Prove finiteness of the state space.

Construct the exact transition matrix in Julia for small populations and the corresponding Markov kernel in Lean.

---

## Milestone 5 — Finite stochastic convergence

Under explicit assumptions, prove the strongest available results concerning:

- stationary distributions;
- irreducibility;
- aperiodicity;
- uniqueness;
- convergence.

Do not assume irreducibility merely because the state space is finite.

---

## Milestone 6 — Add compute

Add compute as an orthogonal resource while preserving Axtell effort semantics.

---

## Milestone 7 — Add spawning

Add endogenous agent creation and lineage.

Prove exact Axtell recovery under flags before analyzing the new dynamics.

---

# 26. Codex Instruction

Before adding any agentic-AI mechanism, Codex must first implement the Axtell baseline described above and make its tests pass.

Codex should not infer missing historical implementation details.

Whenever the paper underspecifies a computational choice:

1. add a clearly named completion rule;
2. document it in `docs/IMPLEMENTATION_CHOICES.md`;
3. make it explicit in Julia and Lean where it affects semantics;
4. avoid describing that rule as Axtell's unless directly supported by the source.

The first pull request / implementation pass should therefore contain only:

```text
baseline mathematical primitives
baseline state
baseline initialization
baseline activation/candidate choice
pure deterministic transition
explicit RNG draw layer
tests
Lean skeleton for the same definitions
```

No compute, spawning, delegation, hierarchy, specialization, or compute market should be added in the first pass.

---

# 27. Research Principle

Axtell's central result is not that the economy converges to a static allocation.

The model instead combines perpetual local adaptation with stable macro-level statistical regularities.

Our formal program should preserve that distinction.

Accordingly, the project should separately investigate:

\[
\text{microstate convergence},
\]

\[
\text{local equilibrium stability},
\]

\[
\text{existence of invariant distributions},
\]

and

\[
\text{convergence in distribution}.
\]

These are not interchangeable claims.

The long-run objective is to determine which of Axtell's computational observations can be elevated from simulation evidence to mathematical theorem, and then determine how those theorems change once agents can allocate compute and spawn new agents.
