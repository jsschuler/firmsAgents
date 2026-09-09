# Initial theorem roadmap

Implemented in the continuous semantic Lean scaffold:

1. A semantic choice rule must return bounded effort and a local candidate.
2. The all-disabled extended transition reduces to the baseline transition.
3. Any finite draw stream gives pathwise equality between baseline iteration and
   all-disabled extended iteration.
4. Every semantic baseline activation preserves the complete state validity
   predicate.
5. Baseline runs and recovered all-disabled extended runs preserve validity for
   every finite draw stream.
6. Axtell utility is continuous in own effort for valid parameters and bounded
   preferences.
7. A utility-maximizing effort exists on `[0,1]` for every fixed candidate firm
   environment.
8. Every valid activated agent has a feasible, local, firm-ID-bounded choice
   that dominates every feasible effort in every local candidate firm.
9. A noncomputable canonical semantic `ChoiceRule` satisfying all transition
   obligations exists.
10. The exactly maximizing local firm set is finite and nonempty, and a
    draw-indexed noncomputable `ChoiceRule` selects from it while satisfying all
    transition obligations.
11. Fixed-membership effort profiles and Nash equilibrium are defined; a fixed
    point of any simultaneous best-response map is proved to be a Nash
    equilibrium, and equilibrium existence is proved unconditionally for a
    singleton firm.
12. For arbitrary finite fixed groups, a contracting simultaneous best-response
    map is proved to have a Nash equilibrium, synchronous response iteration is
    proved to converge to it, and uniqueness follows when individual best
    responses are unique.
13. A concrete boundary case is discharged for every finite group size: when
    all Cobb-Douglas preference weights satisfy `theta = 0`, zero effort is each
    agent's unique best response, the response map is contracting, and the
    all-zero profile is the unique fixed-group Nash equilibrium.
14. For linear production, the closed-form response candidate
    `max 0 (theta - (1-theta) * othersEffort)` is proved feasible, continuous,
    and decreasing in other-agent effort (strictly so above its zero floor).
    Its finite-profile lift is continuous and preserves feasible profiles.
15. In the interior regime `0 < theta < 1` and
    `(1-theta) * othersEffort < theta`, weighted AM-GM proves that the
    closed-form linear-production candidate globally maximizes the specified
    Cobb-Douglas utility. This is a global argmax theorem, not merely a
    first-order condition.
16. The complementary binding-floor branch is proved: when
    `theta ≤ (1-theta) * othersEffort`, zero effort globally maximizes utility.
    Combining this with the `theta = 0` case yields the complete piecewise
    linear-production best-response theorem for `0 ≤ theta < 1` and
    nonnegative other-agent effort.
17. The scalar theorem is lifted to the feasible finite-profile cube: the
    continuous `linearFixedGroupResponse` preserves feasibility, is a genuine
    simultaneous best-response update there, and every feasible fixed point is
    a fixed-group Nash equilibrium.
18. The positive-weight equality condition for two-factor weighted AM-GM is
    specialized in Lean. In the interior linear-production regime, every
    feasible effort distinct from the closed-form candidate is proved to have
    strictly smaller normalized Cobb-Douglas value.
19. Under strictly positive linear productivity and positive firm size, the
    interior strict inequality is transported through the income scale to
    utility itself. Consequently, every interior best response is uniquely the
    closed-form candidate.
20. The binding-floor strict inequality is proved both below and exactly at its
    threshold. Combining the floor, interior, and `theta = 0` branches proves
    the closed-form linear-production response is the unique best response for
    `0 ≤ theta < 1`, `a > 0`, and positive firm size.
21. For homogeneous interior preferences, the explicit symmetric effort
    `theta / (1 + (1-theta) * (groupSize-1))` is proved feasible, its constant
    profile is proved to be a fixed point of the simultaneous linear response,
    and hence it is a fixed-group Nash equilibrium for every finite group size.
22. The scalar linear response is proved Lipschitz in other-agent effort with
    constant `1-theta` for `theta ≤ 1`. This is the first quantitative input to
    the heterogeneous profile contraction and stability bound.
23. Coworker-effort differences are bounded by `(groupSize-1)` times profile
    sup distance. Consequently, if every `1-theta_i ≤ K`, the simultaneous
    response is Lipschitz with constant `K*(groupSize-1)` and is formally
    contracting whenever that constant is below one.
24. Under that contraction bound, the Banach fixed point is proved
    automatically feasible and hence Nash; synchronous best-response iteration
    converges to it from every profile. With `a > 0` and positive group size,
    scalar response uniqueness proves this Nash equilibrium is unique.
25. On an interior region where no zero-effort clamp binds, the linear-response
    Jacobian is formalized with zero diagonal and nonpositive off-diagonal
    entries. For homogeneous preferences, the all-ones vector has eigenvalue
    `-(1-theta)*(groupSize-1)`, proving linear instability whenever
    `1 < (1-theta)*(groupSize-1)`.
26. The proposed Jacobian is connected to the actual clamped dynamics: the
    positive-response region is open, the clamped response equals its affine
    interior formula throughout that neighborhood, and every interior
    perturbation satisfies the exact increment identity
    `BR(profile+h)-BR(profile) = Jacobian.mulVec h` while both points remain in
    the region.
27. Heterogeneous spectral analysis begins with the exact row-action identity
    `(Jv)_i = -(1-theta_i)*(sum_j v_j-v_i)`. Every real eigenpair satisfies the
    resulting coordinate equation; for zero-sum modes, any nonzero coordinate
    forces the eigenvalue to equal that coordinate's `1-theta_i`.
28. For aggregate modes with `sum_i v_i ≠ 0`, and away from poles
    `lambda = 1-theta_i`, summing the coordinate equations yields the exact
    heterogeneous secular equation
    `sum_i (-(1-theta_i))/(lambda-(1-theta_i)) = 1`.
29. Aggregate eigenvalues are bounded above by any common bound on
    `1-theta_i`. For a negative aggregate mode, the heterogeneous threshold
    `sum_i (1-theta_i)/(1+(1-theta_i)) > 1` forces `lambda < -1` and therefore
    supplies a formal linear-instability certificate.
30. The secular implication is reversed: every real root away from the poles
    explicitly generates a nonzero aggregate eigenvector normalized to sum to
    one. A negative root plus the heterogeneous threshold therefore yields
    instability without separately assuming an eigenpair.
31. The heterogeneous secular function is proved continuous on the entire
    negative half-line when `theta_i ≤ 1`. An intermediate-value theorem now
    produces a negative secular root from any ordered negative interval whose
    endpoint values bracket one.
32. The endpoint assumptions are discharged from the heterogeneous threshold
    itself. The coefficient sum exceeds one; at its negative, the secular
    function is at most one, while at `lambda = -1` it exceeds one. The
    resulting negative root generates an aggregate eigenvector with eigenvalue
    below `-1`, so the threshold alone formally proves linear instability.
33. The nonlinear branch now has its foundational production lemmas. For
    nonnegative effort and coefficients, `aE+bE^beta` is nonnegative and
    monotone; if `a>0`, it is strictly increasing. Valid parameters discharge
    the weak-monotonicity assumptions automatically.
34. Nonlinear interior calculus is formalized. Marginal production is proved
    to be the derivative of `aE+bE^beta` at positive total effort, the complete
    Cobb-Douglas marginal-utility expression is proved to be the effort
    derivative, and every interior global best response satisfies the resulting
    first-order condition.
35. The nonlinear condition is normalized through log utility. Its derivative
    is proved to equal marginal output divided by output, weighted against the
    leisure loss. Vanishing of this derivative is equivalent to the scale-free
    score `theta*(1-e)*O'(e+E_other) - (1-theta)*O(e+E_other) = 0`; for the
    Axtell exponent `beta=2`, that score is reduced to an explicit quadratic.
36. Positive Cobb-Douglas utility is connected rigorously to the log objective.
    On a positivity-preserving neighborhood, an interior global best response
    is a local maximizer of log utility. Fermat's theorem therefore forces its
    normalized nonlinear score to zero, and the Axtell `beta=2` specialization
    forces the corresponding explicit quadratic equation to zero.
37. The quadratic score's exact finite-difference identity is proved. It is
    strictly decreasing on nonnegative own effort under the transparent
    sufficient condition `2*b*(theta-E_other) < a`; under that condition there
    is at most one positive interior best response. Its value at effort one is
    also reduced to the negative leisure-weighted output term. Importantly,
    valid parameters alone do not imply the decreasing-score condition.
38. The upper effort boundary is eliminated for the nonlinear model: when
    `a>0`, coworkers' effort is nonnegative, firm size is positive, and
    `theta<1`, full effort has zero utility while effort one-half has positive
    utility. Thus every best response is strictly below one. The exact
    quadratic score at effort zero is also formalized for the remaining
    zero-versus-interior boundary comparison.
39. On the positive interior, marginal log utility is proved equal to the
    normalized score divided by a strictly positive denominator, so their signs
    agree. Under the decreasing-score condition, log utility is strictly
    increasing from zero effort to any positive score root. With positive
    coworker effort this excludes zero as a competing optimum; combined with
    the upper-boundary result, any positive interior best response is therefore
    unique on the full feasible interval.
40. The quadratic score is proved continuous as a function of own effort.
    Strictly positive score at zero and strictly negative score at one therefore
    produce, by the intermediate value theorem, a score root strictly inside
    `(0,1)`. This supplies existence of the unique critical-point candidate
    whenever the endpoint signs and decreasing-score restriction hold.
41. The score sign is transported through marginal log utility on both sides
    of the root. Log utility is strictly increasing before the root and
    strictly decreasing after it, so the root is a global best response on
    `[0,1]`. Endpoint crossing, positive coworker effort, and the
    decreasing-score condition now yield existence and uniqueness of the full
    nonlinear `beta=2` best response.
42. For zero coworker effort and `0<theta<1`, the quadratic endpoint signs are
    automatic from `a>0` and `b≥0`, so an interior score root exists. The
    increasing-log-utility theorem is generalized to intervals with any
    positive lower endpoint, allowing the singular zero-income endpoint to be
    handled separately.
43. The zero-coworker branch is completed under `2*b*theta<a`. Zero effort has
    zero utility, the positive score root has positive utility, and log utility
    rises before and falls after that root. The root is therefore a global best
    response, and every other best response is proved equal to it. Thus the
    quadratic model has a full existence-and-uniqueness theorem in this case.
44. The initial-slope restriction is shown to be stronger than necessary when
    the score at zero is positive. The downward quadratic has at most one
    positive root; relative to that root its score is strictly positive before
    and strictly negative afterward, even if it initially rises. These facts
    prepare removal of `2*b*theta<a` from the zero-coworker theorem.
45. The stronger root signs are transported through marginal log utility.
    Consequently, for zero coworker effort the quadratic model has a unique
    global best response for every `a>0`, `b≥0`, and `0<theta<1`, with no
    `2*b*theta<a` restriction. This includes parameter values where the score
    initially rises because of strong cooperative returns.
46. With positive coworker effort, the same positive-intercept argument now
    proves global optimality without a decreasing-initial-slope assumption.
    If the quadratic score is positive at zero and an interior root exists,
    log utility rises up to that root and falls afterward, so the root is a
    global best response even when cooperative returns make the score rise
    initially.
47. Full-domain uniqueness is likewise freed from the initial-slope condition.
    Strict growth from zero excludes the lower boundary, positive-root
    uniqueness identifies every interior best response with the constructed
    root, and full effort is already excluded. Thus positive score at zero and
    negative score at one yield a unique global quadratic best response for
    positive coworker effort.
48. The endpoint assumptions are reduced to primitive parameters. Under
    `a>0`, `b≥0`, nonnegative coworker effort, and `theta<1`, the score at full
    effort is automatically negative. The positive score-at-zero condition is
    exactly the work-incentive inequality and, for positive coworker effort,
    is equivalent to `theta > O(E_other)/(O(E_other)+O'(E_other))`. This single
    explicit inequality now yields unique global best-response existence.
49. The quadratic participation threshold is proved to lie strictly between
    zero and one for positive coworker effort. It is also strictly increasing
    in coworker effort when `a>0` and `b≥0`: greater output supplied by others
    formally raises the preference weight required to make positive own effort
    locally attractive.
50. Comparative statics of the positive root begin with an exact finite-change
    identity in coworker effort. It separates the cooperative marginal-product
    gain from the free-riding loss. When the latter dominates at the first
    root, increasing coworker effort strictly lowers the positive best-response
    root. Valid parameters alone do not force this cross-effect sign.
51. A root-independent sufficient condition is proved:
    `2*b*theta < (1-theta)*a`. It uniformly makes the free-riding effect exceed
    the cooperative marginal-product effect throughout feasible own effort and
    nonnegative coworker effort. Under this parameter bound, increasing
    coworker effort strictly lowers the positive quadratic best-response root.
52. The complementary non-participation branch is proved. With positive
    coworker effort, decreasing quadratic score, and nonpositive score at zero,
    log utility is strictly decreasing away from zero and zero effort is a
    global best response. This completes the two branches needed for a total
    piecewise response selector under the uniform cross-effect bound.
53. A canonical scalar nonlinear best-response selector is defined from the
    compactness existence theorem and proved correct. Multiple dispatch over
    finite agents lifts it to a simultaneous fixed-group response map, which is
    proved pointwise best responding. Every fixed point of this nonlinear map
    is therefore a fixed-group Nash equilibrium. A generic uniqueness lemma
    identifies the selector with any independently characterized unique best
    response.
54. The non-participation branch is strengthened from optimality to uniqueness:
    under decreasing score and nonpositive score at zero, every best response
    equals zero. Consequently, the canonical scalar selector is formally equal
    to zero in this branch, removing arbitrary-choice ambiguity.
55. The participation branch is made equally explicit. A canonical interior
    quadratic score root is selected from endpoint crossing and proved to lie
    in `(0,1)` and solve the score equation. Under the positive-participation
    hypotheses, the general compactness-based nonlinear selector is proved
    equal to this canonical root.
56. Approach to the participation threshold is quantified. For any quadratic
    score root in the decreasing-score regime, the root is bounded above by
    the score-at-zero surplus divided by the positive initial-slope margin.
    Equivalently, if that surplus is below `epsilon` times the margin, the root
    is below `epsilon`. Thus the positive branch converges to zero whenever its
    participation surplus vanishes while the slope margin stays positive.
57. The quantitative estimate is lifted to the canonical nonlinear selector.
    On the participation branch the selected response inherits the positive
    root's epsilon bound. A unified theorem then covers both sides: under the
    decreasing-score hypotheses and endpoint crossing, whenever the
    score-at-zero surplus is below `epsilon` times the slope margin, the
    selected response belongs to `[0, epsilon)`. The non-participation side is
    discharged by its exact-zero characterization.
58. The selector is packaged as a proof-independent function on the feasible
    preference subtype `[0,1]`. The quadratic score is proved to equal zero
    exactly at the explicit participation threshold, and the packaged selector
    is consequently proved to take value zero there under the local
    decreasing-score condition. This identifies the precise base point and
    value for the forthcoming `ContinuousAt` theorem.
59. Threshold continuity is completed. Continuity of the score-at-zero and
    slope-margin functions supplies a common neighborhood in feasible-theta
    space where the margin remains positive and the score surplus is small.
    The unified selector estimate then proves the metric epsilon-delta
    criterion, yielding `ContinuousAt` of the canonical nonlinear response at
    the participation threshold under the local decreasing-score condition.
60. Positive-branch preference comparative statics are formalized. An exact
    finite-change identity shows that increasing `theta` raises the score by
    the preference change times leisure-weighted marginal production plus
    output. This coefficient is strictly positive at an interior root, so the
    unique positive quadratic best-response root is strictly increasing in
    `theta`. This order result supplies one side of the positive-branch
    continuity argument.
61. Positive-root stability is quantified. For increasing `theta`, the root
    displacement times the terminal own-effort slope margin is bounded by the
    direct score displacement at the initial root. This product inequality is
    algebraic and needs no sign assumption on the margin. When the margin is
    positive, division yields an explicit one-sided local Lipschitz bound for
    the positive response root.
62. The stability estimate is symmetrized across arbitrary pairs of preference
    weights. The absolute root displacement times the slope margin at the
    larger `theta` is bounded by the absolute preference displacement times
    the larger endpoint score-sensitivity coefficient. A positive margin again
    gives the corresponding divided two-sided Lipschitz bound. Equal and both
    strict orderings are covered in one theorem.
63. The symmetric Lipschitz estimate is lifted from abstract score roots to the
    canonical nonlinear best-response selector. Endpoint crossing identifies
    each selected response with its canonical positive root; the root
    specifications then discharge all interiority and score-equation premises.
    The resulting bound now applies directly to the response function used by
    the fixed-group model.
64. The remaining root-dependent score-sensitivity coefficient is uniformly
    bounded on feasible effort. Marginal production and output are each
    bounded by their values at maximal total effort `1 + othersEffort`, while
    the leisure multiplier is at most one. The resulting primitive-parameter
    bound is independent of the chosen response root.
65. A named primitive sensitivity constant is introduced and substituted into
    the symmetric root-stability inequality. The resulting bound controls the
    absolute response-root displacement by absolute preference displacement
    times this fixed constant, divided by the local slope margin. Its
    right-hand side is now completely independent of both roots.
66. The primitive root-independent estimate is lifted to the canonical
    nonlinear selector, so selected best-response differences are controlled
    directly without exposing the auxiliary canonical roots.
67. Continuity on the strict positive-participation branch is completed. A
    common neighborhood preserves positive score at zero, `theta<1`, and a
    positive slope margin. The primitive selector estimate and its fixed
    sensitivity constant then verify the metric epsilon-delta criterion at
    every such preference weight.
68. Continuity on the strict non-participation branch is completed. Strict
    negativity of the score at zero and positivity of the slope margin persist
    in a common neighborhood; throughout that neighborhood the uniqueness
    theorem makes the canonical selector exactly zero. The response is
    therefore locally constant and continuous.
69. The branchwise continuity results are unified. Zero score at zero effort
    is first proved equivalent to equality with the explicit participation
    threshold. Trichotomy of the score then dispatches strict negativity to
    local zero constancy, equality to threshold continuity, and strict
    positivity to positive-root continuity. Thus the canonical feasible-theta
    selector is continuous at every `theta<1` with positive own-effort slope
    margin.
70. The nonlinear fixed-group existence extension begins with quantitative
    coworker-effort root stability. Under the uniform negative cross-effect
    condition, increasing coworker effort lowers the positive response root;
    its displacement times the terminal own-effort slope margin is bounded by
    the direct coworker-score displacement at the initial root.
71. Coworker-effort root stability is symmetrized. A named cross-sensitivity
    coefficient expresses the magnitude of the negative coworker score effect;
    arbitrary pairs of positive-root environments satisfy an absolute
    displacement product bound using the larger coworker effort. When the
    corresponding slope margin is positive, division gives a two-sided local
    Lipschitz estimate.
72. The coworker cross-sensitivity is uniformly bounded on bounded environments.
    If both coworker totals are at most a common cap and own effort is feasible,
    the root-dependent coefficient is bounded by a positive expression using
    only the cap and primitive parameters. Substitution gives a symmetric
    root-independent Lipschitz estimate suitable for fixed groups, where the
    natural cap is group size minus one.
73. The bounded coworker-effort Lipschitz estimate is lifted to the canonical
    nonlinear selector. For any two positive coworker environments below a
    common cap, selected best-response displacement is bounded directly by
    coworker-effort displacement, the cap-dependent primitive sensitivity
    constant, and the positive slope margin.
74. The canonical selector is packaged as a scalar function of coworker effort,
    and continuity is proved at every strictly positive environment on the
    positive-participation branch. A common neighborhood preserves positive
    coworker effort, positive score, a local effort cap, and the slope margin;
    the bounded selector estimate then supplies the epsilon-delta proof.
75. Coworker-effort continuity on the strict non-participation branch is
    completed. Strict score negativity persists locally, and the uniform
    cross-effect condition supplies the decreasing-score premise at every
    nearby positive environment. The unique selected response is therefore
    locally constant at zero.
76. Coworker-effort continuity at an exact participation boundary is completed.
    The reference selector is exactly zero. Nearby nonpositive-score
    environments retain the zero response, while positive-score environments
    have a positive root bounded by the score surplus divided by the slope
    margin. Continuity follows uniformly across both sides of the boundary.
77. The singular zero-coworker environment is given its own canonical positive
    quadratic root. Its interiority and score equation follow from the
    zero-coworker existence theorem, and zero-coworker best-response uniqueness
    identifies the general nonlinear selector with this root. This supplies
    the boundary data needed for one-sided coworker-effort continuity.
78. The bounded coworker-effort stability estimate is extended across the
    singular boundary pair from zero coworkers to a positive environment.
    Rewriting both canonical selections to their respective roots yields a
    root-independent displacement bound with the same cap-dependent
    cross-sensitivity constant and positive slope margin.
79. One-sided continuity at zero coworker effort is completed on the
    economically meaningful nonnegative domain. Positive preference makes the
    zero-environment score strictly positive; participation persists locally,
    the slope margin weakly improves as coworker effort rises, and the
    zero-to-positive selector bound verifies the subtype epsilon-delta
    criterion.
80. Scalar coworker-effort continuity is unified on the full nonnegative
    domain. The zero environment uses one-sided continuity; every positive
    environment is split by score trichotomy into strict non-participation,
    exact participation, or strict participation. Restricting the real-domain
    branch theorems to the subtype yields a globally continuous canonical
    response function under the uniform negative cross-effect condition.
81. Scalar continuity is lifted to a simultaneous self-map of the feasible
    fixed-group effort cube. The coworker sum for each agent is defined as a
    continuous nonnegative subtype-valued map. Coordinatewise composition with
    the scalar response proves continuity of the full cube-valued nonlinear
    best-response map, whose range remains feasible by construction.
82. The remaining topological dependency is isolated as
    `FeasibleCubeFixedPointPrinciple`, Brouwer's fixed-point principle
    specialized to the finite feasible-profile cube. Assuming precisely this
    principle, the continuous nonlinear cube response has a fixed point; after
    forgetting subtype bounds, coordinatewise selector optimality proves that
    profile is a fixed-group Nash equilibrium.
83. The finite-cube principle is discharged using the published
    Scarf--Brouwer Lean development. The project is upgraded to Lean/Mathlib
    4.29 and pins `LionSR/Brouwer`; the feasible effort cube is conjugated by a
    coordinatewise homeomorphism to a finite product of two-coordinate
    simplices. `Brouwer_Product` therefore supplies a fixed point, yielding the
    unconditional theorem `exists_nonlinearFixedGroupNash` for every nonempty
    finite group under the established beta-two decreasing-score assumptions.
84. Milestone 4 begins with a cross-language finite effort grid. Lean represents
    a positive resolution `K` and its `K+1` levels dependently, proves every
    decoded real effort lies in `[0,1]`, and identifies the exact zero and one
    endpoints. Julia mirrors the semantics with parametric
    `EffortGrid{K}`/`EffortLevel{K}` types and multiple-dispatch decoding, with
    tests covering enumeration, endpoint values, and invalid construction.
85. The finite approximation gains bounded agent and firm identifiers and a
    bounded global-state carrier. Active agents have grid-valued preferences
    and efforts, bounded firm IDs, and finite neighbor sets; optional agent
    slots and next-ID fields leave room for later termination and spawning.
    Lean derives `Fintype` instances and proves both the entire carrier and
    every validity-restricted state subset finite. Julia mirrors these types
    parametrically and tests bounds and construction.
86. Finite candidate actions, bounded draws, and a deterministic transition
    boundary are added in both languages. Choice policy remains an explicit
    argument: missing activations and rejected choices are identity steps,
    while accepted actions atomically replace effort and firm membership,
    recompute the active-firm set, and advance or exhaust the bounded startup
    identifier. Lean proves the two identity branches; Julia tests startup,
    membership, effort, rejection, and draw bounds.
87. Finite partition validity is now explicit in both languages: the recorded
    active-firm set must equal exactly the firms occupied by active agent
    slots. Lean proves that every active agent's firm is recorded and that the
    deterministic finite transition preserves this invariant for sound choice
    rules (in fact, structurally for any rule), because accepted actions
    recompute the set and identity branches retain the input state. Julia
    mirrors the predicate and tests valid, transitioned, and malformed states.
88. One-step finite stochastic dynamics are now constructed in both languages.
    Julia enumerates bounded draws and pushes an exact supplied draw
    distribution through the deterministic transition to form a rational
    row-stochastic matrix, rejecting duplicate or non-closed state lists and
    non-probability weights. Lean pushes the uniform finite-draw `PMF` through
    the same transition; normalization is carried by the `PMF` type, and a
    support theorem proves that sound rules cannot leave partition-valid
    states. A two-state Julia example checks the matrix and exact row sums.
89. Finite graph validity now requires every neighbor to occupy an active agent
    slot and forbids self-neighbors. Lean proves agent replacement preserves
    the occupied-slot set when an active slot is replaced, then uses unchanged
    neighbor lists to prove both deterministic transitions and every state in
    the stochastic kernel's support remain graph-valid. Julia mirrors the
    predicate and tests preservation, self-neighbor rejection, and rejection
    of neighbors whose slots are empty.
90. The one-step cross-language probability contract is explicit and tested.
    A shared two-state fixture records integer transition counts with a common
    denominator; Julia reads it and checks the exact rational matrix rows
    `[1/2, 1/2]` and `[0, 1]`. Lean proves the general kernel-entry formula:
    the probability of a successor is exactly the sum of one uniform weight
    for each finite draw whose deterministic transition produces it. This
    identifies Julia's count aggregation with the Lean `PMF` construction
    without relying on floating-point comparison.
91. Multi-step finite dynamics are now defined. Julia propagates exact row
    distributions through a transition matrix for any nonnegative horizon and
    checks stationarity by exact equality; the shared two-state example gives
    `[1/4, 3/4]` after two steps and verifies its absorbing distribution.
    Lean iterates the one-step kernel with `PMF.bind` and proves by induction
    that every state in every finite-horizon support preserves both partition
    validity and graph validity (the former under the established soundness
    interface).
92. The finite approximation is connected to firm-size tail diagnostics.
    Julia maps any exact state distribution (including a stationary one) to
    expected firm counts by size and a firm-weighted complementary cumulative
    distribution, with exact rational arithmetic. Lean defines bounded firm
    size and the corresponding upper-tail event, proves every size is at most
    the number of agent slots, and proves tail events above that bound are
    impossible. This deliberately separates finite CCDF evidence from an
    asymptotic power-law claim; the existing multi-seed baseline experiments
    remain the evidence for heavy tails in the full simulation.
93. Stationarity and the fixed-population variance limitation are formalized.
    A stationary finite distribution is defined as a `PMF` fixed by one-step
    kernel evolution, and Lean proves such a distribution remains fixed at
    every finite horizon. For every state distribution—not merely stationary
    ones—and every bounded firm ID, Lean proves the firm's size variance is at
    most `(agentSlots / 2)^2`. Thus infinite variance is formally impossible
    at fixed population size; any variance-divergence theorem must concern a
    family of models whose population bound tends to infinity.
94. Stationary-vector existence is proved for every nonempty finite
    row-stochastic real matrix. Matrix action is packaged as a continuous
    self-map of the standard probability simplex; Mathlib's stochastic-matrix
    lemmas prove the map preserves nonnegativity and total mass, and the
    project's Brouwer dependency supplies a fixed point. The remaining bridge
    to the model-specific theorem is to express `finiteKernel` as such a real
    matrix and convert the fixed simplex vector back to a `PMF`.
95. The stationary-existence bridge is closed for the actual finite model.
    Lean converts every `finiteKernel` row to real probabilities and proves the
    resulting matrix row-stochastic from `PMF.tsum_coe`. The Brouwer stationary
    vector theorem is transported from `Fin n` to an arbitrary nonempty finite
    state type, converted back through `ENNReal.ofReal` and `PMF.ofFintype`, and
    proved invariant using the exact `PMF.bind` formula. Consequently every
    bounded finite-model kernel with a nonempty draw space has at least one
    `IsStationaryFiniteDistribution` witness.
96. Finite-chain structure is now formalized directly on `finiteKernel` support.
    Positive-probability edges generate reflexive-transitive reachability;
    mutual reachability defines communication, and closed communicating
    classes combine nonemptiness, pairwise communication, and transition
    closure. Absorbing states are point-mass kernel rows, irreducibility means
    universal reachability, and aperiodicity is stated by eventual availability
    of every sufficiently large return time. Lean proves the basic reachability
    and communication laws and that every absorbing state forms a singleton
    closed communicating class.
97. Julia now computes the corresponding chain structure from exact transition
    matrices: positive adjacency, reflexive-transitive reachability,
    communicating classes, closed classes, absorbing states, irreducibility,
    graph periods, and aperiodicity. The shared two-state fixture has two
    communicating classes, one closed absorbing class, is not irreducible, and
    is aperiodic; a separate deterministic two-cycle is correctly classified
    as irreducible with period two. These routines provide the executable
    classification layer needed before asserting uniqueness or convergence for
    larger finite Axtell kernels.
98. A first economically meaningful finite kernel is constructed and exactly
    classified in Julia. A grid-dispatched `FiniteBestResponseRule` maximizes
    the baseline utility over grid efforts and the current, neighbor, and
    startup firms; reachable-state discovery constructs the smallest
    transition-closed enumeration from the initial state. For two neighboring
    agents on a three-level effort grid, the reachable kernel has three states
    and matrix `[[0,1/2,1/2],[0,1,0],[0,0,1]]`: the separated initial state is
    transient, the two possible consolidated firms are absorbing closed
    classes, and the initialized limiting distribution is their equal mixture.
    Hence this example is neither irreducible nor uniquely stationary, while
    both terminal outcomes have one firm of size two.
99. The economic enumeration is extended to three mutually neighboring agents.
    Exact reachable-state closure contains 85 states, 55 communicating classes,
    and 12 singleton absorbing closed classes. Solving the rational Dirichlet
    system gives exact absorption probabilities from the initialized state;
    they sum to one and are regression-tested. Every absorbing class has the
    same unlabeled firm-size composition `[3]`, so label and effort histories
    create stationary nonuniqueness here without stationary firm-size
    variance. This rules out three homogeneous fully connected agents as the
    desired minimal example of competing terminal size compositions.
100. A four-agent heterogeneous directed-network example supplies the first
    exact mixture over distinct terminal firm-size compositions at the
    baseline increasing-returns exponent `b = 1`. On the three-level effort
    grid, with preference-grid indices `[2,1,2,2]` and neighbor lists
    `[[2],[1],[4],[1,3]]`, the reachable kernel has 120 states, 108
    communicating classes, and nine singleton absorbing closed classes. Six
    terminal states have composition `[2,2]` and three have `[4]`. An
    arbitrary-precision rational Dirichlet solve gives initialized absorption
    masses `192865369/301644000` and `108778631/301644000`, respectively. Thus
    the nonlinear finite economic rule generates genuine stationary firm-size
    uncertainty, not merely label-level stationary nonuniqueness. This remains
    a small heterogeneous-network example, not a heavy-tail theorem.
101. Population scaling is now measured directly in the continuous baseline.
    A threaded reproducible study compares populations 100, 250, 500, and
    1,000 over five seeds, 40 periods, and a 10-period burn-in. Median
    firm-weighted size variance rises from 9.47 to 13.45, but the median second
    moment nearly levels from 16.86 to 20.00 and median maximum-firm share
    falls from 0.120 to 0.036; median rank-size slopes remain near -1.6. This
    supports population-robust right-skew at the tested horizons, but it is not
    evidence for unbounded variance. The script and seed-level CSV make a
    larger, longer convergence study the next empirical step.
102. Horizon scaling now separates slow time convergence from population size.
    Five `N = 1000` trajectories are simulated once through 80 periods, with
    nested measurements at periods 20, 40, and 80 over each horizon's trailing
    half. Median second moments are 22.10, 18.77, and 23.03, while median
    maximum-firm shares are 0.034, 0.036, and 0.048. The lack of monotone moment
    growth weakens the claim that the 40-period scaling experiment merely
    missed rapid divergence. It does not rule out slower asymptotic divergence;
    distinguishing that requires uncertainty-aware tail-index or truncated-
    moment analysis rather than extrapolating these three medians.
103. Tail-index and truncated-moment diagnostics now use independent seeds as
    the uncertainty unit. For ten `N = 1000` baseline runs, median Hill indices
    at upper-tail fractions 5%, 10%, and 20% are 2.003, 1.766, and 1.413; the
    corresponding seed-bootstrap interval at 5% is `[1.782, 2.327]` and crosses
    the infinite-variance boundary. This pronounced threshold sensitivity does
    not identify a stable Pareto exponent. Median truncated second moments at
    cutoffs 5, 10, 20, 40, and 80 are 6.48, 10.61, 15.15, 19.34, and 21.37,
    with shrinking increments. Current simulation evidence establishes a
    persistent heavy/right tail but neither exact Pareto form nor unbounded
    variance.
104. A larger and longer baseline experiment tests the scale objection
    directly. Three independent `N = 2000` trajectories run for 200 periods,
    or 400,000 activations each. Across nested horizons 50, 100, and 200,
    median second moments are 21.28, 22.59, and 23.14; median terminal maximum
    shares fall from 0.025 to 0.0175, and median rank-size slopes stay near
    -1.59. Period-200 terminal maxima are only 38, 33, and 35. This is stronger
    evidence for a stable finite-scale heavy tail than the shorter experiments,
    though it remains simulation evidence rather than an asymptotic proof.
105. Cross-population tail scaling now uses quantities that are not neutralized
    by division by the finite population bound. Across matched seeds and
    populations 100 through 1,000, the median log-log exponent of terminal
    maximum over median firm size is 0.784, though its five-seed bootstrap
    interval includes zero. Growing-cutoff second moments provide stronger
    evidence: cutoffs `sqrt(N)` and `N/10` yield median exponents 0.217 and
    0.291 with seed-bootstrap intervals `[0.121,0.385]` and `[0.129,0.505]`.
    Thus scale-dependent moment growth is present over the measured decade.
    Whether it persists as `N` tends to infinity remains unresolved.
106. Finite-sample normalized Gini coefficients now complement extreme and
    moment scaling. The implementation applies the `m/(m-1)` correction so
    maximal inequality among `m` active firms equals one, computes Gini per
    retained period, and averages periods equally within seeds. Median values
    for populations 100, 250, 500, and 1,000 are 0.464, 0.474, 0.472, and
    0.469. Inequality in the distribution's body is therefore scale-stable
    over the measured decade even as growing-cutoff moments increase.
107. Replication requirements for mean firm size are now estimated from 30
    independent seeds at each of four population scales. The period-balanced
    mean estimates at 30 replications lie between 2.622 and 2.665. Persistent
    approximate-95% relative half-width below 5% is reached at 21, 7, 5, and 4
    replications for populations 100, 250, 500, and 1,000. The 2% target is
    reached within 30 runs only at populations 500 and 1,000, requiring 27 and
    20 replications; no population reaches 1%. Mean behavior self-averages with
    population considerably faster than extreme-tail behavior.
108. Long-time drift is checked over 5,000 periods for one `N = 100` baseline
    trajectory, totaling 500,000 activations. Trailing 100-period mean firm
    size stays between 2.85 and 2.99 from period 100 onward, normalized Gini
    between 0.485 and 0.514, and second moment between 24.75 and 31.82 at the
    reported checkpoints. At period 5,000 these values are 2.881, 0.501, and
    26.43. No sustained temporal drift is visible at this scale, although a
    single path cannot establish stationarity or rare-event frequencies.

The heterogeneous interior linear-response spectral argument is now complete.
The preference-parameter continuity program is complete. Nonlinear
fixed-group Nash existence is now unconditional within the established
beta-two decreasing-score regime: continuity, feasibility, finite-cube
Brouwer, and the fixed-point-to-Nash translation are all formalized. Work now
targets the explicitly separate finite approximation. Its bounded global state
space is now proved finite, its deterministic draw-indexed transition and
one-step stochastic kernel are defined, graph and partition validity are
preserved at arbitrary finite horizons, and exact probability aggregation is
aligned across languages. Finite stationary distributions feed exact
firm-size tail observables. The finite-approximation milestone is complete. Any
unconditional continuity or decreasing-response claim outside the currently
covered regime requires extra parameter restrictions or a separate argument,
because increasing returns can make the quadratic score initially rise.
Exact cross-language numerical tie equivalence is not claimed: Julia
uses a tolerance and candidate-list order, while the semantic Lean layer uses
exact real maximizers and finite-set enumeration. Finite-state results belong
only to an explicitly named approximation layer.
