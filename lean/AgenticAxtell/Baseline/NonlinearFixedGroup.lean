import AgenticAxtell.Baseline.NonlinearBestResponse
import Gametheory.Brouwer_product
import Mathlib.Analysis.Convex.StdSimplex
import AgenticAxtell.Baseline.FixedGroup

namespace AgenticAxtell.Baseline

/-- A canonical scalar best-response selection for the full nonlinear utility.
Existence comes from compactness; later quadratic theorems characterize this
selection more explicitly. -/
noncomputable def nonlinearSelectedBestResponse (params : Params)
    (theta othersEffort : ℝ) (firmSize : Nat) (paramsValid : ValidParams params)
    (thetaNonnegative : 0 ≤ theta) (thetaAtMostOne : theta ≤ 1) : ℝ :=
  Classical.choose (exists_best_response params theta othersEffort firmSize
    paramsValid thetaNonnegative thetaAtMostOne)

theorem nonlinearSelectedBestResponse_spec (params : Params)
    (theta othersEffort : ℝ) (firmSize : Nat) (paramsValid : ValidParams params)
    (thetaNonnegative : 0 ≤ theta) (thetaAtMostOne : theta ≤ 1) :
    IsBestResponse params theta othersEffort firmSize
      (nonlinearSelectedBestResponse params theta othersEffort firmSize paramsValid
        thetaNonnegative thetaAtMostOne) :=
  Classical.choose_spec (exists_best_response params theta othersEffort firmSize
    paramsValid thetaNonnegative thetaAtMostOne)

/-- The canonical response as a proof-independent function on the economically
feasible preference interval. -/
noncomputable def nonlinearFeasibleThetaResponse (params : Params)
    (othersEffort : ℝ) (firmSize : Nat) (paramsValid : ValidParams params) :
    Set.Icc (0 : ℝ) 1 → ℝ :=
  fun theta => nonlinearSelectedBestResponse params theta.1 othersEffort firmSize
    paramsValid theta.2.1 theta.2.2

/-- The canonical scalar response viewed as a function of coworker effort. -/
noncomputable def nonlinearOthersResponse (params : Params) (theta : ℝ)
    (firmSize : Nat) (paramsValid : ValidParams params)
    (thetaNonnegative : 0 ≤ theta) (thetaAtMostOne : theta ≤ 1) : ℝ → ℝ :=
  fun othersEffort => nonlinearSelectedBestResponse params theta othersEffort
    firmSize paramsValid thetaNonnegative thetaAtMostOne

/-- Coworker-effort response restricted to the economically meaningful
nonnegative domain. -/
noncomputable def nonlinearNonnegativeOthersResponse (params : Params)
    (theta : ℝ) (firmSize : Nat) (paramsValid : ValidParams params)
    (thetaNonnegative : 0 ≤ theta) (thetaAtMostOne : theta ≤ 1) :
    Set.Ici (0 : ℝ) → ℝ :=
  fun othersEffort => nonlinearSelectedBestResponse params theta othersEffort.1
    firmSize paramsValid thetaNonnegative thetaAtMostOne

theorem nonlinearSelectedBestResponse_eq_of_unique (params : Params)
    (theta othersEffort : ℝ) (firmSize : Nat) (paramsValid : ValidParams params)
    (thetaNonnegative : 0 ≤ theta) (thetaAtMostOne : theta ≤ 1)
    (target : ℝ) (targetUnique : ∀ effort,
      IsBestResponse params theta othersEffort firmSize effort → effort = target) :
    nonlinearSelectedBestResponse params theta othersEffort firmSize paramsValid
      thetaNonnegative thetaAtMostOne = target :=
  targetUnique _ (nonlinearSelectedBestResponse_spec params theta othersEffort firmSize
    paramsValid thetaNonnegative thetaAtMostOne)

theorem nonlinearSelectedBestResponse_eq_zero_of_nonpositive_score
    (params : Params) (theta othersEffort : ℝ) (firmSize : Nat)
    (paramsValid : ValidParams params) (thetaNonnegative : 0 ≤ theta)
    (thetaAtMostOne : theta < 1) (aPositive : 0 < params.a)
    (othersPositive : 0 < othersEffort) (firmSizePositive : 0 < firmSize)
    (betaTwo : params.beta = 2)
    (slopeAtZeroNegative : 2 * params.b * (theta - othersEffort) < params.a)
    (scoreAtZeroNonpositive :
      nonlinearFirstOrderScore params theta 0 othersEffort ≤ 0) :
    nonlinearSelectedBestResponse params theta othersEffort firmSize paramsValid
      thetaNonnegative thetaAtMostOne.le = 0 := by
  have uniqueBest := zero_is_unique_bestResponse_of_nonpositive_scoreAtZero params
    theta othersEffort firmSize aPositive paramsValid.2.2.1 thetaNonnegative
    thetaAtMostOne othersPositive firmSizePositive betaTwo slopeAtZeroNegative
    scoreAtZeroNonpositive
  obtain ⟨witness, witnessBest, uniqueness⟩ := uniqueBest
  have selectedBest := nonlinearSelectedBestResponse_spec params theta othersEffort
    firmSize paramsValid thetaNonnegative thetaAtMostOne.le
  exact (uniqueness _ selectedBest).trans (uniqueness 0
    (zero_is_bestResponse_of_nonpositive_scoreAtZero params theta othersEffort
      firmSize aPositive paramsValid.2.2.1 thetaNonnegative thetaAtMostOne
      othersPositive firmSizePositive betaTwo slopeAtZeroNegative
      scoreAtZeroNonpositive)).symm

/-- Canonical interior root of the quadratic score in the participation
branch. -/
noncomputable def quadraticPositiveRoot (params : Params)
    (theta othersEffort : ℝ) (betaTwo : params.beta = 2)
    (scoreAtZeroPositive :
      0 < nonlinearFirstOrderScore params theta 0 othersEffort)
    (scoreAtOneNegative :
      nonlinearFirstOrderScore params theta 1 othersEffort < 0) : ℝ :=
  Classical.choose (exists_interior_beta_two_scoreRoot_of_endpointSigns params
    theta othersEffort betaTwo scoreAtZeroPositive scoreAtOneNegative)

theorem quadraticPositiveRoot_spec (params : Params)
    (theta othersEffort : ℝ) (betaTwo : params.beta = 2)
    (scoreAtZeroPositive :
      0 < nonlinearFirstOrderScore params theta 0 othersEffort)
    (scoreAtOneNegative :
      nonlinearFirstOrderScore params theta 1 othersEffort < 0) :
    0 < quadraticPositiveRoot params theta othersEffort betaTwo
        scoreAtZeroPositive scoreAtOneNegative ∧
      quadraticPositiveRoot params theta othersEffort betaTwo
          scoreAtZeroPositive scoreAtOneNegative < 1 ∧
      nonlinearFirstOrderScore params theta
          (quadraticPositiveRoot params theta othersEffort betaTwo
            scoreAtZeroPositive scoreAtOneNegative) othersEffort = 0 :=
  Classical.choose_spec (exists_interior_beta_two_scoreRoot_of_endpointSigns params
    theta othersEffort betaTwo scoreAtZeroPositive scoreAtOneNegative)

/-- Canonical positive score root for the singular zero-coworker environment. -/
noncomputable def quadraticZeroCoworkerRoot (params : Params) (theta : ℝ)
    (aPositive : 0 < params.a) (bNonnegative : 0 ≤ params.b)
    (thetaPositive : 0 < theta) (thetaBelowOne : theta < 1)
    (betaTwo : params.beta = 2) : ℝ :=
  Classical.choose (exists_interior_beta_two_scoreRoot_zero_coworkers params theta
    aPositive bNonnegative thetaPositive thetaBelowOne betaTwo)

theorem quadraticZeroCoworkerRoot_spec (params : Params) (theta : ℝ)
    (aPositive : 0 < params.a) (bNonnegative : 0 ≤ params.b)
    (thetaPositive : 0 < theta) (thetaBelowOne : theta < 1)
    (betaTwo : params.beta = 2) :
    0 < quadraticZeroCoworkerRoot params theta aPositive bNonnegative
        thetaPositive thetaBelowOne betaTwo ∧
      quadraticZeroCoworkerRoot params theta aPositive bNonnegative
          thetaPositive thetaBelowOne betaTwo < 1 ∧
      nonlinearFirstOrderScore params theta
          (quadraticZeroCoworkerRoot params theta aPositive bNonnegative
            thetaPositive thetaBelowOne betaTwo) 0 = 0 :=
  Classical.choose_spec (exists_interior_beta_two_scoreRoot_zero_coworkers params
    theta aPositive bNonnegative thetaPositive thetaBelowOne betaTwo)

theorem nonlinearSelectedBestResponse_eq_quadraticZeroCoworkerRoot
    (params : Params) (theta : ℝ) (firmSize : Nat)
    (paramsValid : ValidParams params) (thetaPositive : 0 < theta)
    (thetaBelowOne : theta < 1) (aPositive : 0 < params.a)
    (firmSizePositive : 0 < firmSize) (betaTwo : params.beta = 2) :
    nonlinearSelectedBestResponse params theta 0 firmSize paramsValid
        thetaPositive.le thetaBelowOne.le =
      quadraticZeroCoworkerRoot params theta aPositive paramsValid.2.2.1
        thetaPositive thetaBelowOne betaTwo := by
  have selectedBest := nonlinearSelectedBestResponse_spec params theta 0 firmSize
    paramsValid thetaPositive.le thetaBelowOne.le
  obtain ⟨witness, witnessBest, uniqueness⟩ :=
    existsUnique_bestResponse_beta_two_zero_coworkers params theta firmSize
      aPositive paramsValid.2.2.1 thetaPositive thetaBelowOne firmSizePositive
      betaTwo
  have rootSpec := quadraticZeroCoworkerRoot_spec params theta aPositive
    paramsValid.2.2.1 thetaPositive thetaBelowOne betaTwo
  have scoreAtZeroPositive :
      0 < nonlinearFirstOrderScore params theta 0 0 := by
    rw [nonlinearFirstOrderScore_beta_two_at_zero params theta 0 betaTwo]
    nlinarith
  have rootBest := beta_two_scoreRoot_is_bestResponse_zero_coworkers params theta
    (quadraticZeroCoworkerRoot params theta aPositive paramsValid.2.2.1
      thetaPositive thetaBelowOne betaTwo)
    firmSize aPositive paramsValid.2.2.1 thetaPositive thetaBelowOne rootSpec.1
    rootSpec.2.1 firmSizePositive betaTwo scoreAtZeroPositive rootSpec.2.2
  exact (uniqueness _ selectedBest).trans (uniqueness _ rootBest).symm

theorem nonlinearSelectedBestResponse_eq_quadraticPositiveRoot
    (params : Params) (theta othersEffort : ℝ) (firmSize : Nat)
    (paramsValid : ValidParams params) (thetaNonnegative : 0 ≤ theta)
    (thetaAtMostOne : theta < 1) (aPositive : 0 < params.a)
    (othersPositive : 0 < othersEffort) (firmSizePositive : 0 < firmSize)
    (betaTwo : params.beta = 2)
    (scoreAtZeroPositive :
      0 < nonlinearFirstOrderScore params theta 0 othersEffort)
    (scoreAtOneNegative :
      nonlinearFirstOrderScore params theta 1 othersEffort < 0) :
    nonlinearSelectedBestResponse params theta othersEffort firmSize paramsValid
        thetaNonnegative thetaAtMostOne.le =
      quadraticPositiveRoot params theta othersEffort betaTwo
        scoreAtZeroPositive scoreAtOneNegative := by
  have uniqueBest := existsUnique_bestResponse_beta_two_of_positive_scoreAtZero
    params theta othersEffort firmSize aPositive paramsValid.2.2.1 thetaNonnegative
    thetaAtMostOne othersPositive firmSizePositive betaTwo scoreAtZeroPositive
    scoreAtOneNegative
  obtain ⟨witness, witnessBest, uniqueness⟩ := uniqueBest
  have selectedBest := nonlinearSelectedBestResponse_spec params theta othersEffort
    firmSize paramsValid thetaNonnegative thetaAtMostOne.le
  have rootProperties := quadraticPositiveRoot_spec params theta othersEffort betaTwo
    scoreAtZeroPositive scoreAtOneNegative
  have rootBest := beta_two_scoreRoot_is_bestResponse params theta othersEffort
    (quadraticPositiveRoot params theta othersEffort betaTwo scoreAtZeroPositive
      scoreAtOneNegative) firmSize aPositive paramsValid.2.2.1 thetaNonnegative
    thetaAtMostOne othersPositive rootProperties.1 rootProperties.2.1 firmSizePositive
    betaTwo scoreAtZeroPositive rootProperties.2.2
  exact (uniqueness _ selectedBest).trans (uniqueness _ rootBest).symm

/-- The canonical selected responses inherit the symmetric positive-root
Lipschitz estimate. -/
theorem nonlinearSelectedBestResponse_abs_sub_le_div_margin
    (params : Params) (firstTheta secondTheta othersEffort : ℝ) (firmSize : Nat)
    (paramsValid : ValidParams params)
    (firstThetaNonnegative : 0 ≤ firstTheta)
    (secondThetaNonnegative : 0 ≤ secondTheta)
    (firstThetaBelowOne : firstTheta < 1) (secondThetaBelowOne : secondTheta < 1)
    (aPositive : 0 < params.a) (othersPositive : 0 < othersEffort)
    (firmSizePositive : 0 < firmSize) (betaTwo : params.beta = 2)
    (firstScoreAtZeroPositive :
      0 < nonlinearFirstOrderScore params firstTheta 0 othersEffort)
    (secondScoreAtZeroPositive :
      0 < nonlinearFirstOrderScore params secondTheta 0 othersEffort)
    (firstScoreAtOneNegative :
      nonlinearFirstOrderScore params firstTheta 1 othersEffort < 0)
    (secondScoreAtOneNegative :
      nonlinearFirstOrderScore params secondTheta 1 othersEffort < 0)
    (slopeMarginPositive :
      2 * params.b * (max firstTheta secondTheta - othersEffort) < params.a) :
    |nonlinearSelectedBestResponse params secondTheta othersEffort firmSize
          paramsValid secondThetaNonnegative secondThetaBelowOne.le -
        nonlinearSelectedBestResponse params firstTheta othersEffort firmSize
          paramsValid firstThetaNonnegative firstThetaBelowOne.le| ≤
      (|secondTheta - firstTheta| *
        max
          ((1 - nonlinearSelectedBestResponse params firstTheta othersEffort firmSize
              paramsValid firstThetaNonnegative firstThetaBelowOne.le) *
              marginalProduction params
                (nonlinearSelectedBestResponse params firstTheta othersEffort firmSize
                    paramsValid firstThetaNonnegative firstThetaBelowOne.le +
                  othersEffort) +
            production params
              (nonlinearSelectedBestResponse params firstTheta othersEffort firmSize
                  paramsValid firstThetaNonnegative firstThetaBelowOne.le +
                othersEffort))
          ((1 - nonlinearSelectedBestResponse params secondTheta othersEffort firmSize
              paramsValid secondThetaNonnegative secondThetaBelowOne.le) *
              marginalProduction params
                (nonlinearSelectedBestResponse params secondTheta othersEffort firmSize
                    paramsValid secondThetaNonnegative secondThetaBelowOne.le +
                  othersEffort) +
            production params
              (nonlinearSelectedBestResponse params secondTheta othersEffort firmSize
                  paramsValid secondThetaNonnegative secondThetaBelowOne.le +
                othersEffort))) /
        (params.a - 2 * params.b *
          (max firstTheta secondTheta - othersEffort)) := by
  rw [nonlinearSelectedBestResponse_eq_quadraticPositiveRoot params firstTheta
      othersEffort firmSize paramsValid firstThetaNonnegative firstThetaBelowOne
      aPositive othersPositive firmSizePositive betaTwo firstScoreAtZeroPositive
      firstScoreAtOneNegative,
    nonlinearSelectedBestResponse_eq_quadraticPositiveRoot params secondTheta
      othersEffort firmSize paramsValid secondThetaNonnegative secondThetaBelowOne
      aPositive othersPositive firmSizePositive betaTwo secondScoreAtZeroPositive
      secondScoreAtOneNegative]
  have firstSpec := quadraticPositiveRoot_spec params firstTheta othersEffort betaTwo
    firstScoreAtZeroPositive firstScoreAtOneNegative
  have secondSpec := quadraticPositiveRoot_spec params secondTheta othersEffort betaTwo
    secondScoreAtZeroPositive secondScoreAtOneNegative
  exact beta_two_positive_scoreRoot_abs_sub_le_div_margin params firstTheta
    secondTheta othersEffort
    (quadraticPositiveRoot params firstTheta othersEffort betaTwo
      firstScoreAtZeroPositive firstScoreAtOneNegative)
    (quadraticPositiveRoot params secondTheta othersEffort betaTwo
      secondScoreAtZeroPositive secondScoreAtOneNegative)
    aPositive paramsValid.2.2.1 firstThetaNonnegative secondThetaNonnegative
    othersPositive.le betaTwo firstScoreAtZeroPositive secondScoreAtZeroPositive
    firstSpec.1 secondSpec.1 firstSpec.2.1 secondSpec.2.1 firstSpec.2.2
    secondSpec.2.2 slopeMarginPositive

/-- Root-independent Lipschitz estimate for the canonical selected responses,
with a numerator depending only on primitive parameters and coworker effort. -/
theorem nonlinearSelectedBestResponse_abs_sub_le_uniform_div_margin
    (params : Params) (firstTheta secondTheta othersEffort : ℝ) (firmSize : Nat)
    (paramsValid : ValidParams params)
    (firstThetaNonnegative : 0 ≤ firstTheta)
    (secondThetaNonnegative : 0 ≤ secondTheta)
    (firstThetaBelowOne : firstTheta < 1) (secondThetaBelowOne : secondTheta < 1)
    (aPositive : 0 < params.a) (othersPositive : 0 < othersEffort)
    (firmSizePositive : 0 < firmSize) (betaTwo : params.beta = 2)
    (firstScoreAtZeroPositive :
      0 < nonlinearFirstOrderScore params firstTheta 0 othersEffort)
    (secondScoreAtZeroPositive :
      0 < nonlinearFirstOrderScore params secondTheta 0 othersEffort)
    (firstScoreAtOneNegative :
      nonlinearFirstOrderScore params firstTheta 1 othersEffort < 0)
    (secondScoreAtOneNegative :
      nonlinearFirstOrderScore params secondTheta 1 othersEffort < 0)
    (slopeMarginPositive :
      2 * params.b * (max firstTheta secondTheta - othersEffort) < params.a) :
    |nonlinearSelectedBestResponse params secondTheta othersEffort firmSize
          paramsValid secondThetaNonnegative secondThetaBelowOne.le -
        nonlinearSelectedBestResponse params firstTheta othersEffort firmSize
          paramsValid firstThetaNonnegative firstThetaBelowOne.le| ≤
      |secondTheta - firstTheta| *
          quadraticThetaSensitivityBound params othersEffort /
        (params.a - 2 * params.b *
          (max firstTheta secondTheta - othersEffort)) := by
  rw [nonlinearSelectedBestResponse_eq_quadraticPositiveRoot params firstTheta
      othersEffort firmSize paramsValid firstThetaNonnegative firstThetaBelowOne
      aPositive othersPositive firmSizePositive betaTwo firstScoreAtZeroPositive
      firstScoreAtOneNegative,
    nonlinearSelectedBestResponse_eq_quadraticPositiveRoot params secondTheta
      othersEffort firmSize paramsValid secondThetaNonnegative secondThetaBelowOne
      aPositive othersPositive firmSizePositive betaTwo secondScoreAtZeroPositive
      secondScoreAtOneNegative]
  have firstSpec := quadraticPositiveRoot_spec params firstTheta othersEffort betaTwo
    firstScoreAtZeroPositive firstScoreAtOneNegative
  have secondSpec := quadraticPositiveRoot_spec params secondTheta othersEffort betaTwo
    secondScoreAtZeroPositive secondScoreAtOneNegative
  exact beta_two_positive_scoreRoot_abs_sub_le_uniform_div_margin params firstTheta
    secondTheta othersEffort
    (quadraticPositiveRoot params firstTheta othersEffort betaTwo
      firstScoreAtZeroPositive firstScoreAtOneNegative)
    (quadraticPositiveRoot params secondTheta othersEffort betaTwo
      secondScoreAtZeroPositive secondScoreAtOneNegative)
    aPositive paramsValid.2.2.1 firstThetaNonnegative secondThetaNonnegative
    othersPositive.le betaTwo firstScoreAtZeroPositive secondScoreAtZeroPositive
    firstSpec.1 secondSpec.1 firstSpec.2.1 secondSpec.2.1 firstSpec.2.2
    secondSpec.2.2 slopeMarginPositive

/-- Root-independent coworker-effort stability for canonical selected best
responses on a bounded environment domain. -/
theorem nonlinearSelectedBestResponse_others_abs_sub_le_uniform_div_margin
    (params : Params) (theta firstOthers secondOthers othersCap : ℝ)
    (firmSize : Nat) (paramsValid : ValidParams params)
    (thetaNonnegative : 0 ≤ theta) (thetaBelowOne : theta < 1)
    (aPositive : 0 < params.a) (firstOthersPositive : 0 < firstOthers)
    (secondOthersPositive : 0 < secondOthers)
    (firstOthersAtMost : firstOthers ≤ othersCap)
    (secondOthersAtMost : secondOthers ≤ othersCap)
    (firmSizePositive : 0 < firmSize) (betaTwo : params.beta = 2)
    (firstScoreAtZeroPositive :
      0 < nonlinearFirstOrderScore params theta 0 firstOthers)
    (secondScoreAtZeroPositive :
      0 < nonlinearFirstOrderScore params theta 0 secondOthers)
    (firstScoreAtOneNegative :
      nonlinearFirstOrderScore params theta 1 firstOthers < 0)
    (secondScoreAtOneNegative :
      nonlinearFirstOrderScore params theta 1 secondOthers < 0)
    (uniformBound : 2 * params.b * theta < (1 - theta) * params.a)
    (slopeMarginPositive :
      2 * params.b * (theta - max firstOthers secondOthers) < params.a) :
    |nonlinearSelectedBestResponse params theta secondOthers firmSize paramsValid
          thetaNonnegative thetaBelowOne.le -
        nonlinearSelectedBestResponse params theta firstOthers firmSize paramsValid
          thetaNonnegative thetaBelowOne.le| ≤
      |secondOthers - firstOthers| *
          quadraticOthersSensitivityBound params theta othersCap /
        (params.a - 2 * params.b *
          (theta - max firstOthers secondOthers)) := by
  rw [nonlinearSelectedBestResponse_eq_quadraticPositiveRoot params theta
      firstOthers firmSize paramsValid thetaNonnegative thetaBelowOne aPositive
      firstOthersPositive firmSizePositive betaTwo firstScoreAtZeroPositive
      firstScoreAtOneNegative,
    nonlinearSelectedBestResponse_eq_quadraticPositiveRoot params theta
      secondOthers firmSize paramsValid thetaNonnegative thetaBelowOne aPositive
      secondOthersPositive firmSizePositive betaTwo secondScoreAtZeroPositive
      secondScoreAtOneNegative]
  have firstSpec := quadraticPositiveRoot_spec params theta firstOthers betaTwo
    firstScoreAtZeroPositive firstScoreAtOneNegative
  have secondSpec := quadraticPositiveRoot_spec params theta secondOthers betaTwo
    secondScoreAtZeroPositive secondScoreAtOneNegative
  exact beta_two_positive_scoreRoot_others_abs_sub_le_uniform_div_margin params
    theta firstOthers secondOthers othersCap
    (quadraticPositiveRoot params theta firstOthers betaTwo
      firstScoreAtZeroPositive firstScoreAtOneNegative)
    (quadraticPositiveRoot params theta secondOthers betaTwo
      secondScoreAtZeroPositive secondScoreAtOneNegative)
    betaTwo paramsValid.2.2.1 thetaNonnegative thetaBelowOne.le
    firstOthersPositive.le secondOthersPositive.le firstOthersAtMost
    secondOthersAtMost firstScoreAtZeroPositive secondScoreAtZeroPositive
    firstSpec.1 secondSpec.1 firstSpec.2.1.le secondSpec.2.1.le firstSpec.2.2
    secondSpec.2.2 uniformBound slopeMarginPositive

/-- Coworker stability specialized to the boundary pair consisting of zero and
a positive coworker environment. -/
theorem nonlinearSelectedBestResponse_zero_to_positive_others_bound
    (params : Params) (theta othersEffort othersCap : ℝ) (firmSize : Nat)
    (paramsValid : ValidParams params) (thetaPositive : 0 < theta)
    (thetaBelowOne : theta < 1) (aPositive : 0 < params.a)
    (othersPositive : 0 < othersEffort) (othersAtMost : othersEffort ≤ othersCap)
    (firmSizePositive : 0 < firmSize) (betaTwo : params.beta = 2)
    (scoreAtPositiveOthers :
      0 < nonlinearFirstOrderScore params theta 0 othersEffort)
    (scoreAtOnePositiveOthers :
      nonlinearFirstOrderScore params theta 1 othersEffort < 0)
    (uniformBound : 2 * params.b * theta < (1 - theta) * params.a)
    (slopeMarginPositive :
      2 * params.b * (theta - othersEffort) < params.a) :
    |nonlinearSelectedBestResponse params theta othersEffort firmSize paramsValid
          thetaPositive.le thetaBelowOne.le -
        nonlinearSelectedBestResponse params theta 0 firmSize paramsValid
          thetaPositive.le thetaBelowOne.le| ≤
      othersEffort * quadraticOthersSensitivityBound params theta othersCap /
        (params.a - 2 * params.b * (theta - othersEffort)) := by
  rw [nonlinearSelectedBestResponse_eq_quadraticZeroCoworkerRoot params theta
      firmSize paramsValid thetaPositive thetaBelowOne aPositive firmSizePositive
      betaTwo,
    nonlinearSelectedBestResponse_eq_quadraticPositiveRoot params theta
      othersEffort firmSize paramsValid thetaPositive.le thetaBelowOne aPositive
      othersPositive firmSizePositive betaTwo scoreAtPositiveOthers
      scoreAtOnePositiveOthers]
  have zeroSpec := quadraticZeroCoworkerRoot_spec params theta aPositive
    paramsValid.2.2.1 thetaPositive thetaBelowOne betaTwo
  have positiveSpec := quadraticPositiveRoot_spec params theta othersEffort betaTwo
    scoreAtPositiveOthers scoreAtOnePositiveOthers
  have scoreAtZeroCoworkers :
      0 < nonlinearFirstOrderScore params theta 0 0 := by
    rw [nonlinearFirstOrderScore_beta_two_at_zero params theta 0 betaTwo]
    nlinarith
  have capNonnegative : 0 ≤ othersCap :=
    le_trans othersPositive.le othersAtMost
  simpa [abs_of_pos othersPositive, max_eq_right othersPositive.le] using
    (beta_two_positive_scoreRoot_others_abs_sub_le_uniform_div_margin params
      theta 0 othersEffort othersCap
      (quadraticZeroCoworkerRoot params theta aPositive paramsValid.2.2.1
        thetaPositive thetaBelowOne betaTwo)
      (quadraticPositiveRoot params theta othersEffort betaTwo
      scoreAtPositiveOthers scoreAtOnePositiveOthers)
      betaTwo paramsValid.2.2.1 thetaPositive.le thetaBelowOne.le (by norm_num)
      othersPositive.le capNonnegative othersAtMost scoreAtZeroCoworkers
      scoreAtPositiveOthers zeroSpec.1 positiveSpec.1 zeroSpec.2.1.le
      positiveSpec.2.1.le zeroSpec.2.2 positiveSpec.2.2 uniformBound
      (by simpa [max_eq_right othersPositive.le] using slopeMarginPositive))

/-- One-sided coworker-effort continuity at the zero environment on the
nonnegative domain. -/
theorem continuousAt_nonlinearNonnegativeOthersResponse_zero
    (params : Params) (theta : ℝ) (firmSize : Nat)
    (paramsValid : ValidParams params) (thetaPositive : 0 < theta)
    (thetaBelowOne : theta < 1) (aPositive : 0 < params.a)
    (firmSizePositive : 0 < firmSize) (betaTwo : params.beta = 2)
    (uniformBound : 2 * params.b * theta < (1 - theta) * params.a) :
    ContinuousAt
      (nonlinearNonnegativeOthersResponse params theta firmSize paramsValid
        thetaPositive.le thetaBelowOne.le)
      (⟨0, by simp⟩ : Set.Ici (0 : ℝ)) := by
  let zeroPoint : Set.Ici (0 : ℝ) := ⟨0, by simp⟩
  let score := fun candidate : Set.Ici (0 : ℝ) =>
    nonlinearFirstOrderScore params theta 0 candidate.1
  let margin := fun candidate : Set.Ici (0 : ℝ) =>
    params.a - 2 * params.b * (theta - candidate.1)
  let sensitivity := quadraticOthersSensitivityBound params theta 1
  have scoreContinuous : Continuous score := by
    apply Continuous.congr
      (show Continuous (fun candidate : Set.Ici (0 : ℝ) =>
        theta * (params.a + 2 * params.b * candidate.1) -
          (1 - theta) *
            (params.a * candidate.1 + params.b * candidate.1 ^ 2)) by fun_prop)
    intro candidate
    exact (nonlinearFirstOrderScore_beta_two_at_zero params theta candidate.1
      betaTwo).symm
  have scoreAtZeroPositive : 0 < score zeroPoint := by
    have base : 0 < nonlinearFirstOrderScore params theta 0 0 := by
      rw [nonlinearFirstOrderScore_beta_two_at_zero params theta 0 betaTwo]
      nlinarith
    exact base
  have marginAtZeroPositive : 0 < margin zeroPoint := by
    have base : 0 < params.a - 2 * params.b * theta := by
      have weightedLinearAtMost : (1 - theta) * params.a ≤ params.a := by
        nlinarith [mul_nonneg thetaPositive.le aPositive.le]
      nlinarith
    change 0 < params.a - 2 * params.b * (theta - zeroPoint.val)
    have zeroPointValue : zeroPoint.val = 0 := by rfl
    rw [zeroPointValue]
    simpa using base
  have sensitivityPositive : 0 < sensitivity := by
    exact quadraticOthersSensitivityBound_pos params theta 1 aPositive
      paramsValid.2.2.1 thetaBelowOne (by norm_num)
  rw [Metric.continuousAt_iff]
  intro epsilon epsilonPositive
  obtain ⟨scoreDelta, scoreDeltaPositive, scoreClose⟩ :=
    (Metric.continuousAt_iff.mp scoreContinuous.continuousAt)
      (score zeroPoint / 2) (div_pos scoreAtZeroPositive zero_lt_two)
  let scaleDelta := epsilon * margin zeroPoint / sensitivity
  have scaleDeltaPositive : 0 < scaleDelta := by
    dsimp [scaleDelta]
    positivity
  refine ⟨min scoreDelta (min 1 scaleDelta),
    lt_min scoreDeltaPositive (lt_min zero_lt_one scaleDeltaPositive), ?_⟩
  intro candidate candidateClose
  by_cases candidateZero : candidate.1 = 0
  · have candidateEq : candidate = zeroPoint := Subtype.ext candidateZero
    subst candidate
    change dist
      (nonlinearSelectedBestResponse params theta 0 firmSize paramsValid
        thetaPositive.le thetaBelowOne.le)
      (nonlinearSelectedBestResponse params theta 0 firmSize paramsValid
        thetaPositive.le thetaBelowOne.le) < epsilon
    rw [dist_self]
    exact epsilonPositive
  have candidatePositive : 0 < candidate.1 :=
    lt_of_le_of_ne candidate.2 (Ne.symm candidateZero)
  have scoreDistance := scoreClose
    (lt_of_lt_of_le candidateClose (min_le_left _ _))
  change dist (score candidate) (score zeroPoint) < score zeroPoint / 2 at scoreDistance
  have candidateScorePositive : 0 < score candidate := by
    rw [Real.dist_eq, abs_lt] at scoreDistance
    linarith
  have candidateDistanceOne : dist candidate.1 0 < 1 := by
    have distanceBound := lt_of_lt_of_le candidateClose
      (min_le_right _ _ |>.trans (min_le_left _ _))
    change dist candidate.1 0 < 1 at distanceBound
    exact distanceBound
  have candidateAtMostOne : candidate.1 ≤ 1 := by
    rw [Real.dist_eq, sub_zero, abs_of_nonneg candidate.2] at candidateDistanceOne
    exact candidateDistanceOne.le
  have candidateMarginPositive : 0 < margin candidate := by
    have addedEffortNonnegative :
        0 ≤ 2 * params.b * candidate.1 :=
      mul_nonneg (mul_nonneg (by norm_num) paramsValid.2.2.1) candidate.2
    have marginMonotone : margin zeroPoint ≤ margin candidate := by
      change params.a - 2 * params.b * (theta - 0) ≤
        params.a - 2 * params.b * (theta - candidate.1)
      calc
        params.a - 2 * params.b * (theta - 0) =
            params.a - 2 * params.b * theta := by ring
        _ ≤ params.a - 2 * params.b * theta +
            2 * params.b * candidate.1 :=
          le_add_of_nonneg_right addedEffortNonnegative
        _ = params.a - 2 * params.b * (theta - candidate.1) := by ring
    exact lt_of_lt_of_le marginAtZeroPositive marginMonotone
  have responseBound :=
    nonlinearSelectedBestResponse_zero_to_positive_others_bound params theta
      candidate.1 1 firmSize paramsValid thetaPositive thetaBelowOne aPositive
      candidatePositive candidateAtMostOne firmSizePositive betaTwo
      candidateScorePositive
      (nonlinearFirstOrderScore_beta_two_at_one_negative params theta candidate.1
        betaTwo aPositive paramsValid.2.2.1 candidate.2 thetaBelowOne)
      uniformBound (by
        change 0 < params.a - 2 * params.b * (theta - candidate.1) at candidateMarginPositive
        linarith)
  have scaleDistance : dist candidate.1 0 < scaleDelta := by
    have distanceBound := lt_of_lt_of_le candidateClose
      (min_le_right _ _ |>.trans (min_le_right _ _))
    change dist candidate.1 0 < scaleDelta at distanceBound
    exact distanceBound
  rw [Real.dist_eq, sub_zero, abs_of_nonneg candidate.2] at scaleDistance
  have numeratorSmall :
      candidate.1 * sensitivity < epsilon * margin zeroPoint := by
    dsimp [scaleDelta] at scaleDistance
    exact (lt_div_iff₀ sensitivityPositive).mp scaleDistance
  have marginMonotone : margin zeroPoint ≤ margin candidate := by
    have addedEffortNonnegative :
        0 ≤ 2 * params.b * candidate.1 :=
      mul_nonneg (mul_nonneg (by norm_num) paramsValid.2.2.1) candidate.2
    change params.a - 2 * params.b * (theta - 0) ≤
      params.a - 2 * params.b * (theta - candidate.1)
    calc
      params.a - 2 * params.b * (theta - 0) =
          params.a - 2 * params.b * theta := by ring
      _ ≤ params.a - 2 * params.b * theta +
          2 * params.b * candidate.1 :=
        le_add_of_nonneg_right addedEffortNonnegative
      _ = params.a - 2 * params.b * (theta - candidate.1) := by ring
  have targetProductSmall :
      candidate.1 * sensitivity < epsilon * margin candidate :=
    lt_of_lt_of_le numeratorSmall
      (mul_le_mul_of_nonneg_left marginMonotone epsilonPositive.le)
  have quotientSmall :
      candidate.1 * sensitivity / margin candidate < epsilon :=
    (div_lt_iff₀ candidateMarginPositive).2 targetProductSmall
  unfold nonlinearNonnegativeOthersResponse
  change dist
    (nonlinearSelectedBestResponse params theta candidate.1 firmSize paramsValid
      thetaPositive.le thetaBelowOne.le)
    (nonlinearSelectedBestResponse params theta 0 firmSize paramsValid
      thetaPositive.le thetaBelowOne.le) < epsilon
  rw [Real.dist_eq]
  exact lt_of_le_of_lt
    (by simpa [margin, sensitivity] using responseBound) quotientSmall

/-- Coworker-effort continuity on the strict positive-participation branch,
away from the zero-coworker boundary. -/
theorem continuousAt_nonlinearOthersResponse_positiveBranch
    (params : Params) (theta othersEffort : ℝ) (firmSize : Nat)
    (paramsValid : ValidParams params) (thetaNonnegative : 0 ≤ theta)
    (thetaBelowOne : theta < 1) (aPositive : 0 < params.a)
    (othersPositive : 0 < othersEffort) (firmSizePositive : 0 < firmSize)
    (betaTwo : params.beta = 2)
    (scoreAtZeroPositive :
      0 < nonlinearFirstOrderScore params theta 0 othersEffort)
    (uniformBound : 2 * params.b * theta < (1 - theta) * params.a) :
    ContinuousAt
      (nonlinearOthersResponse params theta firmSize paramsValid thetaNonnegative
        thetaBelowOne.le)
      othersEffort := by
  let score := fun candidateOthers : ℝ =>
    nonlinearFirstOrderScore params theta 0 candidateOthers
  let pairedMargin := fun candidateOthers : ℝ =>
    params.a - 2 * params.b *
      (theta - max othersEffort candidateOthers)
  let othersCap := othersEffort + 1
  let sensitivity :=
    quadraticOthersSensitivityBound params theta othersCap
  have scoreContinuous : Continuous score := by
    apply Continuous.congr
      (show Continuous (fun candidateOthers : ℝ =>
        theta * (params.a + 2 * params.b * candidateOthers) -
          (1 - theta) *
            (params.a * candidateOthers + params.b * candidateOthers ^ 2)) by
        fun_prop)
    intro candidateOthers
    exact (nonlinearFirstOrderScore_beta_two_at_zero params theta candidateOthers
      betaTwo).symm
  have pairedMarginContinuous : Continuous pairedMargin := by fun_prop
  have marginAtReferencePositive : 0 < pairedMargin othersEffort := by
    simp [pairedMargin]
    have weightedLinearAtMost : (1 - theta) * params.a ≤ params.a := by
      have thetaAtMostOne : theta ≤ 1 := thetaBelowOne.le
      nlinarith [mul_nonneg thetaNonnegative aPositive.le]
    have removedEffortNonnegative :
        0 ≤ 2 * params.b * othersEffort :=
      mul_nonneg (mul_nonneg (by norm_num) paramsValid.2.2.1)
        othersPositive.le
    nlinarith
  have sensitivityPositive : 0 < sensitivity := by
    apply quadraticOthersSensitivityBound_pos params theta othersCap aPositive
      paramsValid.2.2.1 thetaBelowOne
    dsimp [othersCap]
    linarith
  rw [Metric.continuousAt_iff]
  intro epsilon epsilonPositive
  obtain ⟨scoreDelta, scoreDeltaPositive, scoreClose⟩ :=
    (Metric.continuousAt_iff.mp scoreContinuous.continuousAt)
      (score othersEffort / 2) (by dsimp [score]; positivity)
  obtain ⟨marginDelta, marginDeltaPositive, marginClose⟩ :=
    (Metric.continuousAt_iff.mp pairedMarginContinuous.continuousAt)
      (pairedMargin othersEffort / 2)
      (div_pos marginAtReferencePositive zero_lt_two)
  let scaleDelta :=
    epsilon * pairedMargin othersEffort / (2 * sensitivity)
  have scaleDeltaPositive : 0 < scaleDelta := by
    dsimp [scaleDelta]
    positivity
  refine ⟨min (min scoreDelta marginDelta)
    (min (min othersEffort 1) scaleDelta), ?_, ?_⟩
  · exact lt_min (lt_min scoreDeltaPositive marginDeltaPositive)
      (lt_min (lt_min othersPositive zero_lt_one) scaleDeltaPositive)
  intro candidateOthers candidateClose
  have scoreDistance := scoreClose (lt_of_lt_of_le candidateClose
    (min_le_left _ _ |>.trans (min_le_left _ _)))
  have marginDistance := marginClose (lt_of_lt_of_le candidateClose
    (min_le_left _ _ |>.trans (min_le_right _ _)))
  have candidatePositive : 0 < candidateOthers := by
    have distanceLt : dist candidateOthers othersEffort < othersEffort := by
      exact lt_of_lt_of_le candidateClose
        (min_le_right _ _ |>.trans (min_le_left _ _) |>.trans (min_le_left _ _))
    rw [Real.dist_eq] at distanceLt
    have lower := (abs_lt.mp distanceLt).1
    linarith
  have candidateAtMostCap : candidateOthers ≤ othersCap := by
    have distanceLt : dist candidateOthers othersEffort < 1 := by
      exact lt_of_lt_of_le candidateClose
        (min_le_right _ _ |>.trans (min_le_left _ _) |>.trans (min_le_right _ _))
    rw [Real.dist_eq] at distanceLt
    have upper := (abs_lt.mp distanceLt).2
    dsimp [othersCap]
    linarith
  have referenceAtMostCap : othersEffort ≤ othersCap := by
    dsimp [othersCap]
    linarith
  change dist (score candidateOthers) (score othersEffort) <
    score othersEffort / 2 at scoreDistance
  have candidateScorePositive : 0 < score candidateOthers := by
    rw [Real.dist_eq, abs_lt] at scoreDistance
    linarith [scoreAtZeroPositive]
  change dist (pairedMargin candidateOthers) (pairedMargin othersEffort) <
    pairedMargin othersEffort / 2 at marginDistance
  have candidateMarginLower :
      pairedMargin othersEffort / 2 < pairedMargin candidateOthers := by
    rw [Real.dist_eq, abs_lt] at marginDistance
    linarith [marginDistance.1]
  have candidateMarginPositive : 0 < pairedMargin candidateOthers :=
    lt_trans (div_pos marginAtReferencePositive zero_lt_two)
      candidateMarginLower
  have responseBound :=
    nonlinearSelectedBestResponse_others_abs_sub_le_uniform_div_margin params
      theta othersEffort candidateOthers othersCap firmSize paramsValid
      thetaNonnegative thetaBelowOne aPositive othersPositive candidatePositive
      referenceAtMostCap candidateAtMostCap firmSizePositive betaTwo
      scoreAtZeroPositive candidateScorePositive
      (nonlinearFirstOrderScore_beta_two_at_one_negative params theta othersEffort
        betaTwo aPositive paramsValid.2.2.1 othersPositive.le thetaBelowOne)
      (nonlinearFirstOrderScore_beta_two_at_one_negative params theta
        candidateOthers betaTwo aPositive paramsValid.2.2.1 candidatePositive.le
        thetaBelowOne)
      uniformBound
      (by dsimp [pairedMargin] at candidateMarginPositive ⊢; linarith)
  have scaleDistance : dist candidateOthers othersEffort < scaleDelta := by
    exact lt_of_lt_of_le candidateClose
      (min_le_right _ _ |>.trans (min_le_right _ _))
  rw [Real.dist_eq] at scaleDistance
  have numeratorSmall :
      |candidateOthers - othersEffort| * sensitivity <
        epsilon * pairedMargin othersEffort / 2 := by
    dsimp [scaleDelta] at scaleDistance
    calc
      |candidateOthers - othersEffort| * sensitivity <
          (epsilon * pairedMargin othersEffort / (2 * sensitivity)) *
            sensitivity :=
        mul_lt_mul_of_pos_right scaleDistance sensitivityPositive
      _ = epsilon * pairedMargin othersEffort / 2 := by
        field_simp [sensitivityPositive.ne']
  have scaledMargin :
      epsilon * pairedMargin othersEffort / 2 <
        epsilon * pairedMargin candidateOthers := by
    have multiplied :=
      mul_lt_mul_of_pos_left candidateMarginLower epsilonPositive
    simpa [mul_div_assoc] using multiplied
  have quotientSmall :
      |candidateOthers - othersEffort| * sensitivity /
          pairedMargin candidateOthers < epsilon := by
    apply (div_lt_iff₀ candidateMarginPositive).2
    exact lt_trans numeratorSmall scaledMargin
  change dist
    (nonlinearSelectedBestResponse params theta candidateOthers firmSize
      paramsValid thetaNonnegative thetaBelowOne.le)
    (nonlinearSelectedBestResponse params theta othersEffort firmSize
      paramsValid thetaNonnegative thetaBelowOne.le) < epsilon
  rw [Real.dist_eq]
  exact lt_of_le_of_lt
    (by simpa [pairedMargin, sensitivity] using responseBound) quotientSmall

/-- Coworker-effort continuity on the strict non-participation branch follows
from local constancy of the uniquely selected zero response. -/
theorem continuousAt_nonlinearOthersResponse_negativeBranch
    (params : Params) (theta othersEffort : ℝ) (firmSize : Nat)
    (paramsValid : ValidParams params) (thetaNonnegative : 0 ≤ theta)
    (thetaBelowOne : theta < 1) (aPositive : 0 < params.a)
    (othersPositive : 0 < othersEffort) (firmSizePositive : 0 < firmSize)
    (betaTwo : params.beta = 2)
    (scoreAtZeroNegative :
      nonlinearFirstOrderScore params theta 0 othersEffort < 0)
    (uniformBound : 2 * params.b * theta < (1 - theta) * params.a) :
    ContinuousAt
      (nonlinearOthersResponse params theta firmSize paramsValid thetaNonnegative
        thetaBelowOne.le)
      othersEffort := by
  let score := fun candidateOthers : ℝ =>
    nonlinearFirstOrderScore params theta 0 candidateOthers
  have scoreContinuous : Continuous score := by
    apply Continuous.congr
      (show Continuous (fun candidateOthers : ℝ =>
        theta * (params.a + 2 * params.b * candidateOthers) -
          (1 - theta) *
            (params.a * candidateOthers + params.b * candidateOthers ^ 2)) by
        fun_prop)
    intro candidateOthers
    exact (nonlinearFirstOrderScore_beta_two_at_zero params theta candidateOthers
      betaTwo).symm
  have slopeNegativeAtPositiveOthers : ∀ {candidateOthers : ℝ},
      0 < candidateOthers →
      2 * params.b * (theta - candidateOthers) < params.a := by
    intro candidateOthers candidatePositive
    have weightedLinearAtMost : (1 - theta) * params.a ≤ params.a := by
      nlinarith [mul_nonneg thetaNonnegative aPositive.le]
    have removedEffortNonnegative :
        0 ≤ 2 * params.b * candidateOthers :=
      mul_nonneg (mul_nonneg (by norm_num) paramsValid.2.2.1)
        candidatePositive.le
    nlinarith
  have responseAtReferenceZero :
      nonlinearOthersResponse params theta firmSize paramsValid thetaNonnegative
        thetaBelowOne.le othersEffort = 0 := by
    unfold nonlinearOthersResponse
    exact nonlinearSelectedBestResponse_eq_zero_of_nonpositive_score params theta
      othersEffort firmSize paramsValid thetaNonnegative thetaBelowOne aPositive
      othersPositive firmSizePositive betaTwo
      (slopeNegativeAtPositiveOthers othersPositive) scoreAtZeroNegative.le
  rw [Metric.continuousAt_iff]
  intro epsilon epsilonPositive
  obtain ⟨scoreDelta, scoreDeltaPositive, scoreClose⟩ :=
    (Metric.continuousAt_iff.mp scoreContinuous.continuousAt)
      (-score othersEffort / 2) (by dsimp [score]; linarith)
  refine ⟨min scoreDelta othersEffort, lt_min scoreDeltaPositive othersPositive, ?_⟩
  intro candidateOthers candidateClose
  have scoreDistance := scoreClose
    (lt_of_lt_of_le candidateClose (min_le_left _ _))
  have positivityDistance : dist candidateOthers othersEffort < othersEffort :=
    lt_of_lt_of_le candidateClose (min_le_right _ _)
  have candidatePositive : 0 < candidateOthers := by
    rw [Real.dist_eq] at positivityDistance
    have lower := (abs_lt.mp positivityDistance).1
    linarith
  change dist (score candidateOthers) (score othersEffort) <
    -score othersEffort / 2 at scoreDistance
  have candidateScoreNegative : score candidateOthers < 0 := by
    rw [Real.dist_eq, abs_lt] at scoreDistance
    linarith [scoreAtZeroNegative]
  have responseAtCandidateZero :
      nonlinearOthersResponse params theta firmSize paramsValid thetaNonnegative
        thetaBelowOne.le candidateOthers = 0 := by
    unfold nonlinearOthersResponse
    exact nonlinearSelectedBestResponse_eq_zero_of_nonpositive_score params theta
      candidateOthers firmSize paramsValid thetaNonnegative thetaBelowOne
      aPositive candidatePositive firmSizePositive betaTwo
      (slopeNegativeAtPositiveOthers candidatePositive)
      candidateScoreNegative.le
  rw [responseAtCandidateZero, responseAtReferenceZero, dist_self]
  exact epsilonPositive

/-- Coworker-effort continuity at an exact participation boundary. Nearby
responses are controlled uniformly whether their score at zero is positive or
nonpositive. -/
theorem continuousAt_nonlinearOthersResponse_participationBoundary
    (params : Params) (theta othersEffort : ℝ) (firmSize : Nat)
    (paramsValid : ValidParams params) (thetaNonnegative : 0 ≤ theta)
    (thetaBelowOne : theta < 1) (aPositive : 0 < params.a)
    (othersPositive : 0 < othersEffort) (firmSizePositive : 0 < firmSize)
    (betaTwo : params.beta = 2)
    (scoreAtZeroEq :
      nonlinearFirstOrderScore params theta 0 othersEffort = 0)
    (uniformBound : 2 * params.b * theta < (1 - theta) * params.a) :
    ContinuousAt
      (nonlinearOthersResponse params theta firmSize paramsValid thetaNonnegative
        thetaBelowOne.le)
      othersEffort := by
  let score := fun candidateOthers : ℝ =>
    nonlinearFirstOrderScore params theta 0 candidateOthers
  let margin := fun candidateOthers : ℝ =>
    params.a - 2 * params.b * (theta - candidateOthers)
  have scoreContinuous : Continuous score := by
    apply Continuous.congr
      (show Continuous (fun candidateOthers : ℝ =>
        theta * (params.a + 2 * params.b * candidateOthers) -
          (1 - theta) *
            (params.a * candidateOthers + params.b * candidateOthers ^ 2)) by
        fun_prop)
    intro candidateOthers
    exact (nonlinearFirstOrderScore_beta_two_at_zero params theta candidateOthers
      betaTwo).symm
  have marginContinuous : Continuous margin := by fun_prop
  have slopeAtPositiveOthers : ∀ {candidateOthers : ℝ},
      0 < candidateOthers →
      2 * params.b * (theta - candidateOthers) < params.a := by
    intro candidateOthers candidatePositive
    have weightedLinearAtMost : (1 - theta) * params.a ≤ params.a := by
      nlinarith [mul_nonneg thetaNonnegative aPositive.le]
    have removedEffortNonnegative :
        0 ≤ 2 * params.b * candidateOthers :=
      mul_nonneg (mul_nonneg (by norm_num) paramsValid.2.2.1)
        candidatePositive.le
    nlinarith
  have marginAtReferencePositive : 0 < margin othersEffort := by
    dsimp [margin]
    exact sub_pos.mpr (slopeAtPositiveOthers othersPositive)
  have responseAtReferenceZero :
      nonlinearOthersResponse params theta firmSize paramsValid thetaNonnegative
        thetaBelowOne.le othersEffort = 0 := by
    unfold nonlinearOthersResponse
    exact nonlinearSelectedBestResponse_eq_zero_of_nonpositive_score params theta
      othersEffort firmSize paramsValid thetaNonnegative thetaBelowOne aPositive
      othersPositive firmSizePositive betaTwo
      (slopeAtPositiveOthers othersPositive) scoreAtZeroEq.le
  rw [Metric.continuousAt_iff]
  intro epsilon epsilonPositive
  obtain ⟨scoreDelta, scoreDeltaPositive, scoreClose⟩ :=
    (Metric.continuousAt_iff.mp scoreContinuous.continuousAt)
      (epsilon * margin othersEffort / 2)
      (div_pos (mul_pos epsilonPositive marginAtReferencePositive) zero_lt_two)
  obtain ⟨marginDelta, marginDeltaPositive, marginClose⟩ :=
    (Metric.continuousAt_iff.mp marginContinuous.continuousAt)
      (margin othersEffort / 2)
      (div_pos marginAtReferencePositive zero_lt_two)
  refine ⟨min (min scoreDelta marginDelta) othersEffort,
    lt_min (lt_min scoreDeltaPositive marginDeltaPositive) othersPositive, ?_⟩
  intro candidateOthers candidateClose
  have scoreDistance := scoreClose (lt_of_lt_of_le candidateClose
    (min_le_left _ _ |>.trans (min_le_left _ _)))
  have marginDistance := marginClose (lt_of_lt_of_le candidateClose
    (min_le_left _ _ |>.trans (min_le_right _ _)))
  have positivityDistance : dist candidateOthers othersEffort < othersEffort :=
    lt_of_lt_of_le candidateClose (min_le_right _ _)
  have candidatePositive : 0 < candidateOthers := by
    rw [Real.dist_eq] at positivityDistance
    have lower := (abs_lt.mp positivityDistance).1
    linarith
  change dist (score candidateOthers) (score othersEffort) <
    epsilon * margin othersEffort / 2 at scoreDistance
  change dist (margin candidateOthers) (margin othersEffort) <
    margin othersEffort / 2 at marginDistance
  have candidateMarginLower :
      margin othersEffort / 2 < margin candidateOthers := by
    rw [Real.dist_eq, abs_lt] at marginDistance
    linarith [marginDistance.1]
  have candidateMarginPositive : 0 < margin candidateOthers :=
    lt_trans (div_pos marginAtReferencePositive zero_lt_two)
      candidateMarginLower
  have candidateScoreSmall :
      score candidateOthers < epsilon * margin candidateOthers := by
    have scoreReference : score othersEffort = 0 := scoreAtZeroEq
    rw [Real.dist_eq, scoreReference, sub_zero, abs_lt] at scoreDistance
    have scaledMargin :=
      mul_lt_mul_of_pos_left candidateMarginLower epsilonPositive
    have scaledMargin' :
        epsilon * margin othersEffort / 2 <
          epsilon * margin candidateOthers := by
      simpa [mul_div_assoc] using scaledMargin
    have scoreUpper : score candidateOthers <
        epsilon * margin othersEffort / 2 := scoreDistance.2
    exact lt_trans scoreUpper scaledMargin'
  have candidateScoreAtOneNegative :=
    nonlinearFirstOrderScore_beta_two_at_one_negative params theta
      candidateOthers betaTwo aPositive paramsValid.2.2.1 candidatePositive.le
      thetaBelowOne
  have responseBounds :
      nonlinearSelectedBestResponse params theta candidateOthers firmSize
        paramsValid thetaNonnegative thetaBelowOne.le ∈ Set.Ico 0 epsilon := by
    constructor
    · exact (nonlinearSelectedBestResponse_spec params theta candidateOthers
        firmSize paramsValid thetaNonnegative thetaBelowOne.le).1.1
    · by_cases candidateScoreNonpositive : score candidateOthers ≤ 0
      · rw [nonlinearSelectedBestResponse_eq_zero_of_nonpositive_score params
          theta candidateOthers firmSize paramsValid thetaNonnegative
          thetaBelowOne aPositive candidatePositive firmSizePositive betaTwo
          (slopeAtPositiveOthers candidatePositive) candidateScoreNonpositive]
        exact epsilonPositive
      · have candidateScorePositive : 0 < score candidateOthers :=
          lt_of_not_ge candidateScoreNonpositive
        rw [nonlinearSelectedBestResponse_eq_quadraticPositiveRoot params theta
          candidateOthers firmSize paramsValid thetaNonnegative thetaBelowOne
          aPositive candidatePositive firmSizePositive betaTwo
          candidateScorePositive candidateScoreAtOneNegative]
        exact beta_two_positive_scoreRoot_lt_epsilon params theta candidateOthers
          (quadraticPositiveRoot params theta candidateOthers betaTwo
            candidateScorePositive candidateScoreAtOneNegative)
          epsilon betaTwo paramsValid.2.2.1 thetaNonnegative
          (quadraticPositiveRoot_spec params theta candidateOthers betaTwo
            candidateScorePositive candidateScoreAtOneNegative).2.2
          (slopeAtPositiveOthers candidatePositive) candidateScoreSmall
  unfold nonlinearOthersResponse at responseAtReferenceZero ⊢
  change dist
    (nonlinearSelectedBestResponse params theta candidateOthers firmSize
      paramsValid thetaNonnegative thetaBelowOne.le)
    (nonlinearSelectedBestResponse params theta othersEffort firmSize
      paramsValid thetaNonnegative thetaBelowOne.le) < epsilon
  rw [responseAtReferenceZero, Real.dist_eq, sub_zero,
    abs_of_nonneg responseBounds.1]
  exact responseBounds.2

/-- Unified coworker-effort continuity on the nonnegative domain. -/
theorem continuousAt_nonlinearNonnegativeOthersResponse
    (params : Params) (theta : ℝ) (firmSize : Nat)
    (paramsValid : ValidParams params) (thetaPositive : 0 < theta)
    (thetaBelowOne : theta < 1) (aPositive : 0 < params.a)
    (firmSizePositive : 0 < firmSize) (betaTwo : params.beta = 2)
    (uniformBound : 2 * params.b * theta < (1 - theta) * params.a)
    (othersEffort : Set.Ici (0 : ℝ)) :
    ContinuousAt
      (nonlinearNonnegativeOthersResponse params theta firmSize paramsValid
        thetaPositive.le thetaBelowOne.le)
      othersEffort := by
  by_cases othersZero : othersEffort.1 = 0
  · have othersEq : othersEffort = (⟨0, by simp⟩ : Set.Ici (0 : ℝ)) :=
      Subtype.ext othersZero
    subst othersEffort
    exact continuousAt_nonlinearNonnegativeOthersResponse_zero params theta
      firmSize paramsValid thetaPositive thetaBelowOne aPositive
      firmSizePositive betaTwo uniformBound
  have othersPositive : 0 < othersEffort.1 :=
    lt_of_le_of_ne othersEffort.2 (Ne.symm othersZero)
  rcases lt_trichotomy
      (nonlinearFirstOrderScore params theta 0 othersEffort.1) 0 with
      scoreNegative | scoreZero | scorePositive
  · have realContinuity :=
      continuousAt_nonlinearOthersResponse_negativeBranch params theta
        othersEffort.1 firmSize paramsValid thetaPositive.le thetaBelowOne
        aPositive othersPositive firmSizePositive betaTwo scoreNegative
        uniformBound
    have restricted := realContinuity.comp continuousAt_subtype_val
    simpa [Function.comp_def, nonlinearOthersResponse,
      nonlinearNonnegativeOthersResponse] using restricted
  · have realContinuity :=
      continuousAt_nonlinearOthersResponse_participationBoundary params theta
        othersEffort.1 firmSize paramsValid thetaPositive.le thetaBelowOne
        aPositive othersPositive firmSizePositive betaTwo scoreZero uniformBound
    have restricted := realContinuity.comp continuousAt_subtype_val
    simpa [Function.comp_def, nonlinearOthersResponse,
      nonlinearNonnegativeOthersResponse] using restricted
  · have realContinuity :=
      continuousAt_nonlinearOthersResponse_positiveBranch params theta
        othersEffort.1 firmSize paramsValid thetaPositive.le thetaBelowOne
        aPositive othersPositive firmSizePositive betaTwo scorePositive
        uniformBound
    have restricted := realContinuity.comp continuousAt_subtype_val
    simpa [Function.comp_def, nonlinearOthersResponse,
      nonlinearNonnegativeOthersResponse] using restricted

theorem continuous_nonlinearNonnegativeOthersResponse
    (params : Params) (theta : ℝ) (firmSize : Nat)
    (paramsValid : ValidParams params) (thetaPositive : 0 < theta)
    (thetaBelowOne : theta < 1) (aPositive : 0 < params.a)
    (firmSizePositive : 0 < firmSize) (betaTwo : params.beta = 2)
    (uniformBound : 2 * params.b * theta < (1 - theta) * params.a) :
    Continuous
      (nonlinearNonnegativeOthersResponse params theta firmSize paramsValid
        thetaPositive.le thetaBelowOne.le) :=
  continuous_iff_continuousAt.mpr fun othersEffort =>
    continuousAt_nonlinearNonnegativeOthersResponse params theta firmSize
      paramsValid thetaPositive thetaBelowOne aPositive firmSizePositive betaTwo
      uniformBound othersEffort

/-- On the participation branch, the canonical selected response inherits the
quantitative approach-to-threshold estimate for the positive score root. -/
theorem nonlinearSelectedBestResponse_lt_epsilon_of_positive_score
    (params : Params) (theta othersEffort epsilon : ℝ) (firmSize : Nat)
    (paramsValid : ValidParams params) (thetaNonnegative : 0 ≤ theta)
    (thetaAtMostOne : theta < 1) (aPositive : 0 < params.a)
    (othersPositive : 0 < othersEffort) (firmSizePositive : 0 < firmSize)
    (betaTwo : params.beta = 2)
    (scoreAtZeroPositive :
      0 < nonlinearFirstOrderScore params theta 0 othersEffort)
    (scoreAtOneNegative :
      nonlinearFirstOrderScore params theta 1 othersEffort < 0)
    (slopeAtZeroNegative : 2 * params.b * (theta - othersEffort) < params.a)
    (scoreAtZeroSmall : nonlinearFirstOrderScore params theta 0 othersEffort <
      epsilon * (params.a - 2 * params.b * (theta - othersEffort))) :
    nonlinearSelectedBestResponse params theta othersEffort firmSize paramsValid
      thetaNonnegative thetaAtMostOne.le < epsilon := by
  rw [nonlinearSelectedBestResponse_eq_quadraticPositiveRoot params theta
    othersEffort firmSize paramsValid thetaNonnegative thetaAtMostOne aPositive
    othersPositive firmSizePositive betaTwo scoreAtZeroPositive scoreAtOneNegative]
  exact beta_two_positive_scoreRoot_lt_epsilon params theta othersEffort
    (quadraticPositiveRoot params theta othersEffort betaTwo scoreAtZeroPositive
      scoreAtOneNegative) epsilon betaTwo paramsValid.2.2.1 thetaNonnegative
    (quadraticPositiveRoot_spec params theta othersEffort betaTwo
      scoreAtZeroPositive scoreAtOneNegative).2.2 slopeAtZeroNegative
    scoreAtZeroSmall

/-- Selector-level threshold estimate covering both sides of participation.
The selected response lies in `[0, epsilon)` whenever the score-at-zero surplus
is smaller than `epsilon` times the positive slope margin. -/
theorem nonlinearSelectedBestResponse_mem_Ico_zero_epsilon
    (params : Params) (theta othersEffort epsilon : ℝ) (firmSize : Nat)
    (paramsValid : ValidParams params) (thetaNonnegative : 0 ≤ theta)
    (thetaAtMostOne : theta < 1) (aPositive : 0 < params.a)
    (othersPositive : 0 < othersEffort) (firmSizePositive : 0 < firmSize)
    (betaTwo : params.beta = 2) (epsilonPositive : 0 < epsilon)
    (scoreAtOneNegative :
      nonlinearFirstOrderScore params theta 1 othersEffort < 0)
    (slopeAtZeroNegative : 2 * params.b * (theta - othersEffort) < params.a)
    (scoreAtZeroSmall : nonlinearFirstOrderScore params theta 0 othersEffort <
      epsilon * (params.a - 2 * params.b * (theta - othersEffort))) :
    nonlinearSelectedBestResponse params theta othersEffort firmSize paramsValid
      thetaNonnegative thetaAtMostOne.le ∈ Set.Ico 0 epsilon := by
  constructor
  · exact (nonlinearSelectedBestResponse_spec params theta othersEffort firmSize
      paramsValid thetaNonnegative thetaAtMostOne.le).1.1
  · by_cases scoreAtZeroNonpositive :
        nonlinearFirstOrderScore params theta 0 othersEffort ≤ 0
    · rw [nonlinearSelectedBestResponse_eq_zero_of_nonpositive_score params theta
        othersEffort firmSize paramsValid thetaNonnegative thetaAtMostOne aPositive
        othersPositive firmSizePositive betaTwo slopeAtZeroNegative
        scoreAtZeroNonpositive]
      exact epsilonPositive
    · exact nonlinearSelectedBestResponse_lt_epsilon_of_positive_score params theta
        othersEffort epsilon firmSize paramsValid thetaNonnegative thetaAtMostOne
        aPositive othersPositive firmSizePositive betaTwo
        (lt_of_not_ge scoreAtZeroNonpositive) scoreAtOneNegative
        slopeAtZeroNegative scoreAtZeroSmall

/-- At the participation threshold, the feasible-theta response is exactly
zero. This supplies the value against which continuity is measured. -/
theorem nonlinearFeasibleThetaResponse_at_participationThreshold_eq_zero
    (params : Params) (othersEffort : ℝ) (firmSize : Nat)
    (paramsValid : ValidParams params) (aPositive : 0 < params.a)
    (othersPositive : 0 < othersEffort) (firmSizePositive : 0 < firmSize)
    (betaTwo : params.beta = 2)
    (slopeAtThresholdNegative :
      2 * params.b *
          (quadraticParticipationThreshold params othersEffort - othersEffort) <
        params.a) :
    nonlinearFeasibleThetaResponse params othersEffort firmSize paramsValid
        ⟨quadraticParticipationThreshold params othersEffort,
          (quadraticParticipationThreshold_mem_Ioo params othersEffort aPositive
            paramsValid.2.2.1 othersPositive).1.le,
          (quadraticParticipationThreshold_mem_Ioo params othersEffort aPositive
            paramsValid.2.2.1 othersPositive).2.le⟩ = 0 := by
  unfold nonlinearFeasibleThetaResponse
  apply nonlinearSelectedBestResponse_eq_zero_of_nonpositive_score params
    (quadraticParticipationThreshold params othersEffort) othersEffort firmSize
    paramsValid
  · exact (quadraticParticipationThreshold_mem_Ioo params othersEffort aPositive
      paramsValid.2.2.1 othersPositive).2
  · exact aPositive
  · exact othersPositive
  · exact firmSizePositive
  · exact betaTwo
  · exact slopeAtThresholdNegative
  · exact (nonlinearFirstOrderScore_at_quadraticParticipationThreshold_eq_zero
      params othersEffort aPositive paramsValid.2.2.1 othersPositive betaTwo).le

/-- The feasible-theta selector is continuous at the participation threshold
whenever the score's own-effort slope has a strictly positive margin there. -/
theorem continuousAt_nonlinearFeasibleThetaResponse_participationThreshold
    (params : Params) (othersEffort : ℝ) (firmSize : Nat)
    (paramsValid : ValidParams params) (aPositive : 0 < params.a)
    (othersPositive : 0 < othersEffort) (firmSizePositive : 0 < firmSize)
    (betaTwo : params.beta = 2)
    (slopeAtThresholdNegative :
      2 * params.b *
          (quadraticParticipationThreshold params othersEffort - othersEffort) <
        params.a) :
    ContinuousAt
      (nonlinearFeasibleThetaResponse params othersEffort firmSize paramsValid)
      ⟨quadraticParticipationThreshold params othersEffort,
        (quadraticParticipationThreshold_mem_Ioo params othersEffort aPositive
          paramsValid.2.2.1 othersPositive).1.le,
        (quadraticParticipationThreshold_mem_Ioo params othersEffort aPositive
          paramsValid.2.2.1 othersPositive).2.le⟩ := by
  let threshold := quadraticParticipationThreshold params othersEffort
  let thresholdPoint : Set.Icc (0 : ℝ) 1 :=
    ⟨threshold,
      (quadraticParticipationThreshold_mem_Ioo params othersEffort aPositive
        paramsValid.2.2.1 othersPositive).1.le,
      (quadraticParticipationThreshold_mem_Ioo params othersEffort aPositive
        paramsValid.2.2.1 othersPositive).2.le⟩
  have thresholdBelowOne : threshold < 1 :=
    (quadraticParticipationThreshold_mem_Ioo params othersEffort aPositive
      paramsValid.2.2.1 othersPositive).2
  let score := fun theta : Set.Icc (0 : ℝ) 1 =>
    nonlinearFirstOrderScore params theta.1 0 othersEffort
  let margin := fun theta : Set.Icc (0 : ℝ) 1 =>
    params.a - 2 * params.b * (theta.1 - othersEffort)
  have scoreContinuous : Continuous score := by
    apply Continuous.congr
      (show Continuous (fun theta : Set.Icc (0 : ℝ) 1 =>
        theta.1 * (params.a + 2 * params.b * othersEffort) -
          (1 - theta.1) *
            (params.a * othersEffort + params.b * othersEffort ^ 2)) by fun_prop)
    intro theta
    exact (nonlinearFirstOrderScore_beta_two_at_zero params theta.1 othersEffort
      betaTwo).symm
  have marginContinuous : Continuous margin := by fun_prop
  have scoreThreshold : score thresholdPoint = 0 := by
    exact nonlinearFirstOrderScore_at_quadraticParticipationThreshold_eq_zero
      params othersEffort aPositive paramsValid.2.2.1 othersPositive betaTwo
  have marginThresholdPositive : 0 < margin thresholdPoint := by
    dsimp [margin, thresholdPoint, threshold]
    linarith
  rw [Metric.continuousAt_iff]
  intro epsilon epsilonPositive
  obtain ⟨scoreDelta, scoreDeltaPositive, scoreClose⟩ :=
    (Metric.continuousAt_iff.mp scoreContinuous.continuousAt)
      (epsilon * margin thresholdPoint / 2)
      (div_pos (mul_pos epsilonPositive marginThresholdPositive) zero_lt_two)
  obtain ⟨marginDelta, marginDeltaPositive, marginClose⟩ :=
    (Metric.continuousAt_iff.mp marginContinuous.continuousAt)
      (margin thresholdPoint / 2)
      (div_pos marginThresholdPositive zero_lt_two)
  refine ⟨min (min scoreDelta marginDelta) (1 - threshold), ?_, ?_⟩
  · exact lt_min (lt_min scoreDeltaPositive marginDeltaPositive)
      (sub_pos.mpr thresholdBelowOne)
  intro theta thetaClose
  have scoreDistance := scoreClose (lt_of_lt_of_le thetaClose (min_le_left _ _ |>.trans
    (min_le_left _ _)))
  have marginDistance := marginClose (lt_of_lt_of_le thetaClose (min_le_left _ _ |>.trans
    (min_le_right _ _)))
  change dist (score theta) (score thresholdPoint) <
    epsilon * margin thresholdPoint / 2 at scoreDistance
  change dist (margin theta) (margin thresholdPoint) <
    margin thresholdPoint / 2 at marginDistance
  have thetaDistance : dist theta.1 threshold < 1 - threshold := by
    simpa [thresholdPoint] using
      (lt_of_lt_of_le thetaClose (min_le_right _ _))
  have thetaBelowOne : theta.1 < 1 := by
    rw [Real.dist_eq] at thetaDistance
    have := (lt_of_le_of_lt (le_abs_self (theta.1 - threshold)) thetaDistance)
    linarith
  have marginPositive : 0 < margin theta := by
    rw [Real.dist_eq, abs_lt] at marginDistance
    have marginLower : margin thresholdPoint / 2 < margin theta := by
      linarith [marginDistance.1]
    exact lt_trans (div_pos marginThresholdPositive zero_lt_two) marginLower
  have scoreSmall : score theta < epsilon * margin theta := by
    rw [Real.dist_eq, scoreThreshold, sub_zero, abs_lt] at scoreDistance
    rw [Real.dist_eq, abs_lt] at marginDistance
    have marginLower : margin thresholdPoint / 2 < margin theta := by
      linarith [marginDistance.1]
    have scaledMargin :
        epsilon * (margin thresholdPoint / 2) < epsilon * margin theta :=
      mul_lt_mul_of_pos_left marginLower epsilonPositive
    have scoreUpper : score theta < epsilon * (margin thresholdPoint / 2) := by
      simpa [mul_div_assoc] using scoreDistance.2
    exact lt_trans scoreUpper scaledMargin
  have responseBounds := nonlinearSelectedBestResponse_mem_Ico_zero_epsilon params
    theta.1 othersEffort epsilon firmSize paramsValid theta.2.1 thetaBelowOne
    aPositive othersPositive firmSizePositive betaTwo epsilonPositive
    (nonlinearFirstOrderScore_beta_two_at_one_negative params theta.1 othersEffort
      betaTwo aPositive paramsValid.2.2.1 othersPositive.le thetaBelowOne)
    (by dsimp [margin] at marginPositive ⊢; linarith) (by exact scoreSmall)
  rw [nonlinearFeasibleThetaResponse_at_participationThreshold_eq_zero params
    othersEffort firmSize paramsValid aPositive othersPositive firmSizePositive
    betaTwo slopeAtThresholdNegative]
  rw [Real.dist_eq, sub_zero]
  change |nonlinearSelectedBestResponse params theta.1 othersEffort firmSize
    paramsValid theta.2.1 theta.2.2| < epsilon
  rw [abs_of_nonneg responseBounds.1]
  exact responseBounds.2

/-- The canonical feasible-theta response is continuous at every strictly
participating preference weight where the own-effort slope margin is positive. -/
theorem continuousAt_nonlinearFeasibleThetaResponse_positiveBranch
    (params : Params) (othersEffort : ℝ) (firmSize : Nat)
    (paramsValid : ValidParams params) (theta : Set.Icc (0 : ℝ) 1)
    (aPositive : 0 < params.a) (othersPositive : 0 < othersEffort)
    (firmSizePositive : 0 < firmSize) (betaTwo : params.beta = 2)
    (thetaBelowOne : theta.1 < 1)
    (scoreAtZeroPositive :
      0 < nonlinearFirstOrderScore params theta.1 0 othersEffort)
    (slopeMarginPositive :
      2 * params.b * (theta.1 - othersEffort) < params.a) :
    ContinuousAt
      (nonlinearFeasibleThetaResponse params othersEffort firmSize paramsValid)
      theta := by
  let score := fun candidate : Set.Icc (0 : ℝ) 1 =>
    nonlinearFirstOrderScore params candidate.1 0 othersEffort
  let pairedMargin := fun candidate : Set.Icc (0 : ℝ) 1 =>
    params.a - 2 * params.b * (max theta.1 candidate.1 - othersEffort)
  let sensitivity := quadraticThetaSensitivityBound params othersEffort
  have scoreContinuous : Continuous score := by
    apply Continuous.congr
      (show Continuous (fun candidate : Set.Icc (0 : ℝ) 1 =>
        candidate.1 * (params.a + 2 * params.b * othersEffort) -
          (1 - candidate.1) *
            (params.a * othersEffort + params.b * othersEffort ^ 2)) by fun_prop)
    intro candidate
    exact (nonlinearFirstOrderScore_beta_two_at_zero params candidate.1
      othersEffort betaTwo).symm
  have pairedMarginContinuous : Continuous pairedMargin := by fun_prop
  have pairedMarginAtTheta : pairedMargin theta =
      params.a - 2 * params.b * (theta.1 - othersEffort) := by
    simp [pairedMargin]
  have marginAtThetaPositive : 0 < pairedMargin theta := by
    rw [pairedMarginAtTheta]
    linarith
  have sensitivityPositive : 0 < sensitivity := by
    exact quadraticThetaSensitivityBound_pos params othersEffort aPositive
      paramsValid.2.2.1 othersPositive.le
  rw [Metric.continuousAt_iff]
  intro epsilon epsilonPositive
  obtain ⟨scoreDelta, scoreDeltaPositive, scoreClose⟩ :=
    (Metric.continuousAt_iff.mp scoreContinuous.continuousAt)
      (score theta / 2) (by dsimp [score]; positivity)
  obtain ⟨marginDelta, marginDeltaPositive, marginClose⟩ :=
    (Metric.continuousAt_iff.mp pairedMarginContinuous.continuousAt)
      (pairedMargin theta / 2)
      (div_pos marginAtThetaPositive zero_lt_two)
  let scaleDelta := epsilon * pairedMargin theta / (2 * sensitivity)
  have scaleDeltaPositive : 0 < scaleDelta := by
    dsimp [scaleDelta]
    positivity
  refine ⟨min (min scoreDelta marginDelta)
    (min (1 - theta.1) scaleDelta), ?_, ?_⟩
  · exact lt_min (lt_min scoreDeltaPositive marginDeltaPositive)
      (lt_min (sub_pos.mpr thetaBelowOne) scaleDeltaPositive)
  intro candidate candidateClose
  have scoreDistance := scoreClose (lt_of_lt_of_le candidateClose
    (min_le_left _ _ |>.trans (min_le_left _ _)))
  have marginDistance := marginClose (lt_of_lt_of_le candidateClose
    (min_le_left _ _ |>.trans (min_le_right _ _)))
  have candidateThetaDistance : dist candidate.1 theta.1 < 1 - theta.1 := by
    simpa using (lt_of_lt_of_le candidateClose
      (min_le_right _ _ |>.trans (min_le_left _ _)))
  have candidateBelowOne : candidate.1 < 1 := by
    rw [Real.dist_eq] at candidateThetaDistance
    have upper := lt_of_le_of_lt (le_abs_self (candidate.1 - theta.1))
      candidateThetaDistance
    linarith
  change dist (score candidate) (score theta) < score theta / 2 at scoreDistance
  have candidateScorePositive : 0 < score candidate := by
    rw [Real.dist_eq, abs_lt] at scoreDistance
    linarith [scoreAtZeroPositive]
  change dist (pairedMargin candidate) (pairedMargin theta) <
    pairedMargin theta / 2 at marginDistance
  have candidateMarginLower : pairedMargin theta / 2 < pairedMargin candidate := by
    rw [Real.dist_eq, abs_lt] at marginDistance
    linarith [marginDistance.1]
  have candidateMarginPositive : 0 < pairedMargin candidate :=
    lt_trans (div_pos marginAtThetaPositive zero_lt_two) candidateMarginLower
  have responseBound := nonlinearSelectedBestResponse_abs_sub_le_uniform_div_margin
    params theta.1 candidate.1 othersEffort firmSize paramsValid theta.2.1
    candidate.2.1 thetaBelowOne candidateBelowOne aPositive othersPositive
    firmSizePositive betaTwo scoreAtZeroPositive candidateScorePositive
    (nonlinearFirstOrderScore_beta_two_at_one_negative params theta.1 othersEffort
      betaTwo aPositive paramsValid.2.2.1 othersPositive.le thetaBelowOne)
    (nonlinearFirstOrderScore_beta_two_at_one_negative params candidate.1
      othersEffort betaTwo aPositive paramsValid.2.2.1 othersPositive.le
      candidateBelowOne)
    (by dsimp [pairedMargin] at candidateMarginPositive ⊢; linarith)
  have scaleDistance : dist candidate.1 theta.1 < scaleDelta := by
    simpa using (lt_of_lt_of_le candidateClose
      (min_le_right _ _ |>.trans (min_le_right _ _)))
  rw [Real.dist_eq] at scaleDistance
  have numeratorSmall :
      |candidate.1 - theta.1| * sensitivity <
        epsilon * pairedMargin theta / 2 := by
    dsimp [scaleDelta] at scaleDistance
    calc
      |candidate.1 - theta.1| * sensitivity <
          (epsilon * pairedMargin theta / (2 * sensitivity)) * sensitivity :=
        mul_lt_mul_of_pos_right scaleDistance sensitivityPositive
      _ = epsilon * pairedMargin theta / 2 := by
        field_simp [sensitivityPositive.ne']
  have targetProductSmall :
      |candidate.1 - theta.1| * sensitivity <
        epsilon * pairedMargin candidate := by
    have scaledMargin := mul_lt_mul_of_pos_left candidateMarginLower epsilonPositive
    have scaledMargin' :
        epsilon * pairedMargin theta / 2 <
          epsilon * pairedMargin candidate := by
      simpa [mul_div_assoc] using scaledMargin
    exact lt_trans numeratorSmall scaledMargin'
  have quotientSmall :
      |candidate.1 - theta.1| * sensitivity / pairedMargin candidate < epsilon :=
    (div_lt_iff₀ candidateMarginPositive).2 (by simpa [mul_comm] using targetProductSmall)
  change dist
    (nonlinearSelectedBestResponse params candidate.1 othersEffort firmSize
      paramsValid candidate.2.1 candidate.2.2)
    (nonlinearSelectedBestResponse params theta.1 othersEffort firmSize
      paramsValid theta.2.1 theta.2.2) < epsilon
  rw [Real.dist_eq]
  exact lt_of_le_of_lt (by simpa [pairedMargin, sensitivity] using responseBound)
    quotientSmall

/-- On the strict non-participation branch the selected response is locally
constant at zero, and hence continuous. -/
theorem continuousAt_nonlinearFeasibleThetaResponse_negativeBranch
    (params : Params) (othersEffort : ℝ) (firmSize : Nat)
    (paramsValid : ValidParams params) (theta : Set.Icc (0 : ℝ) 1)
    (aPositive : 0 < params.a) (othersPositive : 0 < othersEffort)
    (firmSizePositive : 0 < firmSize) (betaTwo : params.beta = 2)
    (thetaBelowOne : theta.1 < 1)
    (scoreAtZeroNegative :
      nonlinearFirstOrderScore params theta.1 0 othersEffort < 0)
    (slopeMarginPositive :
      2 * params.b * (theta.1 - othersEffort) < params.a) :
    ContinuousAt
      (nonlinearFeasibleThetaResponse params othersEffort firmSize paramsValid)
      theta := by
  let score := fun candidate : Set.Icc (0 : ℝ) 1 =>
    nonlinearFirstOrderScore params candidate.1 0 othersEffort
  let margin := fun candidate : Set.Icc (0 : ℝ) 1 =>
    params.a - 2 * params.b * (candidate.1 - othersEffort)
  have scoreContinuous : Continuous score := by
    apply Continuous.congr
      (show Continuous (fun candidate : Set.Icc (0 : ℝ) 1 =>
        candidate.1 * (params.a + 2 * params.b * othersEffort) -
          (1 - candidate.1) *
            (params.a * othersEffort + params.b * othersEffort ^ 2)) by fun_prop)
    intro candidate
    exact (nonlinearFirstOrderScore_beta_two_at_zero params candidate.1
      othersEffort betaTwo).symm
  have marginContinuous : Continuous margin := by fun_prop
  have marginAtThetaPositive : 0 < margin theta := by
    dsimp [margin]
    linarith
  have responseAtThetaZero :
      nonlinearFeasibleThetaResponse params othersEffort firmSize paramsValid theta = 0 := by
    unfold nonlinearFeasibleThetaResponse
    exact nonlinearSelectedBestResponse_eq_zero_of_nonpositive_score params theta.1
      othersEffort firmSize paramsValid theta.2.1 thetaBelowOne aPositive
      othersPositive firmSizePositive betaTwo slopeMarginPositive
      scoreAtZeroNegative.le
  rw [Metric.continuousAt_iff]
  intro epsilon epsilonPositive
  obtain ⟨scoreDelta, scoreDeltaPositive, scoreClose⟩ :=
    (Metric.continuousAt_iff.mp scoreContinuous.continuousAt)
      (-score theta / 2) (by dsimp [score]; linarith)
  obtain ⟨marginDelta, marginDeltaPositive, marginClose⟩ :=
    (Metric.continuousAt_iff.mp marginContinuous.continuousAt)
      (margin theta / 2) (div_pos marginAtThetaPositive zero_lt_two)
  refine ⟨min (min scoreDelta marginDelta) (1 - theta.1), ?_, ?_⟩
  · exact lt_min (lt_min scoreDeltaPositive marginDeltaPositive)
      (sub_pos.mpr thetaBelowOne)
  intro candidate candidateClose
  have scoreDistance := scoreClose (lt_of_lt_of_le candidateClose
    (min_le_left _ _ |>.trans (min_le_left _ _)))
  have marginDistance := marginClose (lt_of_lt_of_le candidateClose
    (min_le_left _ _ |>.trans (min_le_right _ _)))
  have candidateThetaDistance : dist candidate.1 theta.1 < 1 - theta.1 := by
    simpa using (lt_of_lt_of_le candidateClose (min_le_right _ _))
  have candidateBelowOne : candidate.1 < 1 := by
    rw [Real.dist_eq] at candidateThetaDistance
    have upper := lt_of_le_of_lt (le_abs_self (candidate.1 - theta.1))
      candidateThetaDistance
    linarith
  change dist (score candidate) (score theta) < -score theta / 2 at scoreDistance
  have candidateScoreNegative : score candidate < 0 := by
    rw [Real.dist_eq, abs_lt] at scoreDistance
    linarith [scoreAtZeroNegative]
  change dist (margin candidate) (margin theta) < margin theta / 2 at marginDistance
  have candidateMarginPositive : 0 < margin candidate := by
    rw [Real.dist_eq, abs_lt] at marginDistance
    have lower : margin theta / 2 < margin candidate := by
      linarith [marginDistance.1]
    exact lt_trans (div_pos marginAtThetaPositive zero_lt_two) lower
  have responseAtCandidateZero :
      nonlinearFeasibleThetaResponse params othersEffort firmSize paramsValid
        candidate = 0 := by
    unfold nonlinearFeasibleThetaResponse
    exact nonlinearSelectedBestResponse_eq_zero_of_nonpositive_score params
      candidate.1 othersEffort firmSize paramsValid candidate.2.1
      candidateBelowOne aPositive othersPositive firmSizePositive betaTwo
      (by dsimp [margin] at candidateMarginPositive ⊢; linarith)
      candidateScoreNegative.le
  rw [responseAtCandidateZero, responseAtThetaZero, dist_self]
  exact epsilonPositive

/-- Unified continuity theorem across strict non-participation, the exact
participation threshold, and strict positive participation. -/
theorem continuousAt_nonlinearFeasibleThetaResponse_of_positive_slopeMargin
    (params : Params) (othersEffort : ℝ) (firmSize : Nat)
    (paramsValid : ValidParams params) (theta : Set.Icc (0 : ℝ) 1)
    (aPositive : 0 < params.a) (othersPositive : 0 < othersEffort)
    (firmSizePositive : 0 < firmSize) (betaTwo : params.beta = 2)
    (thetaBelowOne : theta.1 < 1)
    (slopeMarginPositive :
      2 * params.b * (theta.1 - othersEffort) < params.a) :
    ContinuousAt
      (nonlinearFeasibleThetaResponse params othersEffort firmSize paramsValid)
      theta := by
  rcases lt_trichotomy
      (nonlinearFirstOrderScore params theta.1 0 othersEffort) 0 with
      scoreNegative | scoreZero | scorePositive
  · exact continuousAt_nonlinearFeasibleThetaResponse_negativeBranch params
      othersEffort firmSize paramsValid theta aPositive othersPositive
      firmSizePositive betaTwo thetaBelowOne scoreNegative slopeMarginPositive
  · have thetaValueEq :
        theta.1 = quadraticParticipationThreshold params othersEffort :=
      (nonlinearFirstOrderScore_at_zero_eq_zero_iff_theta_eq_threshold params
        theta.1 othersEffort aPositive paramsValid.2.2.1 othersPositive betaTwo).mp
        scoreZero
    let thresholdPoint : Set.Icc (0 : ℝ) 1 :=
      ⟨quadraticParticipationThreshold params othersEffort,
        (quadraticParticipationThreshold_mem_Ioo params othersEffort aPositive
          paramsValid.2.2.1 othersPositive).1.le,
        (quadraticParticipationThreshold_mem_Ioo params othersEffort aPositive
          paramsValid.2.2.1 othersPositive).2.le⟩
    have thetaEq : theta = thresholdPoint := Subtype.ext thetaValueEq
    subst theta
    apply continuousAt_nonlinearFeasibleThetaResponse_participationThreshold
      params othersEffort firmSize paramsValid aPositive othersPositive
      firmSizePositive betaTwo
    dsimp [thresholdPoint] at slopeMarginPositive ⊢
    exact slopeMarginPositive
  · exact continuousAt_nonlinearFeasibleThetaResponse_positiveBranch params
      othersEffort firmSize paramsValid theta aPositive othersPositive
      firmSizePositive betaTwo thetaBelowOne scorePositive slopeMarginPositive

/-- The compact convex effort cube for a fixed group. -/
abbrev FeasibleFixedGroupProfile (groupSize : Nat) :=
  Fin groupSize → Set.Icc (0 : ℝ) 1

/-- Nonnegative coworker effort induced by a feasible fixed-group profile. -/
def feasibleFixedGroupOtherEffort {groupSize : Nat}
    (profile : FeasibleFixedGroupProfile groupSize) (agent : Fin groupSize) :
    Set.Ici (0 : ℝ) :=
  ⟨∑ other ∈ Finset.univ.filter (· ≠ agent), (profile other).1,
    Finset.sum_nonneg fun other _ => (profile other).2.1⟩

theorem continuous_feasibleFixedGroupOtherEffort {groupSize : Nat}
    (agent : Fin groupSize) :
    Continuous (fun profile : FeasibleFixedGroupProfile groupSize =>
      feasibleFixedGroupOtherEffort profile agent) := by
  apply Continuous.subtype_mk
  fun_prop

/-- Simultaneous nonlinear best response as a self-map of the feasible effort
cube. -/
noncomputable def nonlinearFeasibleFixedGroupResponse (params : Params)
    {groupSize : Nat} (theta : Fin groupSize → ℝ)
    (paramsValid : ValidParams params)
    (thetaNonnegative : ∀ agent, 0 ≤ theta agent)
    (thetaAtMostOne : ∀ agent, theta agent ≤ 1) :
    FeasibleFixedGroupProfile groupSize → FeasibleFixedGroupProfile groupSize :=
  fun profile agent =>
    ⟨nonlinearSelectedBestResponse params (theta agent)
        (feasibleFixedGroupOtherEffort profile agent).1 groupSize paramsValid
        (thetaNonnegative agent) (thetaAtMostOne agent),
      (nonlinearSelectedBestResponse_spec params (theta agent)
        (feasibleFixedGroupOtherEffort profile agent).1 groupSize paramsValid
        (thetaNonnegative agent) (thetaAtMostOne agent)).1⟩

theorem continuous_nonlinearFeasibleFixedGroupResponse (params : Params)
    {groupSize : Nat} (theta : Fin groupSize → ℝ)
    (paramsValid : ValidParams params)
    (thetaPositive : ∀ agent, 0 < theta agent)
    (thetaBelowOne : ∀ agent, theta agent < 1)
    (aPositive : 0 < params.a) (groupSizePositive : 0 < groupSize)
    (betaTwo : params.beta = 2)
    (uniformBound : ∀ agent,
      2 * params.b * theta agent < (1 - theta agent) * params.a) :
    Continuous
      (nonlinearFeasibleFixedGroupResponse params theta paramsValid
        (fun agent => (thetaPositive agent).le)
        (fun agent => (thetaBelowOne agent).le)) := by
  apply continuous_pi
  intro agent
  apply Continuous.subtype_mk
  have scalarContinuous :=
    continuous_nonlinearNonnegativeOthersResponse params (theta agent)
      groupSize paramsValid (thetaPositive agent) (thetaBelowOne agent)
      aPositive groupSizePositive betaTwo (uniformBound agent)
  exact scalarContinuous.comp
    (continuous_feasibleFixedGroupOtherEffort agent)

/-- The precise finite-dimensional topological dependency needed after proving
continuity of the feasible-cube response. This is Brouwer's fixed-point
principle specialized to the cube representation used here. -/
def FeasibleCubeFixedPointPrinciple (groupSize : Nat) : Prop :=
  ∀ response : FeasibleFixedGroupProfile groupSize →
      FeasibleFixedGroupProfile groupSize,
    Continuous response → ∃ profile, response profile = profile

/-- Brouwer's theorem on products of simplices supplies the fixed-point
principle for every nonempty finite feasible-profile cube. -/
theorem feasibleCubeFixedPointPrinciple_of_positive {groupSize : Nat}
    (groupSizePositive : 0 < groupSize) :
    FeasibleCubeFixedPointPrinciple groupSize := by
  letI : Inhabited (Fin groupSize) := ⟨⟨0, groupSizePositive⟩⟩
  intro response responseContinuous
  let equivalence : FeasibleFixedGroupProfile groupSize ≃ₜ
      ProductSimplices (fun _ : Fin groupSize => (2 : ℕ+)) :=
    Homeomorph.piCongrRight fun _ => (stdSimplexHomeomorphUnitInterval).symm
  let conjugate := equivalence ∘ response ∘ equivalence.symm
  have conjugateContinuous : Continuous conjugate :=
    equivalence.continuous.comp
      (responseContinuous.comp equivalence.symm.continuous)
  obtain ⟨point, pointFixed⟩ :=
    Brouwer_Product (card := fun _ : Fin groupSize => (2 : ℕ+))
      conjugate conjugateContinuous
  refine ⟨equivalence.symm point, ?_⟩
  change equivalence.symm (conjugate point) = _
  simpa [conjugate] using congrArg equivalence.symm pointFixed

/-- Once the finite-cube fixed-point principle is available, continuity of the
nonlinear response produces a fixed-group Nash equilibrium. -/
theorem exists_nonlinearFixedGroupNash_of_cubeFixedPointPrinciple
    (params : Params) {groupSize : Nat} (theta : Fin groupSize → ℝ)
    (paramsValid : ValidParams params)
    (thetaPositive : ∀ agent, 0 < theta agent)
    (thetaBelowOne : ∀ agent, theta agent < 1)
    (aPositive : 0 < params.a) (groupSizePositive : 0 < groupSize)
    (betaTwo : params.beta = 2)
    (uniformBound : ∀ agent,
      2 * params.b * theta agent < (1 - theta agent) * params.a)
    (cubeFixedPoint : FeasibleCubeFixedPointPrinciple groupSize) :
    ∃ profile : FixedGroupProfile groupSize,
      IsFixedGroupNash params theta profile := by
  let response := nonlinearFeasibleFixedGroupResponse params theta paramsValid
    (fun agent => (thetaPositive agent).le)
    (fun agent => (thetaBelowOne agent).le)
  have responseContinuous : Continuous response :=
    continuous_nonlinearFeasibleFixedGroupResponse params theta paramsValid
      thetaPositive thetaBelowOne aPositive groupSizePositive betaTwo uniformBound
  obtain ⟨feasibleProfile, fixedPoint⟩ :=
    cubeFixedPoint response responseContinuous
  let profile : FixedGroupProfile groupSize :=
    fun agent => (feasibleProfile agent).1
  refine ⟨profile, ?_⟩
  intro agent
  have selectedBest := nonlinearSelectedBestResponse_spec params (theta agent)
    (feasibleFixedGroupOtherEffort feasibleProfile agent).1 groupSize paramsValid
    (thetaPositive agent).le (thetaBelowOne agent).le
  have coordinateFixed :
      (response feasibleProfile agent).1 = (feasibleProfile agent).1 :=
    congrArg Subtype.val (congrFun fixedPoint agent)
  change
    nonlinearSelectedBestResponse params (theta agent)
      (feasibleFixedGroupOtherEffort feasibleProfile agent).1 groupSize paramsValid
      (thetaPositive agent).le (thetaBelowOne agent).le =
        (feasibleProfile agent).1 at coordinateFixed
  rw [coordinateFixed] at selectedBest
  simpa [profile, fixedGroupOtherEffort, feasibleFixedGroupOtherEffort] using
    selectedBest

/-- Under the decreasing-score parameter regime, every nonempty finite group
has a nonlinear fixed-group Nash equilibrium. -/
theorem exists_nonlinearFixedGroupNash
    (params : Params) {groupSize : Nat} (theta : Fin groupSize → ℝ)
    (paramsValid : ValidParams params)
    (thetaPositive : ∀ agent, 0 < theta agent)
    (thetaBelowOne : ∀ agent, theta agent < 1)
    (aPositive : 0 < params.a) (groupSizePositive : 0 < groupSize)
    (betaTwo : params.beta = 2)
    (uniformBound : ∀ agent,
      2 * params.b * theta agent < (1 - theta agent) * params.a) :
    ∃ profile : FixedGroupProfile groupSize,
      IsFixedGroupNash params theta profile :=
  exists_nonlinearFixedGroupNash_of_cubeFixedPointPrinciple params theta
    paramsValid thetaPositive thetaBelowOne aPositive groupSizePositive betaTwo
    uniformBound
    (feasibleCubeFixedPointPrinciple_of_positive groupSizePositive)

/-- Simultaneous fixed-membership response obtained by dispatching the scalar
nonlinear selector over agents and their coworker-effort environments. -/
noncomputable def nonlinearFixedGroupResponse (params : Params)
    {groupSize : Nat} (theta : Fin groupSize → ℝ) (paramsValid : ValidParams params)
    (thetaNonnegative : ∀ agent, 0 ≤ theta agent)
    (thetaAtMostOne : ∀ agent, theta agent ≤ 1) :
    FixedGroupProfile groupSize → FixedGroupProfile groupSize :=
  fun profile agent => nonlinearSelectedBestResponse params (theta agent)
    (fixedGroupOtherEffort profile agent) groupSize paramsValid
    (thetaNonnegative agent) (thetaAtMostOne agent)

theorem nonlinearFixedGroupResponse_isBestResponseMap (params : Params)
    {groupSize : Nat} (theta : Fin groupSize → ℝ) (paramsValid : ValidParams params)
    (thetaNonnegative : ∀ agent, 0 ≤ theta agent)
    (thetaAtMostOne : ∀ agent, theta agent ≤ 1) :
    IsFixedGroupBestResponseMap params theta
      (nonlinearFixedGroupResponse params theta paramsValid thetaNonnegative
        thetaAtMostOne) := by
  intro profile agent
  exact nonlinearSelectedBestResponse_spec params (theta agent)
    (fixedGroupOtherEffort profile agent) groupSize paramsValid
    (thetaNonnegative agent) (thetaAtMostOne agent)

theorem fixedPoint_nonlinearFixedGroupResponse_is_nash (params : Params)
    {groupSize : Nat} (theta : Fin groupSize → ℝ) (paramsValid : ValidParams params)
    (thetaNonnegative : ∀ agent, 0 ≤ theta agent)
    (thetaAtMostOne : ∀ agent, theta agent ≤ 1)
    (profile : FixedGroupProfile groupSize)
    (fixedPoint : nonlinearFixedGroupResponse params theta paramsValid
      thetaNonnegative thetaAtMostOne profile = profile) :
    IsFixedGroupNash params theta profile :=
  fixedPoint_of_bestResponseMap_is_nash params theta _
    (nonlinearFixedGroupResponse_isBestResponseMap params theta paramsValid
      thetaNonnegative thetaAtMostOne) profile fixedPoint

end AgenticAxtell.Baseline
