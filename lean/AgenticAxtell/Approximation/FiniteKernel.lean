import AgenticAxtell.Approximation.FiniteTransition
import Mathlib.Probability.Distributions.Uniform

namespace AgenticAxtell.Approximation

open scoped ENNReal

/-- The finite stochastic kernel obtained by drawing uniformly and pushing the
draw through the deterministic transition. As a `PMF`, every row is normalized
by construction. -/
noncomputable def finiteKernel {grid : EffortGrid} {bounds : StateBounds}
    {tieSlots : Nat} [Nonempty (FiniteDraw bounds tieSlots)]
    (choose : FiniteChoiceRule grid bounds tieSlots)
    (state : FiniteModelState grid bounds) :
    PMF (FiniteModelState grid bounds) :=
  (PMF.uniformOfFintype (FiniteDraw bounds tieSlots)).map
    (finiteTransition choose state)

/-- Cross-language probability contract: a kernel entry is the finite sum of
one uniform weight for every draw producing the requested successor. Julia's
exact transition matrix implements this same aggregation. -/
theorem finiteKernel_apply {grid : EffortGrid} {bounds : StateBounds}
    {tieSlots : Nat} [Nonempty (FiniteDraw bounds tieSlots)]
    (choose : FiniteChoiceRule grid bounds tieSlots)
    (state next : FiniteModelState grid bounds) :
    finiteKernel choose state next =
      ∑ draw : FiniteDraw bounds tieSlots,
        if next = finiteTransition choose state draw
        then (Fintype.card (FiniteDraw bounds tieSlots) : ℝ≥0∞)⁻¹ else 0 := by
  simp [finiteKernel, PMF.map_apply]

/-- A sound choice rule sends every valid input state only to valid states in
the support of its one-step stochastic kernel. -/
theorem finiteKernel_preserves_valid {grid : EffortGrid} {bounds : StateBounds}
    {tieSlots : Nat} [Nonempty (FiniteDraw bounds tieSlots)]
    (choose : FiniteChoiceRule grid bounds tieSlots)
    (chooseSound : IsSoundFiniteChoiceRule choose)
    (state : FiniteModelState grid bounds) (stateValid : FiniteValid state)
    {next : FiniteModelState grid bounds}
    (nextSupport : next ∈ (finiteKernel choose state).support) :
    FiniteValid next := by
  rcases (PMF.mem_support_map_iff _ _ _).mp nextSupport with ⟨draw, _, rfl⟩
  exact finiteTransition_valid choose chooseSound state draw stateValid

theorem finiteKernel_preserves_graphValid {grid : EffortGrid} {bounds : StateBounds}
    {tieSlots : Nat} [Nonempty (FiniteDraw bounds tieSlots)]
    (choose : FiniteChoiceRule grid bounds tieSlots)
    (state : FiniteModelState grid bounds) (stateGraphValid : FiniteGraphValid state)
    {next : FiniteModelState grid bounds}
    (nextSupport : next ∈ (finiteKernel choose state).support) :
    FiniteGraphValid next := by
  rcases (PMF.mem_support_map_iff _ _ _).mp nextSupport with ⟨draw, _, rfl⟩
  exact finiteTransition_graphValid choose state draw stateGraphValid

end AgenticAxtell.Approximation
