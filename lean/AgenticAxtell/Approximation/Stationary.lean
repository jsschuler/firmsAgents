import AgenticAxtell.Approximation.FiniteObservables
import Mathlib.Probability.Moments.Variance
import Mathlib.LinearAlgebra.Matrix.Stochastic
import Gametheory.Brouwer

namespace AgenticAxtell.Approximation

open Matrix
open scoped ENNReal

/-- A row-stochastic matrix acts on probability row vectors and remains in the
standard simplex. -/
noncomputable def stochasticSimplexMap {n : ℕ+} (matrix : Matrix (Fin n) (Fin n) ℝ)
    (stochastic : matrix ∈ Matrix.rowStochastic ℝ (Fin n)) :
    stdSimplex ℝ (Fin n) → stdSimplex ℝ (Fin n) := fun distribution =>
  ⟨distribution.1 ᵥ* matrix, by
    constructor
    · exact Matrix.nonneg_vecMul_of_mem_rowStochastic stochastic distribution.2.1
    · have normalizedDot : distribution.1 ⬝ᵥ (1 : Fin n → ℝ) = 1 := by
        simpa [dotProduct] using distribution.2.2
      have preserved := Matrix.vecMul_dotProduct_one_eq_one_rowStochastic
        stochastic normalizedDot
      simpa [dotProduct] using preserved⟩

theorem continuous_stochasticSimplexMap {n : ℕ+}
    (matrix : Matrix (Fin n) (Fin n) ℝ)
    (stochastic : matrix ∈ Matrix.rowStochastic ℝ (Fin n)) :
    Continuous (stochasticSimplexMap matrix stochastic) := by
  apply continuous_induced_rng.2
  exact continuous_subtype_val.matrix_vecMul continuous_const

/-- Every finite nonempty row-stochastic real matrix has a stationary
probability vector. This is the finite-chain existence theorem, proved by
Brouwer on the standard simplex. -/
theorem exists_stationaryVector_of_rowStochastic {n : ℕ+}
    (matrix : Matrix (Fin n) (Fin n) ℝ)
    (stochastic : matrix ∈ Matrix.rowStochastic ℝ (Fin n)) :
    ∃ distribution : stdSimplex ℝ (Fin n),
      distribution.1 ᵥ* matrix = distribution.1 := by
  obtain ⟨distribution, fixed⟩ :=
    Brouwer (stochasticSimplexMap matrix stochastic)
      (continuous_stochasticSimplexMap matrix stochastic)
  exact ⟨distribution, congrArg Subtype.val fixed⟩

theorem exists_stationaryVector_of_rowStochastic_fintype
    {state : Type*} [Fintype state] [DecidableEq state] [Nonempty state]
    (matrix : Matrix state state ℝ)
    (stochastic : matrix ∈ Matrix.rowStochastic ℝ state) :
    ∃ distribution : state → ℝ,
      (∀ state, 0 ≤ distribution state) ∧
      (∑ state, distribution state = 1) ∧
      distribution ᵥ* matrix = distribution := by
  classical
  let stateCount : ℕ+ := ⟨Fintype.card state, Fintype.card_pos⟩
  let enumerate : state ≃ Fin stateCount := Fintype.equivFin state
  let indexedMatrix : Matrix (Fin stateCount) (Fin stateCount) ℝ :=
    matrix.reindex enumerate enumerate
  have indexedStochastic : indexedMatrix ∈
      Matrix.rowStochastic ℝ (Fin stateCount) :=
    Matrix.reindex_mem_rowStochastic stochastic
  obtain ⟨indexedDistribution, indexedFixed⟩ :=
    exists_stationaryVector_of_rowStochastic indexedMatrix indexedStochastic
  let distribution : state → ℝ := fun current => indexedDistribution.1 (enumerate current)
  refine ⟨distribution, ?_, ?_, ?_⟩
  · intro current
    exact indexedDistribution.2.1 (enumerate current)
  · change ∑ current, indexedDistribution.1 (enumerate current) = 1
    rw [Equiv.sum_comp enumerate]
    exact indexedDistribution.2.2
  · funext destination
    have coordinateFixed := congrFun indexedFixed (enumerate destination)
    change (∑ current, indexedDistribution.1 (enumerate current) *
      matrix current destination) = indexedDistribution.1 (enumerate destination)
    calc
      _ = ∑ index, indexedDistribution.1 index *
          matrix (enumerate.symm index) destination := by
            rw [← Equiv.sum_comp enumerate]
            simp
      _ = _ := by
        simpa [indexedMatrix, Matrix.vecMul, dotProduct, enumerate] using coordinateFixed

/-- Real transition matrix associated with the model's finite PMF kernel. -/
noncomputable def finiteKernelMatrix {grid : EffortGrid} {bounds : StateBounds}
    {tieSlots : Nat} [Nonempty (FiniteDraw bounds tieSlots)]
    (choose : FiniteChoiceRule grid bounds tieSlots) :
    Matrix (FiniteModelState grid bounds) (FiniteModelState grid bounds) ℝ :=
  fun state next => (finiteKernel choose state next).toReal

theorem finiteKernelMatrix_rowStochastic {grid : EffortGrid}
    {bounds : StateBounds} {tieSlots : Nat}
    [Nonempty (FiniteDraw bounds tieSlots)]
    (choose : FiniteChoiceRule grid bounds tieSlots) :
    finiteKernelMatrix choose ∈
      Matrix.rowStochastic ℝ (FiniteModelState grid bounds) := by
  rw [Matrix.mem_rowStochastic_iff_sum]
  constructor
  · intro state next
    exact ENNReal.toReal_nonneg
  · intro state
    let kernel := finiteKernel choose state
    calc
      ∑ next, finiteKernelMatrix choose state next =
          (∑ next, kernel next).toReal := by
            rw [ENNReal.toReal_sum]
            · rfl
            · intro next _
              exact kernel.apply_ne_top next
      _ = 1 := by
        have normalized : ∑ next, kernel next = 1 := by
          simpa only [tsum_fintype] using kernel.tsum_coe
        rw [normalized]
        simp

/-- Every bounded finite-model kernel has at least one stationary PMF. -/
theorem exists_stationaryFiniteDistribution {grid : EffortGrid}
    {bounds : StateBounds} {tieSlots : Nat}
    [Nonempty (FiniteDraw bounds tieSlots)]
    (choose : FiniteChoiceRule grid bounds tieSlots) :
    ∃ distribution : PMF (FiniteModelState grid bounds),
      distribution.bind (finiteKernel choose) = distribution := by
  classical
  letI : Nonempty (FiniteModelState grid bounds) :=
    ⟨{ agents := fun _ => none, activeFirms := ∅,
       nextAgent := none, nextFirm := none }⟩
  obtain ⟨vector, vectorNonnegative, vectorSum, vectorFixed⟩ :=
    exists_stationaryVector_of_rowStochastic_fintype
      (finiteKernelMatrix choose) (finiteKernelMatrix_rowStochastic choose)
  let weights : FiniteModelState grid bounds → ℝ≥0∞ :=
    fun state => ENNReal.ofReal (vector state)
  have weightsSum : ∑ state, weights state = 1 := by
    rw [← ENNReal.ofReal_sum_of_nonneg]
    · rw [vectorSum]
      simp
    · intro state _
      exact vectorNonnegative state
  let distribution : PMF (FiniteModelState grid bounds) :=
    PMF.ofFintype weights weightsSum
  refine ⟨distribution, ?_⟩
  apply PMF.ext
  intro next
  apply (ENNReal.toReal_eq_toReal
    ((distribution.bind (finiteKernel choose)).apply_ne_top next)
    (distribution.apply_ne_top next)).mp
  rw [PMF.bind_apply, tsum_fintype]
  rw [ENNReal.toReal_sum]
  · simp only [ENNReal.toReal_mul, distribution, PMF.ofFintype_apply, weights,
      ENNReal.toReal_ofReal (vectorNonnegative _), finiteKernelMatrix]
    exact congrFun vectorFixed next
  · intro state _
    exact ENNReal.mul_ne_top (distribution.apply_ne_top state)
      ((finiteKernel choose state).apply_ne_top next)

/-- Advance an arbitrary state distribution by one draw. -/
noncomputable def evolveFiniteDistribution {grid : EffortGrid} {bounds : StateBounds}
    {tieSlots : Nat} [Nonempty (FiniteDraw bounds tieSlots)]
    (choose : FiniteChoiceRule grid bounds tieSlots)
    (distribution : PMF (FiniteModelState grid bounds)) :
    PMF (FiniteModelState grid bounds) :=
  distribution.bind (finiteKernel choose)

/-- A stationary distribution is a fixed point of one-step distribution
evolution. -/
def IsStationaryFiniteDistribution {grid : EffortGrid} {bounds : StateBounds}
    {tieSlots : Nat} [Nonempty (FiniteDraw bounds tieSlots)]
    (choose : FiniteChoiceRule grid bounds tieSlots)
    (distribution : PMF (FiniteModelState grid bounds)) : Prop :=
  evolveFiniteDistribution choose distribution = distribution

theorem exists_isStationaryFiniteDistribution {grid : EffortGrid}
    {bounds : StateBounds} {tieSlots : Nat}
    [Nonempty (FiniteDraw bounds tieSlots)]
    (choose : FiniteChoiceRule grid bounds tieSlots) :
    ∃ distribution : PMF (FiniteModelState grid bounds),
      IsStationaryFiniteDistribution choose distribution := by
  simpa [IsStationaryFiniteDistribution, evolveFiniteDistribution] using
    exists_stationaryFiniteDistribution choose

noncomputable def evolveFiniteDistributionN {grid : EffortGrid}
    {bounds : StateBounds} {tieSlots : Nat}
    [Nonempty (FiniteDraw bounds tieSlots)]
    (choose : FiniteChoiceRule grid bounds tieSlots) :
    Nat → PMF (FiniteModelState grid bounds) → PMF (FiniteModelState grid bounds)
  | 0, distribution => distribution
  | steps + 1, distribution =>
      evolveFiniteDistribution choose (evolveFiniteDistributionN choose steps distribution)

theorem stationary_fixed_at_every_horizon {grid : EffortGrid}
    {bounds : StateBounds} {tieSlots : Nat}
    [Nonempty (FiniteDraw bounds tieSlots)]
    (choose : FiniteChoiceRule grid bounds tieSlots)
    (distribution : PMF (FiniteModelState grid bounds))
    (stationary : IsStationaryFiniteDistribution choose distribution)
    (steps : Nat) :
    evolveFiniteDistributionN choose steps distribution = distribution := by
  induction steps with
  | zero => rfl
  | succ steps ih =>
      simp only [evolveFiniteDistributionN, ih]
      exact stationary

instance finiteModelStateMeasurableSpace (grid : EffortGrid) (bounds : StateBounds) :
    MeasurableSpace (FiniteModelState grid bounds) := ⊤

/-- At any fixed population bound, the size of a specified firm has bounded
variance under every state distribution. In particular it cannot have
infinite variance. -/
theorem variance_finiteFirmSize_le {grid : EffortGrid} {bounds : StateBounds}
    (distribution : PMF (FiniteModelState grid bounds))
    (firm : FiniteFirmId bounds) :
    ProbabilityTheory.variance
        (fun state => (finiteFirmSize state firm : ℝ)) distribution.toMeasure ≤
      (((bounds.agentSlots : ℝ) - 0) / 2) ^ 2 := by
  apply ProbabilityTheory.variance_le_sq_of_bounded
  · filter_upwards [] with state
    constructor
    · positivity
    · exact_mod_cast finiteFirmSize_le_agentSlots state firm
  · exact (measurable_of_countable _).aemeasurable

end AgenticAxtell.Approximation
