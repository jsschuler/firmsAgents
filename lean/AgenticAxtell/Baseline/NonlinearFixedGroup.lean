import AgenticAxtell.Baseline.NonlinearBestResponse
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
