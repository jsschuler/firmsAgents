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

/-- Preference weight above which zero own effort has positive marginal log
utility in the quadratic model. -/
noncomputable def quadraticParticipationThreshold (params : Params)
    (othersEffort : ℝ) : ℝ :=
  (params.a * othersEffort + params.b * othersEffort ^ 2) /
    ((params.a * othersEffort + params.b * othersEffort ^ 2) +
      (params.a + 2 * params.b * othersEffort))

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

theorem marginalLogUtility_neg_iff_score_neg (params : Params)
    (theta effort othersEffort : ℝ) (firmSize : Nat)
    (outputPositive : 0 < production params (effort + othersEffort))
    (effortBelowOne : effort < 1) (firmSizePositive : 0 < firmSize) :
    marginalLogUtility params theta effort othersEffort firmSize < 0 ↔
      nonlinearFirstOrderScore params theta effort othersEffort < 0 := by
  rw [marginalLogUtility_eq_score_div params theta effort othersEffort firmSize
    outputPositive effortBelowOne firmSizePositive]
  have denominatorPositive :
      0 < (1 - effort) * production params (effort + othersEffort) :=
    mul_pos (sub_pos.mpr effortBelowOne) outputPositive
  rw [div_neg_iff]
  simp [denominatorPositive, not_lt_of_ge denominatorPositive.le]

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

/-- Exact effect of changing coworker effort on the quadratic score at fixed
own effort. The bracket separates the cooperative marginal-product effect from
the free-riding effect. -/
theorem nonlinearFirstOrderScore_beta_two_others_sub (params : Params)
    (theta effort firstOthers secondOthers : ℝ) (betaTwo : params.beta = 2) :
    nonlinearFirstOrderScore params theta effort secondOthers -
        nonlinearFirstOrderScore params theta effort firstOthers =
      (secondOthers - firstOthers) *
        (2 * params.b * theta * (1 - effort) -
          (1 - theta) *
            (params.a + 2 * params.b * effort +
              params.b * (firstOthers + secondOthers))) := by
  rw [nonlinearFirstOrderScore_beta_two params theta effort secondOthers betaTwo,
    nonlinearFirstOrderScore_beta_two params theta effort firstOthers betaTwo]
  ring

/-- A simple root-independent parameter bound that makes the coworker-effort
cross effect negative throughout feasible own effort and nonnegative coworker
effort. -/
theorem beta_two_crossEffect_negative_of_uniform_bound
    (params : Params) (theta effort firstOthers secondOthers : ℝ)
    (bNonnegative : 0 ≤ params.b) (thetaNonnegative : 0 ≤ theta)
    (thetaAtMostOne : theta ≤ 1) (effortNonnegative : 0 ≤ effort)
    (effortAtMostOne : effort ≤ 1) (firstOthersNonnegative : 0 ≤ firstOthers)
    (secondOthersNonnegative : 0 ≤ secondOthers)
    (uniformBound : 2 * params.b * theta < (1 - theta) * params.a) :
    2 * params.b * theta * (1 - effort) -
        (1 - theta) *
          (params.a + 2 * params.b * effort +
            params.b * (firstOthers + secondOthers)) < 0 := by
  have leisureNonnegative : 0 ≤ 1 - effort := by linarith
  have leisureAtMostOne : 1 - effort ≤ 1 := by linarith
  have cooperativeCoefficientNonnegative : 0 ≤ 2 * params.b * theta :=
    mul_nonneg (mul_nonneg (by norm_num) bNonnegative) thetaNonnegative
  have cooperativeBound :
      2 * params.b * theta * (1 - effort) ≤ 2 * params.b * theta := by
    nlinarith
  have extraNonnegative :
      0 ≤ 2 * params.b * effort + params.b * (firstOthers + secondOthers) := by
    have ownTermNonnegative : 0 ≤ 2 * params.b * effort := by positivity
    have othersTermNonnegative :
        0 ≤ params.b * (firstOthers + secondOthers) :=
      mul_nonneg bNonnegative (add_nonneg firstOthersNonnegative secondOthersNonnegative)
    linarith
  have leisureWeightNonnegative : 0 ≤ 1 - theta := sub_nonneg.mpr thetaAtMostOne
  have freeRidingLowerBound :
      (1 - theta) * params.a ≤
        (1 - theta) *
          (params.a + 2 * params.b * effort +
            params.b * (firstOthers + secondOthers)) :=
    mul_le_mul_of_nonneg_left (by linarith) leisureWeightNonnegative
  linarith

/-- A downward-opening quadratic score with positive value at zero has at most
one positive root, even when its initial slope is positive. -/
theorem positive_beta_two_scoreRoot_unique (params : Params)
    (theta othersEffort first second : ℝ) (betaTwo : params.beta = 2)
    (bNonnegative : 0 ≤ params.b) (thetaNonnegative : 0 ≤ theta)
    (scoreAtZeroPositive :
      0 < nonlinearFirstOrderScore params theta 0 othersEffort)
    (firstPositive : 0 < first) (secondPositive : 0 < second)
    (firstRoot : nonlinearFirstOrderScore params theta first othersEffort = 0)
    (secondRoot : nonlinearFirstOrderScore params theta second othersEffort = 0) :
    first = second := by
  have noOrderedDistinct : ∀ {smaller larger : ℝ}, 0 < smaller → 0 < larger →
      nonlinearFirstOrderScore params theta smaller othersEffort = 0 →
      nonlinearFirstOrderScore params theta larger othersEffort = 0 →
      smaller < larger → False := by
    intro smaller larger smallerPositive largerPositive smallerRoot largerRoot smallerLt
    have rootsDifference := nonlinearFirstOrderScore_beta_two_sub params theta
      othersEffort smaller larger betaTwo
    rw [smallerRoot, largerRoot] at rootsDifference
    have effortDifferenceNonzero : larger - smaller ≠ 0 := sub_ne_zero.mpr (Ne.symm smallerLt.ne)
    have pairedBracketZero :
        -params.a + 2 * params.b *
          (theta - othersEffort - ((1 + theta) / 2) * (smaller + larger)) = 0 :=
      (mul_eq_zero.mp (by simpa using rootsDifference)).resolve_left effortDifferenceNonzero
    have fromZero := nonlinearFirstOrderScore_beta_two_sub params theta othersEffort
      0 smaller betaTwo
    rw [smallerRoot] at fromZero
    have curvatureNonnegative : 0 ≤ params.b * (1 + theta) * larger :=
      mul_nonneg (mul_nonneg bNonnegative (by linarith)) largerPositive.le
    nlinarith
  rcases lt_trichotomy first second with firstLt | equal | secondLt
  · exact (noOrderedDistinct firstPositive secondPositive firstRoot secondRoot firstLt).elim
  · exact equal
  · exact (noOrderedDistinct secondPositive firstPositive secondRoot firstRoot secondLt).elim

theorem beta_two_score_positive_before_positiveRoot (params : Params)
    (theta othersEffort root effort : ℝ) (betaTwo : params.beta = 2)
    (bNonnegative : 0 ≤ params.b) (thetaNonnegative : 0 ≤ theta)
    (scoreAtZeroPositive :
      0 < nonlinearFirstOrderScore params theta 0 othersEffort)
    (rootPositive : 0 < root)
    (rootScoreZero : nonlinearFirstOrderScore params theta root othersEffort = 0)
    (effortNonnegative : 0 ≤ effort) (effortLtRoot : effort < root) :
    0 < nonlinearFirstOrderScore params theta effort othersEffort := by
  have rootFromZero := nonlinearFirstOrderScore_beta_two_sub params theta
    othersEffort 0 root betaTwo
  rw [rootScoreZero] at rootFromZero
  have zeroRootBracketNegative :
      -params.a + 2 * params.b *
        (theta - othersEffort - ((1 + theta) / 2) * root) < 0 := by
    nlinarith
  have correctionNonnegative : 0 ≤ params.b * (1 + theta) * effort :=
    mul_nonneg (mul_nonneg bNonnegative (by linarith)) effortNonnegative
  have effortRootBracketNegative :
      -params.a + 2 * params.b *
        (theta - othersEffort - ((1 + theta) / 2) * (effort + root)) < 0 := by
    nlinarith
  have difference := nonlinearFirstOrderScore_beta_two_sub params theta
    othersEffort effort root betaTwo
  rw [rootScoreZero] at difference
  have rootMinusEffortPositive : 0 < root - effort := sub_pos.mpr effortLtRoot
  nlinarith [mul_neg_of_pos_of_neg rootMinusEffortPositive effortRootBracketNegative]

theorem beta_two_score_negative_after_positiveRoot (params : Params)
    (theta othersEffort root effort : ℝ) (betaTwo : params.beta = 2)
    (bNonnegative : 0 ≤ params.b) (thetaNonnegative : 0 ≤ theta)
    (scoreAtZeroPositive :
      0 < nonlinearFirstOrderScore params theta 0 othersEffort)
    (rootPositive : 0 < root)
    (rootScoreZero : nonlinearFirstOrderScore params theta root othersEffort = 0)
    (rootLtEffort : root < effort) :
    nonlinearFirstOrderScore params theta effort othersEffort < 0 := by
  have rootFromZero := nonlinearFirstOrderScore_beta_two_sub params theta
    othersEffort 0 root betaTwo
  rw [rootScoreZero] at rootFromZero
  have zeroRootBracketNegative :
      -params.a + 2 * params.b *
        (theta - othersEffort - ((1 + theta) / 2) * root) < 0 := by
    nlinarith
  have rootEffortSumPositive : 0 < root + effort := by linarith
  have correctionNonnegative : 0 ≤ params.b * (1 + theta) * (root + effort) :=
    mul_nonneg (mul_nonneg bNonnegative (by linarith)) rootEffortSumPositive.le
  have rootEffortBracketNegative :
      -params.a + 2 * params.b *
        (theta - othersEffort - ((1 + theta) / 2) * (root + effort)) < 0 := by
    nlinarith
  have difference := nonlinearFirstOrderScore_beta_two_sub params theta
    othersEffort root effort betaTwo
  rw [rootScoreZero] at difference
  have effortMinusRootPositive : 0 < effort - root := sub_pos.mpr rootLtEffort
  nlinarith [mul_neg_of_pos_of_neg effortMinusRootPositive rootEffortBracketNegative]

/-- Positive quadratic score roots decrease with coworker effort whenever the
free-riding term dominates the cooperative marginal-product term at the first
root. -/
theorem beta_two_positive_scoreRoot_decreases_of_crossEffect_negative
    (params : Params) (theta firstOthers secondOthers firstRoot secondRoot : ℝ)
    (betaTwo : params.beta = 2) (bNonnegative : 0 ≤ params.b)
    (thetaNonnegative : 0 ≤ theta) (othersIncrease : firstOthers < secondOthers)
    (secondScoreAtZeroPositive :
      0 < nonlinearFirstOrderScore params theta 0 secondOthers)
    (firstRootPositive : 0 < firstRoot) (secondRootPositive : 0 < secondRoot)
    (firstRootEquation : nonlinearFirstOrderScore params theta firstRoot firstOthers = 0)
    (secondRootEquation : nonlinearFirstOrderScore params theta secondRoot secondOthers = 0)
    (crossEffectNegative :
      2 * params.b * theta * (1 - firstRoot) -
          (1 - theta) * (params.a + 2 * params.b * firstRoot +
            params.b * (firstOthers + secondOthers)) < 0) :
    secondRoot < firstRoot := by
  have scoreDifference := nonlinearFirstOrderScore_beta_two_others_sub params theta
    firstRoot firstOthers secondOthers betaTwo
  rw [firstRootEquation] at scoreDifference
  have secondScoreAtFirstRootNegative :
      nonlinearFirstOrderScore params theta firstRoot secondOthers < 0 := by
    calc
      nonlinearFirstOrderScore params theta firstRoot secondOthers =
          nonlinearFirstOrderScore params theta firstRoot secondOthers - 0 := by ring
      _ = (secondOthers - firstOthers) *
          (2 * params.b * theta * (1 - firstRoot) -
            (1 - theta) * (params.a + 2 * params.b * firstRoot +
              params.b * (firstOthers + secondOthers))) := scoreDifference
      _ < 0 := mul_neg_of_pos_of_neg (sub_pos.mpr othersIncrease) crossEffectNegative
  by_contra! firstRootLeSecond
  rcases firstRootLeSecond.eq_or_lt with equal | firstRootLtSecond
  · rw [equal, secondRootEquation] at secondScoreAtFirstRootNegative
    linarith
  · have scorePositive := beta_two_score_positive_before_positiveRoot params theta
      secondOthers secondRoot firstRoot betaTwo bNonnegative thetaNonnegative
      secondScoreAtZeroPositive secondRootPositive secondRootEquation
      firstRootPositive.le firstRootLtSecond
    linarith

theorem beta_two_positive_scoreRoot_decreases_of_uniform_bound
    (params : Params) (theta firstOthers secondOthers firstRoot secondRoot : ℝ)
    (betaTwo : params.beta = 2) (bNonnegative : 0 ≤ params.b)
    (thetaNonnegative : 0 ≤ theta) (thetaAtMostOne : theta ≤ 1)
    (firstOthersNonnegative : 0 ≤ firstOthers)
    (othersIncrease : firstOthers < secondOthers)
    (secondScoreAtZeroPositive :
      0 < nonlinearFirstOrderScore params theta 0 secondOthers)
    (firstRootPositive : 0 < firstRoot) (firstRootAtMostOne : firstRoot ≤ 1)
    (secondRootPositive : 0 < secondRoot)
    (firstRootEquation : nonlinearFirstOrderScore params theta firstRoot firstOthers = 0)
    (secondRootEquation : nonlinearFirstOrderScore params theta secondRoot secondOthers = 0)
    (uniformBound : 2 * params.b * theta < (1 - theta) * params.a) :
    secondRoot < firstRoot := by
  have crossEffectNegative := beta_two_crossEffect_negative_of_uniform_bound params
    theta firstRoot firstOthers secondOthers bNonnegative thetaNonnegative
    thetaAtMostOne firstRootPositive.le firstRootAtMostOne firstOthersNonnegative
    (le_trans firstOthersNonnegative othersIncrease.le) uniformBound
  exact beta_two_positive_scoreRoot_decreases_of_crossEffect_negative params theta
    firstOthers secondOthers firstRoot secondRoot betaTwo bNonnegative thetaNonnegative
    othersIncrease secondScoreAtZeroPositive firstRootPositive secondRootPositive
    firstRootEquation secondRootEquation crossEffectNegative

/-- Quantitative approach-to-threshold bound. The positive root is at most the
score-at-zero surplus divided by the strictly positive initial-slope margin. -/
theorem beta_two_positive_scoreRoot_mul_slopeMargin_le_scoreAtZero
    (params : Params) (theta othersEffort root : ℝ) (betaTwo : params.beta = 2)
    (bNonnegative : 0 ≤ params.b) (thetaNonnegative : 0 ≤ theta)
    (rootEquation : nonlinearFirstOrderScore params theta root othersEffort = 0) :
    root * (params.a - 2 * params.b * (theta - othersEffort)) ≤
      nonlinearFirstOrderScore params theta 0 othersEffort := by
  have difference := nonlinearFirstOrderScore_beta_two_sub params theta
    othersEffort 0 root betaTwo
  rw [rootEquation] at difference
  have curvatureCorrectionNonnegative :
      0 ≤ params.b * (1 + theta) * root ^ 2 := by
    have weightNonnegative : 0 ≤ 1 + theta := by linarith
    positivity
  nlinarith

theorem beta_two_positive_scoreRoot_le_scoreAtZero_div_slopeMargin
    (params : Params) (theta othersEffort root : ℝ) (betaTwo : params.beta = 2)
    (bNonnegative : 0 ≤ params.b) (thetaNonnegative : 0 ≤ theta)
    (rootEquation : nonlinearFirstOrderScore params theta root othersEffort = 0)
    (slopeAtZeroNegative : 2 * params.b * (theta - othersEffort) < params.a) :
    root ≤ nonlinearFirstOrderScore params theta 0 othersEffort /
      (params.a - 2 * params.b * (theta - othersEffort)) := by
  have marginPositive :
      0 < params.a - 2 * params.b * (theta - othersEffort) := by linarith
  apply (le_div_iff₀ marginPositive).2
  exact beta_two_positive_scoreRoot_mul_slopeMargin_le_scoreAtZero params theta
    othersEffort root betaTwo bNonnegative thetaNonnegative rootEquation

/-- Epsilon form of the threshold estimate: a score-at-zero surplus smaller
than `epsilon` times the slope margin forces the positive root below `epsilon`. -/
theorem beta_two_positive_scoreRoot_lt_epsilon
    (params : Params) (theta othersEffort root epsilon : ℝ)
    (betaTwo : params.beta = 2) (bNonnegative : 0 ≤ params.b)
    (thetaNonnegative : 0 ≤ theta)
    (rootEquation : nonlinearFirstOrderScore params theta root othersEffort = 0)
    (slopeAtZeroNegative : 2 * params.b * (theta - othersEffort) < params.a)
    (scoreAtZeroSmall : nonlinearFirstOrderScore params theta 0 othersEffort <
      epsilon * (params.a - 2 * params.b * (theta - othersEffort))) :
    root < epsilon := by
  have rootTimesMarginLe :=
    beta_two_positive_scoreRoot_mul_slopeMargin_le_scoreAtZero params theta
      othersEffort root betaTwo bNonnegative thetaNonnegative rootEquation
  have marginPositive :
      0 < params.a - 2 * params.b * (theta - othersEffort) := by linarith
  nlinarith

theorem logUtility_strictMonoOn_positiveInterval_to_beta_two_root
    (params : Params) (theta othersEffort lower root : ℝ) (firmSize : Nat)
    (aPositive : 0 < params.a) (bNonnegative : 0 ≤ params.b)
    (thetaNonnegative : 0 ≤ theta) (othersNonnegative : 0 ≤ othersEffort)
    (lowerPositive : 0 < lower) (lowerLeRoot : lower ≤ root)
    (rootBelowOne : root < 1) (firmSizePositive : 0 < firmSize)
    (betaTwo : params.beta = 2)
    (scoreAtZeroPositive :
      0 < nonlinearFirstOrderScore params theta 0 othersEffort)
    (rootScoreZero : nonlinearFirstOrderScore params theta root othersEffort = 0) :
    StrictMonoOn (fun effort => logUtility params theta effort othersEffort firmSize)
      (Set.Icc lower root) := by
  have rootPositive : 0 < root := lt_of_lt_of_le lowerPositive lowerLeRoot
  apply strictMonoOn_of_deriv_pos (convex_Icc lower root)
  · intro effort effortMem
    have effortPositive : 0 < effort := lt_of_lt_of_le lowerPositive effortMem.1
    have totalPositive : 0 < effort + othersEffort := by linarith
    have effortBelowOne : effort < 1 := lt_of_le_of_lt effortMem.2 rootBelowOne
    exact (hasDerivAt_logUtility_interior params theta effort othersEffort firmSize
      aPositive bNonnegative totalPositive effortBelowOne firmSizePositive).continuousAt
      |>.continuousWithinAt
  · intro effort effortInterior
    rw [interior_Icc] at effortInterior
    have effortPositive : 0 < effort := lt_trans lowerPositive effortInterior.1
    have effortLtRoot : effort < root := effortInterior.2
    have effortBelowOne : effort < 1 := lt_trans effortLtRoot rootBelowOne
    have totalPositive : 0 < effort + othersEffort := by linarith
    have scorePositive := beta_two_score_positive_before_positiveRoot params theta
      othersEffort root effort betaTwo bNonnegative thetaNonnegative scoreAtZeroPositive
      rootPositive rootScoreZero effortPositive.le effortLtRoot
    have marginalPositive :=
      (marginalLogUtility_pos_iff_score_pos params theta effort othersEffort firmSize
        (production_positive_of_a_pos params _ aPositive bNonnegative totalPositive)
        effortBelowOne firmSizePositive).2 scorePositive
    rw [(hasDerivAt_logUtility_interior params theta effort othersEffort firmSize
      aPositive bNonnegative totalPositive effortBelowOne firmSizePositive).deriv]
    exact marginalPositive

theorem logUtility_strictMonoOn_to_beta_two_root_of_positive_scoreAtZero
    (params : Params) (theta othersEffort root : ℝ) (firmSize : Nat)
    (aPositive : 0 < params.a) (bNonnegative : 0 ≤ params.b)
    (thetaNonnegative : 0 ≤ theta) (othersPositive : 0 < othersEffort)
    (rootPositive : 0 < root) (rootBelowOne : root < 1)
    (firmSizePositive : 0 < firmSize) (betaTwo : params.beta = 2)
    (scoreAtZeroPositive :
      0 < nonlinearFirstOrderScore params theta 0 othersEffort)
    (rootScoreZero : nonlinearFirstOrderScore params theta root othersEffort = 0) :
    StrictMonoOn (fun effort => logUtility params theta effort othersEffort firmSize)
      (Set.Icc 0 root) := by
  apply strictMonoOn_of_deriv_pos (convex_Icc (0 : ℝ) root)
  · intro effort effortMem
    have totalPositive : 0 < effort + othersEffort := by linarith [effortMem.1]
    have effortBelowOne : effort < 1 := lt_of_le_of_lt effortMem.2 rootBelowOne
    exact (hasDerivAt_logUtility_interior params theta effort othersEffort firmSize
      aPositive bNonnegative totalPositive effortBelowOne firmSizePositive).continuousAt
      |>.continuousWithinAt
  · intro effort effortInterior
    rw [interior_Icc] at effortInterior
    have effortPositive : 0 < effort := effortInterior.1
    have effortLtRoot : effort < root := effortInterior.2
    have effortBelowOne : effort < 1 := lt_trans effortLtRoot rootBelowOne
    have totalPositive : 0 < effort + othersEffort := by linarith
    have scorePositive := beta_two_score_positive_before_positiveRoot params theta
      othersEffort root effort betaTwo bNonnegative thetaNonnegative scoreAtZeroPositive
      rootPositive rootScoreZero effortPositive.le effortLtRoot
    have marginalPositive :=
      (marginalLogUtility_pos_iff_score_pos params theta effort othersEffort firmSize
        (production_positive_of_a_pos params _ aPositive bNonnegative totalPositive)
        effortBelowOne firmSizePositive).2 scorePositive
    rw [(hasDerivAt_logUtility_interior params theta effort othersEffort firmSize
      aPositive bNonnegative totalPositive effortBelowOne firmSizePositive).deriv]
    exact marginalPositive

theorem logUtility_strictAntiOn_beta_two_root_to_interior
    (params : Params) (theta othersEffort root upper : ℝ) (firmSize : Nat)
    (aPositive : 0 < params.a) (bNonnegative : 0 ≤ params.b)
    (thetaNonnegative : 0 ≤ theta) (othersNonnegative : 0 ≤ othersEffort)
    (rootPositive : 0 < root) (upperBelowOne : upper < 1)
    (firmSizePositive : 0 < firmSize) (betaTwo : params.beta = 2)
    (scoreAtZeroPositive :
      0 < nonlinearFirstOrderScore params theta 0 othersEffort)
    (rootScoreZero : nonlinearFirstOrderScore params theta root othersEffort = 0) :
    StrictAntiOn (fun effort => logUtility params theta effort othersEffort firmSize)
      (Set.Icc root upper) := by
  apply strictAntiOn_of_deriv_neg (convex_Icc root upper)
  · intro effort effortMem
    have totalPositive : 0 < effort + othersEffort := by
      linarith [effortMem.1, rootPositive, othersNonnegative]
    have effortBelowOne : effort < 1 := lt_of_le_of_lt effortMem.2 upperBelowOne
    exact (hasDerivAt_logUtility_interior params theta effort othersEffort firmSize
      aPositive bNonnegative totalPositive effortBelowOne firmSizePositive).continuousAt
      |>.continuousWithinAt
  · intro effort effortInterior
    rw [interior_Icc] at effortInterior
    have rootLtEffort : root < effort := effortInterior.1
    have effortBelowOne : effort < 1 := lt_trans effortInterior.2 upperBelowOne
    have totalPositive : 0 < effort + othersEffort := by linarith
    have scoreNegative := beta_two_score_negative_after_positiveRoot params theta
      othersEffort root effort betaTwo bNonnegative thetaNonnegative scoreAtZeroPositive
      rootPositive rootScoreZero rootLtEffort
    have marginalNegative :=
      (marginalLogUtility_neg_iff_score_neg params theta effort othersEffort firmSize
        (production_positive_of_a_pos params _ aPositive bNonnegative totalPositive)
        effortBelowOne firmSizePositive).2 scoreNegative
    rw [(hasDerivAt_logUtility_interior params theta effort othersEffort firmSize
      aPositive bNonnegative totalPositive effortBelowOne firmSizePositive).deriv]
    exact marginalNegative

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

/-- When the quadratic score decreases and vanishes at a positive interior
root, log utility rises strictly from zero effort to that root. Positive
coworker effort keeps income positive at the left endpoint. -/
theorem logUtility_strictMonoOn_to_beta_two_scoreRoot
    (params : Params) (theta othersEffort root : ℝ) (firmSize : Nat)
    (aPositive : 0 < params.a) (bNonnegative : 0 ≤ params.b)
    (thetaNonnegative : 0 ≤ theta) (othersPositive : 0 < othersEffort)
    (rootPositive : 0 < root) (rootBelowOne : root < 1)
    (firmSizePositive : 0 < firmSize) (betaTwo : params.beta = 2)
    (slopeAtZeroNegative : 2 * params.b * (theta - othersEffort) < params.a)
    (rootScoreZero : nonlinearFirstOrderScore params theta root othersEffort = 0) :
    StrictMonoOn (fun effort => logUtility params theta effort othersEffort firmSize)
      (Set.Icc 0 root) := by
  have scoreStrictAnti := nonlinearFirstOrderScore_beta_two_strictAntiOn_nonnegative
    params theta othersEffort betaTwo bNonnegative thetaNonnegative slopeAtZeroNegative
  apply strictMonoOn_of_deriv_pos (convex_Icc (0 : ℝ) root)
  · intro effort effortMem
    have totalPositive : 0 < effort + othersEffort := by linarith [effortMem.1]
    have effortBelowOne : effort < 1 := lt_of_le_of_lt effortMem.2 rootBelowOne
    exact (hasDerivAt_logUtility_interior params theta effort othersEffort firmSize
      aPositive bNonnegative totalPositive effortBelowOne firmSizePositive).continuousAt
      |>.continuousWithinAt
  · intro effort effortInterior
    rw [interior_Icc] at effortInterior
    have effortPositive : 0 < effort := effortInterior.1
    have effortLtRoot : effort < root := effortInterior.2
    have effortBelowOne : effort < 1 := lt_trans effortLtRoot rootBelowOne
    have totalPositive : 0 < effort + othersEffort := by linarith
    have scoreComparison := scoreStrictAnti effortPositive.le rootPositive.le effortLtRoot
    change nonlinearFirstOrderScore params theta root othersEffort <
      nonlinearFirstOrderScore params theta effort othersEffort at scoreComparison
    rw [rootScoreZero] at scoreComparison
    have marginalPositive :=
      (marginalLogUtility_pos_iff_score_pos params theta effort othersEffort firmSize
        (production_positive_of_a_pos params _ aPositive bNonnegative totalPositive)
        effortBelowOne firmSizePositive).2 scoreComparison
    rw [(hasDerivAt_logUtility_interior params theta effort othersEffort firmSize
      aPositive bNonnegative totalPositive effortBelowOne firmSizePositive).deriv]
    exact marginalPositive

theorem logUtility_strictMonoOn_between_positive_and_beta_two_scoreRoot
    (params : Params) (theta othersEffort lower root : ℝ) (firmSize : Nat)
    (aPositive : 0 < params.a) (bNonnegative : 0 ≤ params.b)
    (thetaNonnegative : 0 ≤ theta) (othersNonnegative : 0 ≤ othersEffort)
    (lowerPositive : 0 < lower) (lowerLeRoot : lower ≤ root)
    (rootBelowOne : root < 1) (firmSizePositive : 0 < firmSize)
    (betaTwo : params.beta = 2)
    (slopeAtZeroNegative : 2 * params.b * (theta - othersEffort) < params.a)
    (rootScoreZero : nonlinearFirstOrderScore params theta root othersEffort = 0) :
    StrictMonoOn (fun effort => logUtility params theta effort othersEffort firmSize)
      (Set.Icc lower root) := by
  have scoreStrictAnti := nonlinearFirstOrderScore_beta_two_strictAntiOn_nonnegative
    params theta othersEffort betaTwo bNonnegative thetaNonnegative slopeAtZeroNegative
  apply strictMonoOn_of_deriv_pos (convex_Icc lower root)
  · intro effort effortMem
    have effortPositive : 0 < effort := lt_of_lt_of_le lowerPositive effortMem.1
    have totalPositive : 0 < effort + othersEffort := by linarith
    have effortBelowOne : effort < 1 := lt_of_le_of_lt effortMem.2 rootBelowOne
    exact (hasDerivAt_logUtility_interior params theta effort othersEffort firmSize
      aPositive bNonnegative totalPositive effortBelowOne firmSizePositive).continuousAt
      |>.continuousWithinAt
  · intro effort effortInterior
    rw [interior_Icc] at effortInterior
    have effortPositive : 0 < effort := lt_trans lowerPositive effortInterior.1
    have effortLtRoot : effort < root := effortInterior.2
    have rootNonnegative : 0 ≤ root := le_trans lowerPositive.le lowerLeRoot
    have effortBelowOne : effort < 1 := lt_trans effortLtRoot rootBelowOne
    have totalPositive : 0 < effort + othersEffort := by
      linarith [effortPositive, othersNonnegative]
    have scoreComparison := scoreStrictAnti effortPositive.le rootNonnegative effortLtRoot
    change nonlinearFirstOrderScore params theta root othersEffort <
      nonlinearFirstOrderScore params theta effort othersEffort at scoreComparison
    rw [rootScoreZero] at scoreComparison
    have marginalPositive :=
      (marginalLogUtility_pos_iff_score_pos params theta effort othersEffort firmSize
        (production_positive_of_a_pos params _ aPositive bNonnegative totalPositive)
        effortBelowOne firmSizePositive).2 scoreComparison
    rw [(hasDerivAt_logUtility_interior params theta effort othersEffort firmSize
      aPositive bNonnegative totalPositive effortBelowOne firmSizePositive).deriv]
    exact marginalPositive

theorem logUtility_strictAntiOn_from_beta_two_scoreRoot
    (params : Params) (theta othersEffort root upper : ℝ) (firmSize : Nat)
    (aPositive : 0 < params.a) (bNonnegative : 0 ≤ params.b)
    (thetaNonnegative : 0 ≤ theta) (othersNonnegative : 0 ≤ othersEffort)
    (rootPositive : 0 < root)
    (upperBelowOne : upper < 1) (firmSizePositive : 0 < firmSize)
    (betaTwo : params.beta = 2)
    (slopeAtZeroNegative : 2 * params.b * (theta - othersEffort) < params.a)
    (rootScoreZero : nonlinearFirstOrderScore params theta root othersEffort = 0) :
    StrictAntiOn (fun effort => logUtility params theta effort othersEffort firmSize)
      (Set.Icc root upper) := by
  have scoreStrictAnti := nonlinearFirstOrderScore_beta_two_strictAntiOn_nonnegative
    params theta othersEffort betaTwo bNonnegative thetaNonnegative slopeAtZeroNegative
  have rootNonnegative : 0 ≤ root := rootPositive.le
  apply strictAntiOn_of_deriv_neg (convex_Icc root upper)
  · intro effort effortMem
    have effortNonnegative : 0 ≤ effort := le_trans rootNonnegative effortMem.1
    have totalPositive : 0 < effort + othersEffort := by
      linarith [effortMem.1, rootPositive, othersNonnegative]
    have effortBelowOne : effort < 1 := lt_of_le_of_lt effortMem.2 upperBelowOne
    exact (hasDerivAt_logUtility_interior params theta effort othersEffort firmSize
      aPositive bNonnegative totalPositive effortBelowOne firmSizePositive).continuousAt
      |>.continuousWithinAt
  · intro effort effortInterior
    rw [interior_Icc] at effortInterior
    have rootLtEffort : root < effort := effortInterior.1
    have effortLtUpper : effort < upper := effortInterior.2
    have effortNonnegative : 0 ≤ effort := le_trans rootNonnegative rootLtEffort.le
    have effortBelowOne : effort < 1 := lt_trans effortLtUpper upperBelowOne
    have totalPositive : 0 < effort + othersEffort := by
      linarith [rootPositive, othersNonnegative]
    have scoreComparison := scoreStrictAnti rootNonnegative effortNonnegative rootLtEffort
    change nonlinearFirstOrderScore params theta effort othersEffort <
      nonlinearFirstOrderScore params theta root othersEffort at scoreComparison
    rw [rootScoreZero] at scoreComparison
    have marginalNegative :=
      (marginalLogUtility_neg_iff_score_neg params theta effort othersEffort firmSize
        (production_positive_of_a_pos params _ aPositive bNonnegative totalPositive)
        effortBelowOne firmSizePositive).2 scoreComparison
    rw [(hasDerivAt_logUtility_interior params theta effort othersEffort firmSize
      aPositive bNonnegative totalPositive effortBelowOne firmSizePositive).deriv]
    exact marginalNegative

theorem logUtility_strictAntiOn_of_nonpositive_scoreAtZero
    (params : Params) (theta othersEffort upper : ℝ) (firmSize : Nat)
    (aPositive : 0 < params.a) (bNonnegative : 0 ≤ params.b)
    (thetaNonnegative : 0 ≤ theta) (othersPositive : 0 < othersEffort)
    (upperBelowOne : upper < 1)
    (firmSizePositive : 0 < firmSize) (betaTwo : params.beta = 2)
    (slopeAtZeroNegative : 2 * params.b * (theta - othersEffort) < params.a)
    (scoreAtZeroNonpositive :
      nonlinearFirstOrderScore params theta 0 othersEffort ≤ 0) :
    StrictAntiOn (fun effort => logUtility params theta effort othersEffort firmSize)
      (Set.Icc 0 upper) := by
  have scoreStrictAnti := nonlinearFirstOrderScore_beta_two_strictAntiOn_nonnegative
    params theta othersEffort betaTwo bNonnegative thetaNonnegative slopeAtZeroNegative
  apply strictAntiOn_of_deriv_neg (convex_Icc (0 : ℝ) upper)
  · intro effort effortMem
    have totalPositive : 0 < effort + othersEffort := by linarith [effortMem.1]
    have effortBelowOne : effort < 1 := lt_of_le_of_lt effortMem.2 upperBelowOne
    exact (hasDerivAt_logUtility_interior params theta effort othersEffort firmSize
      aPositive bNonnegative totalPositive effortBelowOne firmSizePositive).continuousAt
      |>.continuousWithinAt
  · intro effort effortInterior
    rw [interior_Icc] at effortInterior
    have effortPositive : 0 < effort := effortInterior.1
    have effortBelowOne : effort < 1 := lt_trans effortInterior.2 upperBelowOne
    have totalPositive : 0 < effort + othersEffort := by linarith
    have scoreComparison := scoreStrictAnti (show (0 : ℝ) ∈ Set.Ici 0 by simp)
      effortPositive.le effortPositive
    change nonlinearFirstOrderScore params theta effort othersEffort <
      nonlinearFirstOrderScore params theta 0 othersEffort at scoreComparison
    have scoreNegative : nonlinearFirstOrderScore params theta effort othersEffort < 0 :=
      lt_of_lt_of_le scoreComparison scoreAtZeroNonpositive
    have marginalNegative :=
      (marginalLogUtility_neg_iff_score_neg params theta effort othersEffort firmSize
        (production_positive_of_a_pos params _ aPositive bNonnegative totalPositive)
        effortBelowOne firmSizePositive).2 scoreNegative
    rw [(hasDerivAt_logUtility_interior params theta effort othersEffort firmSize
      aPositive bNonnegative totalPositive effortBelowOne firmSizePositive).deriv]
    exact marginalNegative

theorem zero_is_bestResponse_of_nonpositive_scoreAtZero
    (params : Params) (theta othersEffort : ℝ) (firmSize : Nat)
    (aPositive : 0 < params.a) (bNonnegative : 0 ≤ params.b)
    (thetaNonnegative : 0 ≤ theta) (thetaAtMostOne : theta < 1)
    (othersPositive : 0 < othersEffort) (firmSizePositive : 0 < firmSize)
    (betaTwo : params.beta = 2)
    (slopeAtZeroNegative : 2 * params.b * (theta - othersEffort) < params.a)
    (scoreAtZeroNonpositive :
      nonlinearFirstOrderScore params theta 0 othersEffort ≤ 0) :
    IsBestResponse params theta othersEffort firmSize 0 := by
  refine ⟨by simp [FeasibleEffort], ?_⟩
  intro alternative alternativeFeasible
  have firmSizeCastPositive : 0 < (firmSize : ℝ) := by exact_mod_cast firmSizePositive
  have zeroOutputPositive : 0 < production params othersEffort :=
    production_positive_of_a_pos params othersEffort aPositive bNonnegative othersPositive
  have zeroIncomePositive : 0 < production params (0 + othersEffort) / firmSize := by
    simpa using div_pos zeroOutputPositive firmSizeCastPositive
  have zeroUtilityPositive : 0 < utility params theta 0 othersEffort firmSize := by
    unfold utility
    exact mul_pos (Real.rpow_pos_of_pos zeroIncomePositive theta)
      (Real.rpow_pos_of_pos (by norm_num) (1 - theta))
  by_cases alternativeZero : alternative = 0
  · simp [alternativeZero]
  have alternativePositive : 0 < alternative :=
    lt_of_le_of_ne alternativeFeasible.1 (Ne.symm alternativeZero)
  by_cases alternativeOne : alternative = 1
  · subst alternative
    have oneUtilityZero : utility params theta 1 othersEffort firmSize = 0 := by
      unfold utility
      rw [sub_self, Real.zero_rpow (sub_pos.mpr thetaAtMostOne).ne']
      ring
    rw [oneUtilityZero]
    exact zeroUtilityPositive.le
  have alternativeBelowOne : alternative < 1 :=
    lt_of_le_of_ne alternativeFeasible.2 alternativeOne
  have strictDecrease := logUtility_strictAntiOn_of_nonpositive_scoreAtZero
    params theta othersEffort alternative firmSize aPositive bNonnegative
    thetaNonnegative othersPositive alternativeBelowOne firmSizePositive betaTwo
    slopeAtZeroNegative scoreAtZeroNonpositive
  have logStrict : logUtility params theta alternative othersEffort firmSize <
      logUtility params theta 0 othersEffort firmSize :=
    strictDecrease ⟨le_rfl, alternativePositive.le⟩
      ⟨alternativePositive.le, le_rfl⟩ alternativePositive
  have alternativeIncomePositive :
      0 < production params (alternative + othersEffort) / firmSize :=
    div_pos (production_positive_of_a_pos params _ aPositive bNonnegative (by linarith))
      firmSizeCastPositive
  have alternativeUtilityPositive :
      0 < utility params theta alternative othersEffort firmSize := by
    unfold utility
    exact mul_pos (Real.rpow_pos_of_pos alternativeIncomePositive theta)
      (Real.rpow_pos_of_pos (sub_pos.mpr alternativeBelowOne) (1 - theta))
  rw [← log_utility_eq_logUtility params theta alternative othersEffort firmSize
      alternativeIncomePositive (sub_pos.mpr alternativeBelowOne),
    ← log_utility_eq_logUtility params theta 0 othersEffort firmSize
      zeroIncomePositive (by norm_num)] at logStrict
  rw [← Real.exp_log alternativeUtilityPositive,
    ← Real.exp_log zeroUtilityPositive]
  exact (Real.exp_lt_exp.mpr logStrict).le

theorem zero_not_bestResponse_of_positive_beta_two_scoreRoot
    (params : Params) (theta othersEffort root : ℝ) (firmSize : Nat)
    (aPositive : 0 < params.a) (bNonnegative : 0 ≤ params.b)
    (thetaNonnegative : 0 ≤ theta) (othersPositive : 0 < othersEffort)
    (rootPositive : 0 < root) (rootBelowOne : root < 1)
    (firmSizePositive : 0 < firmSize) (betaTwo : params.beta = 2)
    (scoreAtZeroPositive :
      0 < nonlinearFirstOrderScore params theta 0 othersEffort)
    (rootScoreZero : nonlinearFirstOrderScore params theta root othersEffort = 0) :
    ¬ IsBestResponse params theta othersEffort firmSize 0 := by
  intro zeroBest
  have strictIncrease := logUtility_strictMonoOn_to_beta_two_root_of_positive_scoreAtZero
    params theta
    othersEffort root firmSize aPositive bNonnegative thetaNonnegative othersPositive
    rootPositive rootBelowOne firmSizePositive betaTwo scoreAtZeroPositive rootScoreZero
  have logStrict : logUtility params theta 0 othersEffort firmSize <
      logUtility params theta root othersEffort firmSize :=
    strictIncrease ⟨le_rfl, rootPositive.le⟩ ⟨rootPositive.le, le_rfl⟩ rootPositive
  have rootFeasible : root ∈ FeasibleEffort :=
    ⟨rootPositive.le, rootBelowOne.le⟩
  have utilityComparison := zeroBest.2 root rootFeasible
  have firmSizeCastPositive : 0 < (firmSize : ℝ) := by exact_mod_cast firmSizePositive
  have zeroOutputPositive := production_positive_of_a_pos params othersEffort aPositive
    bNonnegative othersPositive
  have rootTotalPositive : 0 < root + othersEffort := by linarith
  have rootOutputPositive := production_positive_of_a_pos params _ aPositive bNonnegative
    rootTotalPositive
  have zeroIncomePositive : 0 < production params (0 + othersEffort) / firmSize := by
    exact div_pos (by simpa using zeroOutputPositive) firmSizeCastPositive
  have rootIncomePositive : 0 < production params (root + othersEffort) / firmSize :=
    div_pos rootOutputPositive firmSizeCastPositive
  have zeroLeisurePositive : 0 < (1 : ℝ) - 0 := by norm_num
  have rootLeisurePositive : 0 < 1 - root := sub_pos.mpr rootBelowOne
  have zeroUtilityPositive : 0 < utility params theta 0 othersEffort firmSize := by
    unfold utility
    exact mul_pos (Real.rpow_pos_of_pos zeroIncomePositive theta)
      (Real.rpow_pos_of_pos zeroLeisurePositive (1 - theta))
  have rootUtilityPositive : 0 < utility params theta root othersEffort firmSize := by
    unfold utility
    exact mul_pos (Real.rpow_pos_of_pos rootIncomePositive theta)
      (Real.rpow_pos_of_pos rootLeisurePositive (1 - theta))
  have logComparison := Real.strictMonoOn_log.monotoneOn rootUtilityPositive
    zeroUtilityPositive utilityComparison
  rw [log_utility_eq_logUtility params theta root othersEffort firmSize
      rootIncomePositive rootLeisurePositive,
    log_utility_eq_logUtility params theta 0 othersEffort firmSize
      zeroIncomePositive zeroLeisurePositive] at logComparison
  exact (not_lt_of_ge logComparison) logStrict

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

theorem nonlinearFirstOrderScore_beta_two_at_one_negative
    (params : Params) (theta othersEffort : ℝ) (betaTwo : params.beta = 2)
    (aPositive : 0 < params.a) (bNonnegative : 0 ≤ params.b)
    (othersNonnegative : 0 ≤ othersEffort) (thetaAtMostOne : theta < 1) :
    nonlinearFirstOrderScore params theta 1 othersEffort < 0 := by
  rw [nonlinearFirstOrderScore_beta_two_at_one params theta othersEffort betaTwo]
  have totalPositive : 0 < 1 + othersEffort := by linarith
  have outputExpressionPositive :
      0 < params.a * (1 + othersEffort) +
        params.b * (1 + othersEffort) ^ 2 := by
    have linearPositive : 0 < params.a * (1 + othersEffort) :=
      mul_pos aPositive totalPositive
    have quadraticNonnegative :
        0 ≤ params.b * (1 + othersEffort) ^ 2 :=
      mul_nonneg bNonnegative (sq_nonneg _)
    linarith
  have negativeWeight : -(1 - theta) < 0 := neg_neg_of_pos (sub_pos.mpr thetaAtMostOne)
  exact mul_neg_of_neg_of_pos negativeWeight outputExpressionPositive

theorem nonlinearFirstOrderScore_beta_two_at_zero_positive_iff
    (params : Params) (theta othersEffort : ℝ) (betaTwo : params.beta = 2) :
    0 < nonlinearFirstOrderScore params theta 0 othersEffort ↔
      (1 - theta) *
          (params.a * othersEffort + params.b * othersEffort ^ 2) <
        theta * (params.a + 2 * params.b * othersEffort) := by
  rw [nonlinearFirstOrderScore_beta_two_at_zero params theta othersEffort betaTwo]
  exact sub_pos

theorem beta_two_incentiveAtZero_iff_theta_threshold
    (params : Params) (theta othersEffort : ℝ)
    (aPositive : 0 < params.a) (bNonnegative : 0 ≤ params.b)
    (othersPositive : 0 < othersEffort) :
    (1 - theta) *
          (params.a * othersEffort + params.b * othersEffort ^ 2) <
        theta * (params.a + 2 * params.b * othersEffort) ↔
      (params.a * othersEffort + params.b * othersEffort ^ 2) /
          ((params.a * othersEffort + params.b * othersEffort ^ 2) +
            (params.a + 2 * params.b * othersEffort)) < theta := by
  have outputPositive :
      0 < params.a * othersEffort + params.b * othersEffort ^ 2 := by
    have linearPositive : 0 < params.a * othersEffort := mul_pos aPositive othersPositive
    have cooperativeNonnegative : 0 ≤ params.b * othersEffort ^ 2 :=
      mul_nonneg bNonnegative (sq_nonneg _)
    linarith
  have marginalPositive : 0 < params.a + 2 * params.b * othersEffort := by
    have cooperativeNonnegative : 0 ≤ 2 * params.b * othersEffort := by positivity
    linarith
  have denominatorPositive :
      0 < (params.a * othersEffort + params.b * othersEffort ^ 2) +
        (params.a + 2 * params.b * othersEffort) := by linarith
  rw [div_lt_iff₀ denominatorPositive]
  constructor <;> intro incentive <;> nlinarith

/-- The participation threshold strictly increases with positive coworker
effort: greater effort supplied by others strengthens the zero-effort option. -/
theorem quadraticParticipationThreshold_strictMonoOn_positive
    (params : Params) (aPositive : 0 < params.a) (bNonnegative : 0 ≤ params.b) :
    StrictMonoOn (quadraticParticipationThreshold params) (Set.Ioi 0) := by
  intro first firstPositive second secondPositive firstLtSecond
  change 0 < first at firstPositive
  change 0 < second at secondPositive
  let output := fun effort : ℝ =>
    params.a * effort + params.b * effort ^ 2
  let marginal := fun effort : ℝ => params.a + 2 * params.b * effort
  have firstOutputPositive : 0 < output first := by
    dsimp [output]
    have linearPositive : 0 < params.a * first := mul_pos aPositive firstPositive
    have cooperativeNonnegative : 0 ≤ params.b * first ^ 2 :=
      mul_nonneg bNonnegative (sq_nonneg _)
    linarith
  have secondOutputPositive : 0 < output second := by
    dsimp [output]
    have linearPositive : 0 < params.a * second := mul_pos aPositive secondPositive
    have cooperativeNonnegative : 0 ≤ params.b * second ^ 2 :=
      mul_nonneg bNonnegative (sq_nonneg _)
    linarith
  have firstMarginalPositive : 0 < marginal first := by
    dsimp [marginal]
    have cooperativeNonnegative : 0 ≤ 2 * params.b * first := by positivity
    linarith
  have secondMarginalPositive : 0 < marginal second := by
    dsimp [marginal]
    have cooperativeNonnegative : 0 ≤ 2 * params.b * second := by positivity
    linarith
  have firstDenominatorPositive : 0 < output first + marginal first := by linarith
  have secondDenominatorPositive : 0 < output second + marginal second := by linarith
  unfold quadraticParticipationThreshold
  change output first / (output first + marginal first) <
    output second / (output second + marginal second)
  apply (div_lt_div_iff₀ firstDenominatorPositive secondDenominatorPositive).2
  have factorPositive :
      0 < params.a ^ 2 + params.a * params.b * first +
        params.a * params.b * second + 2 * params.b ^ 2 * first * second := by
    have squarePositive : 0 < params.a ^ 2 := sq_pos_of_pos aPositive
    have firstTermNonnegative : 0 ≤ params.a * params.b * first := by positivity
    have secondTermNonnegative : 0 ≤ params.a * params.b * second := by positivity
    have finalTermNonnegative : 0 ≤ 2 * params.b ^ 2 * first * second := by positivity
    linarith
  dsimp [output, marginal]
  nlinarith [mul_pos (sub_pos.mpr firstLtSecond) factorPositive]

theorem quadraticParticipationThreshold_mem_Ioo (params : Params)
    (othersEffort : ℝ) (aPositive : 0 < params.a) (bNonnegative : 0 ≤ params.b)
    (othersPositive : 0 < othersEffort) :
    quadraticParticipationThreshold params othersEffort ∈ Set.Ioo 0 1 := by
  have outputPositive :
      0 < params.a * othersEffort + params.b * othersEffort ^ 2 := by
    have linearPositive : 0 < params.a * othersEffort := mul_pos aPositive othersPositive
    have cooperativeNonnegative : 0 ≤ params.b * othersEffort ^ 2 :=
      mul_nonneg bNonnegative (sq_nonneg _)
    linarith
  have marginalPositive : 0 < params.a + 2 * params.b * othersEffort := by
    have cooperativeNonnegative : 0 ≤ 2 * params.b * othersEffort := by positivity
    linarith
  have denominatorPositive :
      0 < (params.a * othersEffort + params.b * othersEffort ^ 2) +
        (params.a + 2 * params.b * othersEffort) := by linarith
  unfold quadraticParticipationThreshold
  constructor
  · exact div_pos outputPositive denominatorPositive
  · apply (div_lt_one denominatorPositive).2
    linarith

theorem nonlinearFirstOrderScore_at_quadraticParticipationThreshold_eq_zero
    (params : Params) (othersEffort : ℝ) (aPositive : 0 < params.a)
    (bNonnegative : 0 ≤ params.b) (othersPositive : 0 < othersEffort)
    (betaTwo : params.beta = 2) :
    nonlinearFirstOrderScore params
      (quadraticParticipationThreshold params othersEffort) 0 othersEffort = 0 := by
  have outputPositive :
      0 < params.a * othersEffort + params.b * othersEffort ^ 2 := by
    have linearPositive : 0 < params.a * othersEffort :=
      mul_pos aPositive othersPositive
    have cooperativeNonnegative : 0 ≤ params.b * othersEffort ^ 2 :=
      mul_nonneg bNonnegative (sq_nonneg _)
    linarith
  have marginalPositive : 0 < params.a + 2 * params.b * othersEffort := by
    have cooperativeNonnegative : 0 ≤ 2 * params.b * othersEffort := by positivity
    linarith
  have denominatorNonzero :
      (params.a * othersEffort + params.b * othersEffort ^ 2) +
        (params.a + 2 * params.b * othersEffort) ≠ 0 := by linarith
  rw [nonlinearFirstOrderScore_beta_two_at_zero params _ othersEffort betaTwo]
  unfold quadraticParticipationThreshold
  field_simp
  ring

theorem continuous_nonlinearFirstOrderScore_beta_two (params : Params)
    (theta othersEffort : ℝ) (betaTwo : params.beta = 2) :
    Continuous (fun effort =>
      nonlinearFirstOrderScore params theta effort othersEffort) := by
  apply Continuous.congr
    (by fun_prop : Continuous (fun effort : ℝ =>
      theta * (1 - effort) *
          (params.a + 2 * params.b * (effort + othersEffort)) -
        (1 - theta) *
          (params.a * (effort + othersEffort) +
            params.b * (effort + othersEffort) ^ 2)))
  intro effort
  exact (nonlinearFirstOrderScore_beta_two params theta effort othersEffort betaTwo).symm

/-- Opposite strict endpoint signs force a quadratic score root strictly
inside the feasible effort interval. -/
theorem exists_interior_beta_two_scoreRoot_of_endpointSigns
    (params : Params) (theta othersEffort : ℝ) (betaTwo : params.beta = 2)
    (scoreAtZeroPositive :
      0 < nonlinearFirstOrderScore params theta 0 othersEffort)
    (scoreAtOneNegative :
      nonlinearFirstOrderScore params theta 1 othersEffort < 0) :
    ∃ root, 0 < root ∧ root < 1 ∧
      nonlinearFirstOrderScore params theta root othersEffort = 0 := by
  have continuousOnInterval : ContinuousOn
      (fun effort => nonlinearFirstOrderScore params theta effort othersEffort)
      (Set.Icc 0 1) :=
    (continuous_nonlinearFirstOrderScore_beta_two params theta othersEffort betaTwo).continuousOn
  have zeroBetween : (0 : ℝ) ∈ Set.Icc
      (nonlinearFirstOrderScore params theta 1 othersEffort)
      (nonlinearFirstOrderScore params theta 0 othersEffort) :=
    ⟨scoreAtOneNegative.le, scoreAtZeroPositive.le⟩
  obtain ⟨root, rootMem, rootScoreZero⟩ :=
    intermediate_value_Icc' (show (0 : ℝ) ≤ 1 by norm_num)
      continuousOnInterval zeroBetween
  have rootNeZero : root ≠ 0 := by
    intro rootZero
    subst root
    linarith
  have rootNeOne : root ≠ 1 := by
    intro rootOne
    subst root
    linarith
  exact ⟨root, lt_of_le_of_ne rootMem.1 (Ne.symm rootNeZero),
    lt_of_le_of_ne rootMem.2 rootNeOne, rootScoreZero⟩

theorem exists_interior_beta_two_scoreRoot_zero_coworkers
    (params : Params) (theta : ℝ) (aPositive : 0 < params.a)
    (bNonnegative : 0 ≤ params.b) (thetaPositive : 0 < theta)
    (thetaAtMostOne : theta < 1) (betaTwo : params.beta = 2) :
    ∃ root, 0 < root ∧ root < 1 ∧
      nonlinearFirstOrderScore params theta root 0 = 0 := by
  have scoreAtZeroPositive :
      0 < nonlinearFirstOrderScore params theta 0 0 := by
    rw [nonlinearFirstOrderScore_beta_two_at_zero params theta 0 betaTwo]
    nlinarith
  have scoreAtOneNegative :
      nonlinearFirstOrderScore params theta 1 0 < 0 := by
    rw [nonlinearFirstOrderScore_beta_two_at_one params theta 0 betaTwo]
    have outputCoefficientPositive : 0 < params.a + params.b := by linarith
    nlinarith
  exact exists_interior_beta_two_scoreRoot_of_endpointSigns params theta 0 betaTwo
    scoreAtZeroPositive scoreAtOneNegative

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

/-- With positive coworker effort and decreasing quadratic score, any positive
interior best response is the unique best response on the full feasible
interval, including both boundaries. -/
theorem bestResponse_beta_two_unique_of_positive_interior
    (params : Params) (theta othersEffort : ℝ) (firmSize : Nat)
    (interiorEffort alternative : ℝ)
    (interiorBest : IsBestResponse params theta othersEffort firmSize interiorEffort)
    (alternativeBest : IsBestResponse params theta othersEffort firmSize alternative)
    (interiorPositive : 0 < interiorEffort) (interiorBelowOne : interiorEffort < 1)
    (aPositive : 0 < params.a) (bNonnegative : 0 ≤ params.b)
    (thetaNonnegative : 0 ≤ theta) (thetaAtMostOne : theta < 1)
    (othersPositive : 0 < othersEffort) (firmSizePositive : 0 < firmSize)
    (betaTwo : params.beta = 2)
    (slopeAtZeroNegative : 2 * params.b * (theta - othersEffort) < params.a) :
    alternative = interiorEffort := by
  have interiorTotalPositive : 0 < interiorEffort + othersEffort := by linarith
  have rootScoreZero := interior_bestResponse_nonlinearFirstOrderScore_eq_zero
    params theta interiorEffort othersEffort firmSize interiorBest interiorPositive
    interiorBelowOne aPositive bNonnegative interiorTotalPositive firmSizePositive
  have scoreAtZeroPositive :
      0 < nonlinearFirstOrderScore params theta 0 othersEffort := by
    have comparison := nonlinearFirstOrderScore_beta_two_strictAntiOn_nonnegative
      params theta othersEffort betaTwo bNonnegative thetaNonnegative slopeAtZeroNegative
      (show (0 : ℝ) ∈ Set.Ici 0 by simp) interiorPositive.le interiorPositive
    change nonlinearFirstOrderScore params theta interiorEffort othersEffort <
      nonlinearFirstOrderScore params theta 0 othersEffort at comparison
    rw [rootScoreZero] at comparison
    exact comparison
  have zeroNotBest := zero_not_bestResponse_of_positive_beta_two_scoreRoot params theta
    othersEffort interiorEffort firmSize aPositive bNonnegative thetaNonnegative
    othersPositive interiorPositive interiorBelowOne firmSizePositive betaTwo
    scoreAtZeroPositive rootScoreZero
  have alternativeNonnegative : 0 ≤ alternative := alternativeBest.1.1
  have alternativeNeZero : alternative ≠ 0 := by
    intro alternativeZero
    apply zeroNotBest
    simpa [alternativeZero] using alternativeBest
  have alternativePositive : 0 < alternative :=
    lt_of_le_of_ne alternativeNonnegative (Ne.symm alternativeNeZero)
  have alternativeBelowOne := bestResponse_lt_one params theta othersEffort firmSize
    alternative alternativeBest aPositive bNonnegative othersPositive.le thetaAtMostOne
    firmSizePositive
  have alternativeTotalPositive : 0 < alternative + othersEffort := by linarith
  exact interior_bestResponse_beta_two_unique params theta othersEffort firmSize
    alternative interiorEffort alternativeBest interiorBest alternativePositive
    alternativeBelowOne interiorPositive interiorBelowOne aPositive bNonnegative
    thetaNonnegative alternativeTotalPositive interiorTotalPositive firmSizePositive
    betaTwo slopeAtZeroNegative

/-- With positive score at zero, a positive quadratic score root is a global
best response on `[0,1]`; no initial-slope restriction is needed. -/
theorem beta_two_scoreRoot_is_bestResponse
    (params : Params) (theta othersEffort root : ℝ) (firmSize : Nat)
    (aPositive : 0 < params.a) (bNonnegative : 0 ≤ params.b)
    (thetaNonnegative : 0 ≤ theta) (thetaAtMostOne : theta < 1)
    (othersPositive : 0 < othersEffort) (rootPositive : 0 < root)
    (rootBelowOne : root < 1) (firmSizePositive : 0 < firmSize)
    (betaTwo : params.beta = 2)
    (scoreAtZeroPositive :
      0 < nonlinearFirstOrderScore params theta 0 othersEffort)
    (rootScoreZero : nonlinearFirstOrderScore params theta root othersEffort = 0) :
    IsBestResponse params theta othersEffort firmSize root := by
  refine ⟨⟨rootPositive.le, rootBelowOne.le⟩, ?_⟩
  intro alternative alternativeFeasible
  have firmSizeCastPositive : 0 < (firmSize : ℝ) := by exact_mod_cast firmSizePositive
  have rootTotalPositive : 0 < root + othersEffort := by linarith
  have rootIncomePositive :
      0 < production params (root + othersEffort) / firmSize :=
    div_pos (production_positive_of_a_pos params _ aPositive bNonnegative
      rootTotalPositive) firmSizeCastPositive
  have rootLeisurePositive : 0 < 1 - root := sub_pos.mpr rootBelowOne
  have rootUtilityPositive : 0 < utility params theta root othersEffort firmSize := by
    unfold utility
    exact mul_pos (Real.rpow_pos_of_pos rootIncomePositive theta)
      (Real.rpow_pos_of_pos rootLeisurePositive (1 - theta))
  by_cases alternativeOne : alternative = 1
  · subst alternative
    have oneUtilityZero : utility params theta 1 othersEffort firmSize = 0 := by
      unfold utility
      rw [sub_self, Real.zero_rpow (sub_pos.mpr thetaAtMostOne).ne']
      ring
    rw [oneUtilityZero]
    exact rootUtilityPositive.le
  have alternativeBelowOne : alternative < 1 :=
    lt_of_le_of_ne alternativeFeasible.2 alternativeOne
  have alternativeTotalPositive : 0 < alternative + othersEffort := by
    linarith [alternativeFeasible.1]
  have alternativeIncomePositive :
      0 < production params (alternative + othersEffort) / firmSize :=
    div_pos (production_positive_of_a_pos params _ aPositive bNonnegative
      alternativeTotalPositive) firmSizeCastPositive
  have alternativeLeisurePositive : 0 < 1 - alternative :=
    sub_pos.mpr alternativeBelowOne
  have alternativeUtilityPositive :
      0 < utility params theta alternative othersEffort firmSize := by
    unfold utility
    exact mul_pos (Real.rpow_pos_of_pos alternativeIncomePositive theta)
      (Real.rpow_pos_of_pos alternativeLeisurePositive (1 - theta))
  have logComparison :
      logUtility params theta alternative othersEffort firmSize ≤
        logUtility params theta root othersEffort firmSize := by
    rcases le_total alternative root with alternativeLeRoot | rootLeAlternative
    · exact (logUtility_strictMonoOn_to_beta_two_root_of_positive_scoreAtZero
        params theta othersEffort
        root firmSize aPositive bNonnegative thetaNonnegative othersPositive
        rootPositive rootBelowOne firmSizePositive betaTwo scoreAtZeroPositive
        rootScoreZero).monotoneOn ⟨alternativeFeasible.1, alternativeLeRoot⟩
          ⟨rootPositive.le, le_rfl⟩ alternativeLeRoot
    · by_cases equal : alternative = root
      · simp [equal]
      · have rootLtAlternative := lt_of_le_of_ne rootLeAlternative (Ne.symm equal)
        have strictDecrease := logUtility_strictAntiOn_beta_two_root_to_interior params theta
          othersEffort root alternative firmSize aPositive bNonnegative thetaNonnegative
          othersPositive.le rootPositive alternativeBelowOne firmSizePositive betaTwo
          scoreAtZeroPositive rootScoreZero
        exact (strictDecrease ⟨le_rfl, rootLeAlternative⟩
          ⟨rootLeAlternative, le_rfl⟩ rootLtAlternative).le
  rw [← log_utility_eq_logUtility params theta alternative othersEffort firmSize
      alternativeIncomePositive alternativeLeisurePositive,
    ← log_utility_eq_logUtility params theta root othersEffort firmSize
      rootIncomePositive rootLeisurePositive] at logComparison
  rw [← Real.exp_log alternativeUtilityPositive,
    ← Real.exp_log rootUtilityPositive]
  exact Real.exp_le_exp.mpr logComparison

/-- Endpoint crossing plus decreasing score yields existence and uniqueness of
the nonlinear quadratic best response. -/
theorem existsUnique_bestResponse_beta_two_of_endpointSigns
    (params : Params) (theta othersEffort : ℝ) (firmSize : Nat)
    (aPositive : 0 < params.a) (bNonnegative : 0 ≤ params.b)
    (thetaNonnegative : 0 ≤ theta) (thetaAtMostOne : theta < 1)
    (othersPositive : 0 < othersEffort) (firmSizePositive : 0 < firmSize)
    (betaTwo : params.beta = 2)
    (slopeAtZeroNegative : 2 * params.b * (theta - othersEffort) < params.a)
    (scoreAtZeroPositive :
      0 < nonlinearFirstOrderScore params theta 0 othersEffort)
    (scoreAtOneNegative :
      nonlinearFirstOrderScore params theta 1 othersEffort < 0) :
    ∃! effort, IsBestResponse params theta othersEffort firmSize effort := by
  obtain ⟨root, rootPositive, rootBelowOne, rootScoreZero⟩ :=
    exists_interior_beta_two_scoreRoot_of_endpointSigns params theta othersEffort
      betaTwo scoreAtZeroPositive scoreAtOneNegative
  have rootBest := beta_two_scoreRoot_is_bestResponse params theta othersEffort root
    firmSize aPositive bNonnegative thetaNonnegative thetaAtMostOne othersPositive
    rootPositive rootBelowOne firmSizePositive betaTwo scoreAtZeroPositive rootScoreZero
  refine ⟨root, rootBest, ?_⟩
  intro alternative alternativeBest
  exact bestResponse_beta_two_unique_of_positive_interior params theta othersEffort
    firmSize root alternative rootBest alternativeBest rootPositive rootBelowOne
    aPositive bNonnegative thetaNonnegative thetaAtMostOne othersPositive
    firmSizePositive betaTwo slopeAtZeroNegative

/-- Positive endpoint score, rather than negative initial slope, is sufficient
for unique global best-response existence with positive coworker effort. -/
theorem existsUnique_bestResponse_beta_two_of_positive_scoreAtZero
    (params : Params) (theta othersEffort : ℝ) (firmSize : Nat)
    (aPositive : 0 < params.a) (bNonnegative : 0 ≤ params.b)
    (thetaNonnegative : 0 ≤ theta) (thetaAtMostOne : theta < 1)
    (othersPositive : 0 < othersEffort) (firmSizePositive : 0 < firmSize)
    (betaTwo : params.beta = 2)
    (scoreAtZeroPositive :
      0 < nonlinearFirstOrderScore params theta 0 othersEffort)
    (scoreAtOneNegative :
      nonlinearFirstOrderScore params theta 1 othersEffort < 0) :
    ∃! effort, IsBestResponse params theta othersEffort firmSize effort := by
  obtain ⟨root, rootPositive, rootBelowOne, rootScoreZero⟩ :=
    exists_interior_beta_two_scoreRoot_of_endpointSigns params theta othersEffort
      betaTwo scoreAtZeroPositive scoreAtOneNegative
  have rootBest := beta_two_scoreRoot_is_bestResponse params theta othersEffort root
    firmSize aPositive bNonnegative thetaNonnegative thetaAtMostOne othersPositive
    rootPositive rootBelowOne firmSizePositive betaTwo scoreAtZeroPositive rootScoreZero
  refine ⟨root, rootBest, ?_⟩
  intro alternative alternativeBest
  have zeroNotBest := zero_not_bestResponse_of_positive_beta_two_scoreRoot params theta
    othersEffort root firmSize aPositive bNonnegative thetaNonnegative othersPositive
    rootPositive rootBelowOne firmSizePositive betaTwo scoreAtZeroPositive rootScoreZero
  have alternativeNeZero : alternative ≠ 0 := by
    intro alternativeZero
    apply zeroNotBest
    simpa [alternativeZero] using alternativeBest
  have alternativePositive : 0 < alternative :=
    lt_of_le_of_ne alternativeBest.1.1 (Ne.symm alternativeNeZero)
  have alternativeBelowOne := bestResponse_lt_one params theta othersEffort firmSize
    alternative alternativeBest aPositive bNonnegative othersPositive.le thetaAtMostOne
    firmSizePositive
  have alternativeTotalPositive : 0 < alternative + othersEffort := by linarith
  have alternativeScoreZero := interior_bestResponse_nonlinearFirstOrderScore_eq_zero
    params theta alternative othersEffort firmSize alternativeBest alternativePositive
    alternativeBelowOne aPositive bNonnegative alternativeTotalPositive firmSizePositive
  exact positive_beta_two_scoreRoot_unique params theta othersEffort alternative root
    betaTwo bNonnegative thetaNonnegative scoreAtZeroPositive alternativePositive
    rootPositive alternativeScoreZero rootScoreZero

/-- Primitive parameter inequality version of the positive-coworker theorem;
the upper endpoint sign is automatic. -/
theorem existsUnique_bestResponse_beta_two_of_incentive_inequality
    (params : Params) (theta othersEffort : ℝ) (firmSize : Nat)
    (aPositive : 0 < params.a) (bNonnegative : 0 ≤ params.b)
    (thetaNonnegative : 0 ≤ theta) (thetaAtMostOne : theta < 1)
    (othersPositive : 0 < othersEffort) (firmSizePositive : 0 < firmSize)
    (betaTwo : params.beta = 2)
    (incentiveAtZero :
      (1 - theta) *
          (params.a * othersEffort + params.b * othersEffort ^ 2) <
        theta * (params.a + 2 * params.b * othersEffort)) :
    ∃! effort, IsBestResponse params theta othersEffort firmSize effort := by
  have scoreAtZeroPositive :=
    (nonlinearFirstOrderScore_beta_two_at_zero_positive_iff params theta
      othersEffort betaTwo).2 incentiveAtZero
  have scoreAtOneNegative := nonlinearFirstOrderScore_beta_two_at_one_negative
    params theta othersEffort betaTwo aPositive bNonnegative othersPositive.le
    thetaAtMostOne
  exact existsUnique_bestResponse_beta_two_of_positive_scoreAtZero params theta
    othersEffort firmSize aPositive bNonnegative thetaNonnegative thetaAtMostOne
    othersPositive firmSizePositive betaTwo scoreAtZeroPositive scoreAtOneNegative

theorem beta_two_scoreRoot_is_bestResponse_zero_coworkers
    (params : Params) (theta root : ℝ) (firmSize : Nat)
    (aPositive : 0 < params.a) (bNonnegative : 0 ≤ params.b)
    (thetaPositive : 0 < theta) (thetaAtMostOne : theta < 1)
    (rootPositive : 0 < root) (rootBelowOne : root < 1)
    (firmSizePositive : 0 < firmSize) (betaTwo : params.beta = 2)
    (scoreAtZeroPositive : 0 < nonlinearFirstOrderScore params theta 0 0)
    (rootScoreZero : nonlinearFirstOrderScore params theta root 0 = 0) :
    IsBestResponse params theta 0 firmSize root := by
  refine ⟨⟨rootPositive.le, rootBelowOne.le⟩, ?_⟩
  intro alternative alternativeFeasible
  have firmSizeCastPositive : 0 < (firmSize : ℝ) := by exact_mod_cast firmSizePositive
  have rootIncomePositive : 0 < production params (root + 0) / firmSize :=
    div_pos (production_positive_of_a_pos params _ aPositive bNonnegative
      (by simpa using rootPositive)) firmSizeCastPositive
  have rootLeisurePositive : 0 < 1 - root := sub_pos.mpr rootBelowOne
  have rootUtilityPositive : 0 < utility params theta root 0 firmSize := by
    unfold utility
    exact mul_pos (Real.rpow_pos_of_pos rootIncomePositive theta)
      (Real.rpow_pos_of_pos rootLeisurePositive (1 - theta))
  by_cases alternativeZero : alternative = 0
  · subst alternative
    have zeroUtility : utility params theta 0 0 firmSize = 0 := by
      simp [utility, production, betaTwo, Real.zero_rpow thetaPositive.ne']
    rw [zeroUtility]
    exact rootUtilityPositive.le
  by_cases alternativeOne : alternative = 1
  · subst alternative
    have oneUtility : utility params theta 1 0 firmSize = 0 := by
      unfold utility
      rw [sub_self, Real.zero_rpow (sub_pos.mpr thetaAtMostOne).ne']
      ring
    rw [oneUtility]
    exact rootUtilityPositive.le
  have alternativePositive : 0 < alternative :=
    lt_of_le_of_ne alternativeFeasible.1 (Ne.symm alternativeZero)
  have alternativeBelowOne : alternative < 1 :=
    lt_of_le_of_ne alternativeFeasible.2 alternativeOne
  have alternativeIncomePositive : 0 < production params (alternative + 0) / firmSize :=
    div_pos (production_positive_of_a_pos params _ aPositive bNonnegative
      (by simpa using alternativePositive)) firmSizeCastPositive
  have alternativeLeisurePositive : 0 < 1 - alternative :=
    sub_pos.mpr alternativeBelowOne
  have alternativeUtilityPositive : 0 < utility params theta alternative 0 firmSize := by
    unfold utility
    exact mul_pos (Real.rpow_pos_of_pos alternativeIncomePositive theta)
      (Real.rpow_pos_of_pos alternativeLeisurePositive (1 - theta))
  have logComparison : logUtility params theta alternative 0 firmSize ≤
      logUtility params theta root 0 firmSize := by
    rcases le_total alternative root with alternativeLeRoot | rootLeAlternative
    · exact (logUtility_strictMonoOn_positiveInterval_to_beta_two_root
        params theta 0 alternative root firmSize aPositive bNonnegative
        thetaPositive.le (by norm_num) alternativePositive alternativeLeRoot
        rootBelowOne firmSizePositive betaTwo scoreAtZeroPositive
        rootScoreZero).monotoneOn ⟨le_rfl, alternativeLeRoot⟩
          ⟨alternativeLeRoot, le_rfl⟩ alternativeLeRoot
    · by_cases equal : alternative = root
      · simp [equal]
      · have rootLtAlternative := lt_of_le_of_ne rootLeAlternative (Ne.symm equal)
        have strictDecrease := logUtility_strictAntiOn_beta_two_root_to_interior
          params theta 0 root alternative firmSize aPositive bNonnegative
          thetaPositive.le (by norm_num) rootPositive alternativeBelowOne
          firmSizePositive betaTwo scoreAtZeroPositive rootScoreZero
        exact (strictDecrease ⟨le_rfl, rootLeAlternative⟩
          ⟨rootLeAlternative, le_rfl⟩ rootLtAlternative).le
  rw [← log_utility_eq_logUtility params theta alternative 0 firmSize
      alternativeIncomePositive alternativeLeisurePositive,
    ← log_utility_eq_logUtility params theta root 0 firmSize
      rootIncomePositive rootLeisurePositive] at logComparison
  rw [← Real.exp_log alternativeUtilityPositive,
    ← Real.exp_log rootUtilityPositive]
  exact Real.exp_le_exp.mpr logComparison

theorem existsUnique_bestResponse_beta_two_zero_coworkers
    (params : Params) (theta : ℝ) (firmSize : Nat)
    (aPositive : 0 < params.a) (bNonnegative : 0 ≤ params.b)
    (thetaPositive : 0 < theta) (thetaAtMostOne : theta < 1)
    (firmSizePositive : 0 < firmSize) (betaTwo : params.beta = 2) :
    ∃! effort, IsBestResponse params theta 0 firmSize effort := by
  have scoreAtZeroPositive : 0 < nonlinearFirstOrderScore params theta 0 0 := by
    rw [nonlinearFirstOrderScore_beta_two_at_zero params theta 0 betaTwo]
    nlinarith
  obtain ⟨root, rootPositive, rootBelowOne, rootScoreZero⟩ :=
    exists_interior_beta_two_scoreRoot_zero_coworkers params theta aPositive
      bNonnegative thetaPositive thetaAtMostOne betaTwo
  have rootBest := beta_two_scoreRoot_is_bestResponse_zero_coworkers params theta root
    firmSize aPositive bNonnegative thetaPositive thetaAtMostOne rootPositive
    rootBelowOne firmSizePositive betaTwo scoreAtZeroPositive rootScoreZero
  refine ⟨root, rootBest, ?_⟩
  intro alternative alternativeBest
  have alternativeBelowOne := bestResponse_lt_one params theta 0 firmSize alternative
    alternativeBest aPositive bNonnegative (by norm_num) thetaAtMostOne firmSizePositive
  have alternativeNeZero : alternative ≠ 0 := by
    intro alternativeZero
    have comparison := alternativeBest.2 root ⟨rootPositive.le, rootBelowOne.le⟩
    have firmSizeCastPositive : 0 < (firmSize : ℝ) := by exact_mod_cast firmSizePositive
    have rootIncomePositive : 0 < production params (root + 0) / firmSize :=
      div_pos (production_positive_of_a_pos params _ aPositive bNonnegative
        (by simpa using rootPositive)) firmSizeCastPositive
    have rootUtilityPositive : 0 < utility params theta root 0 firmSize := by
      unfold utility
      exact mul_pos (Real.rpow_pos_of_pos rootIncomePositive theta)
        (Real.rpow_pos_of_pos (sub_pos.mpr rootBelowOne) (1 - theta))
    have zeroUtility : utility params theta 0 0 firmSize = 0 := by
      simp [utility, production, betaTwo, Real.zero_rpow thetaPositive.ne']
    rw [alternativeZero, zeroUtility] at comparison
    linarith
  have alternativePositive : 0 < alternative :=
    lt_of_le_of_ne alternativeBest.1.1 (Ne.symm alternativeNeZero)
  have alternativeScoreZero := interior_bestResponse_nonlinearFirstOrderScore_eq_zero
    params theta alternative 0 firmSize alternativeBest alternativePositive
    alternativeBelowOne aPositive bNonnegative (by simpa using alternativePositive)
    firmSizePositive
  exact positive_beta_two_scoreRoot_unique params theta 0 alternative root betaTwo
    bNonnegative thetaPositive.le scoreAtZeroPositive alternativePositive rootPositive
    alternativeScoreZero rootScoreZero

theorem zero_is_unique_bestResponse_of_nonpositive_scoreAtZero
    (params : Params) (theta othersEffort : ℝ) (firmSize : Nat)
    (aPositive : 0 < params.a) (bNonnegative : 0 ≤ params.b)
    (thetaNonnegative : 0 ≤ theta) (thetaAtMostOne : theta < 1)
    (othersPositive : 0 < othersEffort) (firmSizePositive : 0 < firmSize)
    (betaTwo : params.beta = 2)
    (slopeAtZeroNegative : 2 * params.b * (theta - othersEffort) < params.a)
    (scoreAtZeroNonpositive :
      nonlinearFirstOrderScore params theta 0 othersEffort ≤ 0) :
    ∃! effort, IsBestResponse params theta othersEffort firmSize effort := by
  have zeroBest := zero_is_bestResponse_of_nonpositive_scoreAtZero params theta
    othersEffort firmSize aPositive bNonnegative thetaNonnegative thetaAtMostOne
    othersPositive firmSizePositive betaTwo slopeAtZeroNegative scoreAtZeroNonpositive
  refine ⟨0, zeroBest, ?_⟩
  intro effort effortBest
  by_contra effortNeZero
  have effortPositive : 0 < effort :=
    lt_of_le_of_ne effortBest.1.1 (Ne.symm effortNeZero)
  have effortBelowOne := bestResponse_lt_one params theta othersEffort firmSize effort
    effortBest aPositive bNonnegative othersPositive.le thetaAtMostOne firmSizePositive
  have effortScoreZero := interior_bestResponse_nonlinearFirstOrderScore_eq_zero
    params theta effort othersEffort firmSize effortBest effortPositive effortBelowOne
    aPositive bNonnegative (by linarith) firmSizePositive
  have scoreComparison := nonlinearFirstOrderScore_beta_two_strictAntiOn_nonnegative
    params theta othersEffort betaTwo bNonnegative thetaNonnegative slopeAtZeroNegative
    (show (0 : ℝ) ∈ Set.Ici 0 by simp) effortPositive.le effortPositive
  change nonlinearFirstOrderScore params theta effort othersEffort <
    nonlinearFirstOrderScore params theta 0 othersEffort at scoreComparison
  rw [effortScoreZero] at scoreComparison
  linarith

end AgenticAxtell.Baseline
