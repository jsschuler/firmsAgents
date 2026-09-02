import AgenticAxtell.Baseline.BestResponse
import AgenticAxtell.Baseline.NonlinearProduction

namespace AgenticAxtell.Baseline

/-- Interior derivative of Cobb-Douglas utility under nonlinear production. -/
noncomputable def marginalUtility (params : Params) (theta effort othersEffort : ℝ)
    (firmSize : Nat) : ℝ :=
  let income := production params (effort + othersEffort) / firmSize
  let leisure := 1 - effort
  (marginalProduction params (effort + othersEffort) / firmSize) * theta *
      income ^ (theta - 1) * leisure ^ (1 - theta) +
    income ^ theta * ((-1) * (1 - theta) * leisure ^ ((1 - theta) - 1))

/-- Log utility on the positive-income, positive-leisure interior. -/
noncomputable def logUtility (params : Params) (theta effort othersEffort : ℝ)
    (firmSize : Nat) : ℝ :=
  theta * Real.log (production params (effort + othersEffort) / firmSize) +
    (1 - theta) * Real.log (1 - effort)

/-- The economically transparent numerator of the log-utility first-order
condition. -/
noncomputable def nonlinearFirstOrderScore (params : Params)
    (theta effort othersEffort : ℝ) : ℝ :=
  theta * (1 - effort) * marginalProduction params (effort + othersEffort) -
    (1 - theta) * production params (effort + othersEffort)

noncomputable def marginalLogUtility (params : Params)
    (theta effort othersEffort : ℝ) (firmSize : Nat) : ℝ :=
  theta *
      ((marginalProduction params (effort + othersEffort) / firmSize) /
        (production params (effort + othersEffort) / firmSize)) -
    (1 - theta) / (1 - effort)

theorem log_utility_eq_logUtility (params : Params)
    (theta effort othersEffort : ℝ) (firmSize : Nat)
    (incomePositive : 0 < production params (effort + othersEffort) / firmSize)
    (leisurePositive : 0 < 1 - effort) :
    Real.log (utility params theta effort othersEffort firmSize) =
      logUtility params theta effort othersEffort firmSize := by
  have incomePowerNonzero :
      (production params (effort + othersEffort) / firmSize) ^ theta ≠ 0 :=
    (Real.rpow_pos_of_pos incomePositive theta).ne'
  have leisurePowerNonzero : (1 - effort) ^ (1 - theta) ≠ 0 :=
    (Real.rpow_pos_of_pos leisurePositive (1 - theta)).ne'
  unfold utility logUtility
  rw [Real.log_mul incomePowerNonzero leisurePowerNonzero,
    Real.log_rpow incomePositive theta, Real.log_rpow leisurePositive (1 - theta)]

/-- At an interior effort with positive total effort and positive linear
productivity, nonlinear utility has the expected product-rule derivative. -/
theorem hasDerivAt_utility_interior (params : Params) (theta effort othersEffort : ℝ)
    (firmSize : Nat) (aPositive : 0 < params.a) (bNonnegative : 0 ≤ params.b)
    (totalEffortPositive : 0 < effort + othersEffort)
    (effortBelowOne : effort < 1) (firmSizePositive : 0 < firmSize) :
    HasDerivAt (fun candidate => utility params theta candidate othersEffort firmSize)
      (marginalUtility params theta effort othersEffort firmSize) effort := by
  have totalDerivative : HasDerivAt (fun candidate : ℝ => candidate + othersEffort)
      1 effort := by
    simpa using (hasDerivAt_id effort).add_const othersEffort
  have outputDerivative : HasDerivAt
      (fun candidate => production params (candidate + othersEffort))
      (marginalProduction params (effort + othersEffort)) effort := by
    simpa [Function.comp_def] using
      (hasDerivAt_production params (effort + othersEffort) totalEffortPositive).comp
        effort totalDerivative
  have incomeDerivative : HasDerivAt
      (fun candidate => production params (candidate + othersEffort) / firmSize)
      (marginalProduction params (effort + othersEffort) / firmSize) effort :=
    outputDerivative.div_const firmSize
  have outputPositive : 0 < production params (effort + othersEffort) :=
    production_positive_of_a_pos params _ aPositive bNonnegative totalEffortPositive
  have firmSizeCastPositive : 0 < (firmSize : ℝ) := by exact_mod_cast firmSizePositive
  have incomePositive : 0 < production params (effort + othersEffort) / firmSize :=
    div_pos outputPositive firmSizeCastPositive
  have incomePowerDerivative := incomeDerivative.rpow_const (p := theta)
    (Or.inl incomePositive.ne')
  have leisureDerivative : HasDerivAt (fun candidate : ℝ => 1 - candidate) (-1) effort := by
    convert (hasDerivAt_const effort 1).sub (hasDerivAt_id effort) using 1
    all_goals ring
  have leisurePositive : 0 < 1 - effort := sub_pos.mpr effortBelowOne
  have leisurePowerDerivative := leisureDerivative.rpow_const (p := 1 - theta)
    (Or.inl leisurePositive.ne')
  unfold utility marginalUtility
  exact incomePowerDerivative.mul leisurePowerDerivative

theorem hasDerivAt_logUtility_interior (params : Params)
    (theta effort othersEffort : ℝ) (firmSize : Nat)
    (aPositive : 0 < params.a) (bNonnegative : 0 ≤ params.b)
    (totalEffortPositive : 0 < effort + othersEffort)
    (effortBelowOne : effort < 1) (firmSizePositive : 0 < firmSize) :
    HasDerivAt (fun candidate => logUtility params theta candidate othersEffort firmSize)
      (marginalLogUtility params theta effort othersEffort firmSize) effort := by
  have totalDerivative : HasDerivAt (fun candidate : ℝ => candidate + othersEffort)
      1 effort := by
    simpa using (hasDerivAt_id effort).add_const othersEffort
  have outputDerivative : HasDerivAt
      (fun candidate => production params (candidate + othersEffort))
      (marginalProduction params (effort + othersEffort)) effort := by
    simpa [Function.comp_def] using
      (hasDerivAt_production params (effort + othersEffort) totalEffortPositive).comp
        effort totalDerivative
  have incomeDerivative := outputDerivative.div_const firmSize
  have outputPositive := production_positive_of_a_pos params _ aPositive bNonnegative
    totalEffortPositive
  have firmSizeCastPositive : 0 < (firmSize : ℝ) := by exact_mod_cast firmSizePositive
  have incomePositive : 0 < production params (effort + othersEffort) / firmSize :=
    div_pos outputPositive firmSizeCastPositive
  have logIncomeDerivative := incomeDerivative.log incomePositive.ne'
  have leisureDerivative : HasDerivAt (fun candidate : ℝ => 1 - candidate) (-1) effort := by
    convert (hasDerivAt_const effort 1).sub (hasDerivAt_id effort) using 1
    all_goals ring
  have leisurePositive : 0 < 1 - effort := sub_pos.mpr effortBelowOne
  have logLeisureDerivative := leisureDerivative.log leisurePositive.ne'
  unfold logUtility marginalLogUtility
  convert logIncomeDerivative.const_mul theta |>.add
    (logLeisureDerivative.const_mul (1 - theta)) using 1
  all_goals ring

/-- With positive income and leisure denominators, the log derivative vanishes
exactly when the unnormalized nonlinear first-order score vanishes. -/
theorem marginalLogUtility_eq_zero_iff_score_eq_zero (params : Params)
    (theta effort othersEffort : ℝ) (firmSize : Nat)
    (outputPositive : 0 < production params (effort + othersEffort))
    (effortBelowOne : effort < 1) (firmSizePositive : 0 < firmSize) :
    marginalLogUtility params theta effort othersEffort firmSize = 0 ↔
      nonlinearFirstOrderScore params theta effort othersEffort = 0 := by
  have firmSizeCastPositive : 0 < (firmSize : ℝ) := by exact_mod_cast firmSizePositive
  have incomeNonzero : production params (effort + othersEffort) / firmSize ≠ 0 :=
    (div_pos outputPositive firmSizeCastPositive).ne'
  have leisureNonzero : 1 - effort ≠ 0 := (sub_pos.mpr effortBelowOne).ne'
  unfold marginalLogUtility nonlinearFirstOrderScore
  field_simp [incomeNonzero, leisureNonzero, ne_of_gt firmSizeCastPositive]
  ring

theorem marginalLogUtility_eq_score_div (params : Params)
    (theta effort othersEffort : ℝ) (firmSize : Nat)
    (outputPositive : 0 < production params (effort + othersEffort))
    (effortBelowOne : effort < 1) (firmSizePositive : 0 < firmSize) :
    marginalLogUtility params theta effort othersEffort firmSize =
      nonlinearFirstOrderScore params theta effort othersEffort /
        ((1 - effort) * production params (effort + othersEffort)) := by
  have firmSizeCastPositive : 0 < (firmSize : ℝ) := by exact_mod_cast firmSizePositive
  have incomeNonzero : production params (effort + othersEffort) / firmSize ≠ 0 :=
    (div_pos outputPositive firmSizeCastPositive).ne'
  have leisureNonzero : 1 - effort ≠ 0 := (sub_pos.mpr effortBelowOne).ne'
  have outputNonzero := outputPositive.ne'
  unfold marginalLogUtility nonlinearFirstOrderScore
  field_simp [incomeNonzero, leisureNonzero, outputNonzero,
    ne_of_gt firmSizeCastPositive]
  ring

theorem marginalLogUtility_pos_iff_score_pos (params : Params)
    (theta effort othersEffort : ℝ) (firmSize : Nat)
    (outputPositive : 0 < production params (effort + othersEffort))
    (effortBelowOne : effort < 1) (firmSizePositive : 0 < firmSize) :
    0 < marginalLogUtility params theta effort othersEffort firmSize ↔
      0 < nonlinearFirstOrderScore params theta effort othersEffort := by
  rw [marginalLogUtility_eq_score_div params theta effort othersEffort firmSize
    outputPositive effortBelowOne firmSizePositive]
  exact div_pos_iff_of_pos_right
    (mul_pos (sub_pos.mpr effortBelowOne) outputPositive)

/-- For Axtell's quadratic exponent, the nonlinear first-order condition is an
explicit quadratic equation in own effort and total effort. -/
theorem nonlinearFirstOrderScore_beta_two (params : Params)
    (theta effort othersEffort : ℝ) (betaTwo : params.beta = 2) :
    nonlinearFirstOrderScore params theta effort othersEffort =
      theta * (1 - effort) *
          (params.a + 2 * params.b * (effort + othersEffort)) -
        (1 - theta) *
          (params.a * (effort + othersEffort) +
            params.b * (effort + othersEffort) ^ 2) := by
  unfold nonlinearFirstOrderScore marginalProduction production
  rw [betaTwo]
  rw [show (2 : ℝ) - 1 = 1 by norm_num, Real.rpow_one, Real.rpow_two]
  ring

/-- Exact finite-difference identity for the quadratic (`beta=2`) score. It
exhibits the score's affine slope and makes the response-shape restriction
explicit. -/
theorem nonlinearFirstOrderScore_beta_two_sub (params : Params)
    (theta othersEffort first second : ℝ) (betaTwo : params.beta = 2) :
    nonlinearFirstOrderScore params theta second othersEffort -
        nonlinearFirstOrderScore params theta first othersEffort =
      (second - first) *
        (-params.a + 2 * params.b *
          (theta - othersEffort - ((1 + theta) / 2) * (first + second))) := by
  rw [nonlinearFirstOrderScore_beta_two params theta second othersEffort betaTwo,
    nonlinearFirstOrderScore_beta_two params theta first othersEffort betaTwo]
  ring

/-- If the score's slope is already nonpositive at zero, then the quadratic
score is strictly decreasing over nonnegative effort. This condition is
`2*b*(theta-E_other) ≤ a`. -/
theorem nonlinearFirstOrderScore_beta_two_strictAntiOn_nonnegative
    (params : Params) (theta othersEffort : ℝ) (betaTwo : params.beta = 2)
    (bNonnegative : 0 ≤ params.b) (thetaNonnegative : 0 ≤ theta)
    (slopeAtZeroNegative : 2 * params.b * (theta - othersEffort) < params.a) :
    StrictAntiOn (fun effort =>
      nonlinearFirstOrderScore params theta effort othersEffort) (Set.Ici 0) := by
  intro first firstNonnegative second secondNonnegative firstLtSecond
  change 0 ≤ first at firstNonnegative
  change 0 ≤ second at secondNonnegative
  have effortSumNonnegative : 0 ≤ first + second := add_nonneg firstNonnegative secondNonnegative
  have weightNonnegative : 0 ≤ (1 + theta) / 2 := by linarith
  have correctionNonnegative :
      0 ≤ ((1 + theta) / 2) * (first + second) :=
    mul_nonneg weightNonnegative effortSumNonnegative
  have bracketNegative :
      -params.a + 2 * params.b *
        (theta - othersEffort - ((1 + theta) / 2) * (first + second)) < 0 := by
    have scaledCorrectionNonnegative :
        0 ≤ 2 * params.b * (((1 + theta) / 2) * (first + second)) := by
      positivity
    nlinarith
  have differenceNegative :
      nonlinearFirstOrderScore params theta second othersEffort -
          nonlinearFirstOrderScore params theta first othersEffort < 0 := by
    rw [nonlinearFirstOrderScore_beta_two_sub params theta othersEffort first second betaTwo]
    exact mul_neg_of_pos_of_neg (sub_pos.mpr firstLtSecond) bracketNegative
  change nonlinearFirstOrderScore params theta second othersEffort <
    nonlinearFirstOrderScore params theta first othersEffort
  linarith

theorem nonlinearFirstOrderScore_beta_two_at_one (params : Params)
    (theta othersEffort : ℝ) (betaTwo : params.beta = 2) :
    nonlinearFirstOrderScore params theta 1 othersEffort =
      -(1 - theta) *
        (params.a * (1 + othersEffort) + params.b * (1 + othersEffort) ^ 2) := by
  rw [nonlinearFirstOrderScore_beta_two params theta 1 othersEffort betaTwo]
  ring

theorem nonlinearFirstOrderScore_beta_two_at_zero (params : Params)
    (theta othersEffort : ℝ) (betaTwo : params.beta = 2) :
    nonlinearFirstOrderScore params theta 0 othersEffort =
      theta * (params.a + 2 * params.b * othersEffort) -
        (1 - theta) *
          (params.a * othersEffort + params.b * othersEffort ^ 2) := by
  rw [nonlinearFirstOrderScore_beta_two params theta 0 othersEffort betaTwo]
  ring

/-- Any globally optimal feasible effort lying strictly inside `(0,1)` obeys
the nonlinear first-order condition. -/
theorem interior_bestResponse_marginalUtility_eq_zero
    (params : Params) (theta effort othersEffort : ℝ) (firmSize : Nat)
    (best : IsBestResponse params theta othersEffort firmSize effort)
    (effortPositive : 0 < effort) (effortBelowOne : effort < 1)
    (aPositive : 0 < params.a) (bNonnegative : 0 ≤ params.b)
    (totalEffortPositive : 0 < effort + othersEffort)
    (firmSizePositive : 0 < firmSize) :
    marginalUtility params theta effort othersEffort firmSize = 0 := by
  have localMax : IsLocalMax
      (fun candidate => utility params theta candidate othersEffort firmSize) effort := by
    filter_upwards [isOpen_Ioo.mem_nhds ⟨effortPositive, effortBelowOne⟩]
      with candidate candidateInterior
    exact best.2 candidate ⟨candidateInterior.1.le, candidateInterior.2.le⟩
  exact localMax.hasDerivAt_eq_zero
    (hasDerivAt_utility_interior params theta effort othersEffort firmSize
      aPositive bNonnegative totalEffortPositive effortBelowOne firmSizePositive)

/-- Positive interior best responses maximize the log objective locally, so
their scale-free nonlinear first-order score vanishes. -/
theorem interior_bestResponse_nonlinearFirstOrderScore_eq_zero
    (params : Params) (theta effort othersEffort : ℝ) (firmSize : Nat)
    (best : IsBestResponse params theta othersEffort firmSize effort)
    (effortPositive : 0 < effort) (effortBelowOne : effort < 1)
    (aPositive : 0 < params.a) (bNonnegative : 0 ≤ params.b)
    (totalEffortPositive : 0 < effort + othersEffort)
    (firmSizePositive : 0 < firmSize) :
    nonlinearFirstOrderScore params theta effort othersEffort = 0 := by
  have firmSizeCastPositive : 0 < (firmSize : ℝ) := by exact_mod_cast firmSizePositive
  have localMax : IsLocalMax
      (fun candidate => logUtility params theta candidate othersEffort firmSize) effort := by
    filter_upwards
      [isOpen_Ioo.mem_nhds ⟨effortPositive, effortBelowOne⟩,
        isOpen_Ioi.mem_nhds (show -othersEffort < effort by linarith)]
      with candidate candidateInterior candidateTotalPositive
    have candidateTotal : 0 < candidate + othersEffort := by
      change -othersEffort < candidate at candidateTotalPositive
      linarith
    have candidateOutputPositive := production_positive_of_a_pos params _ aPositive
      bNonnegative candidateTotal
    have candidateIncomePositive :
        0 < production params (candidate + othersEffort) / firmSize :=
      div_pos candidateOutputPositive firmSizeCastPositive
    have candidateLeisurePositive : 0 < 1 - candidate :=
      sub_pos.mpr candidateInterior.2
    have chosenOutputPositive := production_positive_of_a_pos params _ aPositive
      bNonnegative totalEffortPositive
    have chosenIncomePositive :
        0 < production params (effort + othersEffort) / firmSize :=
      div_pos chosenOutputPositive firmSizeCastPositive
    have chosenLeisurePositive : 0 < 1 - effort := sub_pos.mpr effortBelowOne
    have utilityComparison := best.2 candidate
      ⟨candidateInterior.1.le, candidateInterior.2.le⟩
    have candidateUtilityPositive :
        0 < utility params theta candidate othersEffort firmSize := by
      unfold utility
      exact mul_pos (Real.rpow_pos_of_pos candidateIncomePositive theta)
        (Real.rpow_pos_of_pos candidateLeisurePositive (1 - theta))
    have chosenUtilityPositive :
        0 < utility params theta effort othersEffort firmSize := by
      unfold utility
      exact mul_pos (Real.rpow_pos_of_pos chosenIncomePositive theta)
        (Real.rpow_pos_of_pos chosenLeisurePositive (1 - theta))
    have logComparison := Real.strictMonoOn_log.monotoneOn
      candidateUtilityPositive chosenUtilityPositive utilityComparison
    rw [log_utility_eq_logUtility params theta candidate othersEffort firmSize
        candidateIncomePositive candidateLeisurePositive,
      log_utility_eq_logUtility params theta effort othersEffort firmSize
        chosenIncomePositive chosenLeisurePositive] at logComparison
    exact logComparison
  have marginalLogZero := localMax.hasDerivAt_eq_zero
    (hasDerivAt_logUtility_interior params theta effort othersEffort firmSize
      aPositive bNonnegative totalEffortPositive effortBelowOne firmSizePositive)
  exact (marginalLogUtility_eq_zero_iff_score_eq_zero params theta effort
    othersEffort firmSize
    (production_positive_of_a_pos params _ aPositive bNonnegative totalEffortPositive)
    effortBelowOne firmSizePositive).mp marginalLogZero

theorem interior_bestResponse_beta_two_quadratic_eq_zero
    (params : Params) (theta effort othersEffort : ℝ) (firmSize : Nat)
    (best : IsBestResponse params theta othersEffort firmSize effort)
    (effortPositive : 0 < effort) (effortBelowOne : effort < 1)
    (aPositive : 0 < params.a) (bNonnegative : 0 ≤ params.b)
    (totalEffortPositive : 0 < effort + othersEffort)
    (firmSizePositive : 0 < firmSize) (betaTwo : params.beta = 2) :
    theta * (1 - effort) *
          (params.a + 2 * params.b * (effort + othersEffort)) -
        (1 - theta) *
          (params.a * (effort + othersEffort) +
            params.b * (effort + othersEffort) ^ 2) = 0 := by
  rw [← nonlinearFirstOrderScore_beta_two params theta effort othersEffort betaTwo]
  exact interior_bestResponse_nonlinearFirstOrderScore_eq_zero params theta effort
    othersEffort firmSize best effortPositive effortBelowOne aPositive bNonnegative
    totalEffortPositive firmSizePositive

/-- Under the negative-initial-slope condition, there is at most one positive
interior best response in a fixed environment. Boundary effort zero is kept
separate because increasing returns can make it compete with an interior
maximum outside this condition. -/
theorem interior_bestResponse_beta_two_unique
    (params : Params) (theta othersEffort : ℝ) (firmSize : Nat)
    (first second : ℝ)
    (firstBest : IsBestResponse params theta othersEffort firmSize first)
    (secondBest : IsBestResponse params theta othersEffort firmSize second)
    (firstPositive : 0 < first) (firstBelowOne : first < 1)
    (secondPositive : 0 < second) (secondBelowOne : second < 1)
    (aPositive : 0 < params.a) (bNonnegative : 0 ≤ params.b)
    (thetaNonnegative : 0 ≤ theta)
    (firstTotalPositive : 0 < first + othersEffort)
    (secondTotalPositive : 0 < second + othersEffort)
    (firmSizePositive : 0 < firmSize) (betaTwo : params.beta = 2)
    (slopeAtZeroNegative : 2 * params.b * (theta - othersEffort) < params.a) :
    first = second := by
  have firstScoreZero := interior_bestResponse_nonlinearFirstOrderScore_eq_zero
    params theta first othersEffort firmSize firstBest firstPositive firstBelowOne
    aPositive bNonnegative firstTotalPositive firmSizePositive
  have secondScoreZero := interior_bestResponse_nonlinearFirstOrderScore_eq_zero
    params theta second othersEffort firmSize secondBest secondPositive secondBelowOne
    aPositive bNonnegative secondTotalPositive firmSizePositive
  have scoreStrictAnti := nonlinearFirstOrderScore_beta_two_strictAntiOn_nonnegative
    params theta othersEffort betaTwo bNonnegative thetaNonnegative slopeAtZeroNegative
  rcases lt_trichotomy first second with firstLt | equal | secondLt
  · have comparison := scoreStrictAnti firstPositive.le secondPositive.le firstLt
    change nonlinearFirstOrderScore params theta second othersEffort <
      nonlinearFirstOrderScore params theta first othersEffort at comparison
    rw [firstScoreZero, secondScoreZero] at comparison
    linarith
  · exact equal
  · have comparison := scoreStrictAnti secondPositive.le firstPositive.le secondLt
    change nonlinearFirstOrderScore params theta first othersEffort <
      nonlinearFirstOrderScore params theta second othersEffort at comparison
    rw [firstScoreZero, secondScoreZero] at comparison
    linarith

/-- Full effort cannot be optimal when leisure has positive weight: it yields
zero utility, while effort one-half yields strictly positive utility. -/
theorem one_not_bestResponse (params : Params) (theta othersEffort : ℝ)
    (firmSize : Nat) (aPositive : 0 < params.a) (bNonnegative : 0 ≤ params.b)
    (othersNonnegative : 0 ≤ othersEffort) (thetaAtMostOne : theta < 1)
    (firmSizePositive : 0 < firmSize) :
    ¬ IsBestResponse params theta othersEffort firmSize 1 := by
  intro best
  have halfFeasible : (1 / 2 : ℝ) ∈ FeasibleEffort := by
    norm_num [FeasibleEffort]
  have comparison := best.2 (1 / 2) halfFeasible
  have halfTotalPositive : 0 < (1 / 2 : ℝ) + othersEffort := by linarith
  have halfOutputPositive := production_positive_of_a_pos params _ aPositive bNonnegative
    halfTotalPositive
  have firmSizeCastPositive : 0 < (firmSize : ℝ) := by exact_mod_cast firmSizePositive
  have halfIncomePositive :
      0 < production params ((1 / 2 : ℝ) + othersEffort) / firmSize :=
    div_pos halfOutputPositive firmSizeCastPositive
  have halfLeisurePositive : 0 < (1 : ℝ) - 1 / 2 := by norm_num
  have halfUtilityPositive : 0 < utility params theta (1 / 2) othersEffort firmSize := by
    unfold utility
    exact mul_pos (Real.rpow_pos_of_pos halfIncomePositive theta)
      (Real.rpow_pos_of_pos halfLeisurePositive (1 - theta))
  have oneUtilityZero : utility params theta 1 othersEffort firmSize = 0 := by
    unfold utility
    rw [sub_self, Real.zero_rpow (sub_pos.mpr thetaAtMostOne).ne']
    ring
  rw [oneUtilityZero] at comparison
  linarith

theorem bestResponse_lt_one (params : Params) (theta othersEffort : ℝ)
    (firmSize : Nat) (effort : ℝ)
    (best : IsBestResponse params theta othersEffort firmSize effort)
    (aPositive : 0 < params.a) (bNonnegative : 0 ≤ params.b)
    (othersNonnegative : 0 ≤ othersEffort) (thetaAtMostOne : theta < 1)
    (firmSizePositive : 0 < firmSize) : effort < 1 := by
  have effortAtMostOne : effort ≤ 1 := best.1.2
  exact lt_of_le_of_ne effortAtMostOne fun effortEqOne =>
    one_not_bestResponse params theta othersEffort firmSize aPositive bNonnegative
      othersNonnegative thetaAtMostOne firmSizePositive (effortEqOne ▸ best)

end AgenticAxtell.Baseline
