import AgenticAxtell.Baseline.Production

namespace AgenticAxtell.Baseline

/-- Marginal output of the nonlinear technology at positive total effort. -/
noncomputable def marginalProduction (params : Params) (totalEffort : ℝ) : ℝ :=
  params.a + params.b * params.beta * totalEffort ^ (params.beta - 1)

/-- The nonlinear production technology is nonnegative at nonnegative total
effort whenever both production coefficients are nonnegative. -/
theorem production_nonnegative (params : Params) (totalEffort : ℝ)
    (aNonnegative : 0 ≤ params.a) (bNonnegative : 0 ≤ params.b)
    (effortNonnegative : 0 ≤ totalEffort) :
    0 ≤ production params totalEffort := by
  unfold production
  exact add_nonneg (mul_nonneg aNonnegative effortNonnegative)
    (mul_nonneg bNonnegative (Real.rpow_nonneg effortNonnegative params.beta))

theorem production_positive_of_a_pos (params : Params) (totalEffort : ℝ)
    (aPositive : 0 < params.a) (bNonnegative : 0 ≤ params.b)
    (effortPositive : 0 < totalEffort) :
    0 < production params totalEffort := by
  unfold production
  exact add_pos_of_pos_of_nonneg (mul_pos aPositive effortPositive)
    (mul_nonneg bNonnegative (Real.rpow_nonneg effortPositive.le params.beta))

/-- On nonnegative effort, `aE + bE^beta` is weakly increasing when its
coefficients and exponent are nonnegative. -/
theorem production_monotoneOn_nonnegative (params : Params)
    (aNonnegative : 0 ≤ params.a) (bNonnegative : 0 ≤ params.b)
    (betaNonnegative : 0 ≤ params.beta) :
    MonotoneOn (production params) (Set.Ici 0) := by
  intro first firstNonnegative second secondNonnegative firstLeSecond
  unfold production
  have powerLe : first ^ params.beta ≤ second ^ params.beta :=
    Real.rpow_le_rpow firstNonnegative firstLeSecond betaNonnegative
  exact add_le_add
    (mul_le_mul_of_nonneg_left firstLeSecond aNonnegative)
    (mul_le_mul_of_nonneg_left powerLe bNonnegative)

/-- A positive linear component makes production strictly increasing on
nonnegative effort, independently of whether the cooperative component is
strictly increasing. -/
theorem production_strictMonoOn_nonnegative_of_a_pos (params : Params)
    (aPositive : 0 < params.a) (bNonnegative : 0 ≤ params.b)
    (betaNonnegative : 0 ≤ params.beta) :
    StrictMonoOn (production params) (Set.Ici 0) := by
  intro first firstNonnegative second secondNonnegative firstLtSecond
  unfold production
  have linearLt : params.a * first < params.a * second :=
    mul_lt_mul_of_pos_left firstLtSecond aPositive
  have powerLe : first ^ params.beta ≤ second ^ params.beta :=
    Real.rpow_le_rpow firstNonnegative firstLtSecond.le betaNonnegative
  have cooperativeLe : params.b * first ^ params.beta ≤
      params.b * second ^ params.beta :=
    mul_le_mul_of_nonneg_left powerLe bNonnegative
  exact add_lt_add_of_lt_of_le linearLt cooperativeLe

/-- Valid model parameters supply all assumptions needed for nonnegative and
monotone nonlinear production. -/
theorem validParams_production_monotoneOn_nonnegative (params : Params)
    (paramsValid : ValidParams params) :
    MonotoneOn (production params) (Set.Ici 0) := by
  exact production_monotoneOn_nonnegative params paramsValid.2.1 paramsValid.2.2.1
    (le_trans zero_le_one paramsValid.2.2.2.1)

/-- On positive total effort, the derivative of `aE+bE^beta` is its standard
marginal-product expression. Positivity avoids the exceptional behavior of
real powers at zero. -/
theorem hasDerivAt_production (params : Params) (totalEffort : ℝ)
    (effortPositive : 0 < totalEffort) :
    HasDerivAt (production params) (marginalProduction params totalEffort)
      totalEffort := by
  have linearDerivative : HasDerivAt (fun effort : ℝ => params.a * effort)
      params.a totalEffort := by
    convert (hasDerivAt_const totalEffort params.a).mul
      (hasDerivAt_id totalEffort) using 1
    all_goals ring
  have powerDerivative : HasDerivAt (fun effort : ℝ => effort ^ params.beta)
      (params.beta * totalEffort ^ (params.beta - 1)) totalEffort :=
    Real.hasDerivAt_rpow_const (Or.inl effortPositive.ne')
  have cooperativeDerivative : HasDerivAt
      (fun effort : ℝ => params.b * effort ^ params.beta)
      (params.b * (params.beta * totalEffort ^ (params.beta - 1))) totalEffort := by
    convert (hasDerivAt_const totalEffort params.b).mul powerDerivative using 1
    all_goals ring
  unfold production marginalProduction
  convert linearDerivative.add cooperativeDerivative using 1
  all_goals ring

end AgenticAxtell.Baseline
