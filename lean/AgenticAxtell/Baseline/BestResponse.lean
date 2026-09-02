import AgenticAxtell.Baseline.Utility

namespace AgenticAxtell.Baseline

def IsBestResponse (params : Params) (theta othersEffort : ℝ) (firmSize : Nat)
    (effort : ℝ) : Prop :=
  effort ∈ FeasibleEffort ∧
  ∀ alternative ∈ FeasibleEffort,
    utility params theta alternative othersEffort firmSize ≤
      utility params theta effort othersEffort firmSize

theorem utility_continuous_in_effort (params : Params) (theta othersEffort : ℝ)
    (firmSize : Nat) (paramsValid : ValidParams params)
    (thetaNonnegative : 0 ≤ theta) (thetaAtMostOne : theta ≤ 1) :
    Continuous (fun effort => utility params theta effort othersEffort firmSize) := by
  have betaNonnegative : 0 ≤ params.beta :=
    le_trans zero_le_one paramsValid.2.2.2.1
  have totalContinuous : Continuous (fun effort : ℝ => effort + othersEffort) :=
    continuous_id.add continuous_const
  have poweredTotalContinuous :
      Continuous (fun effort : ℝ => (effort + othersEffort) ^ params.beta) :=
    totalContinuous.rpow_const fun _ => Or.inr betaNonnegative
  have incomeContinuous : Continuous (fun effort : ℝ =>
      (params.a * (effort + othersEffort) +
        params.b * (effort + othersEffort) ^ params.beta) / firmSize) :=
    ((continuous_const.mul totalContinuous).add
      (continuous_const.mul poweredTotalContinuous)).div_const _
  have leisureContinuous : Continuous (fun effort : ℝ => 1 - effort) :=
    continuous_const.sub continuous_id
  unfold utility production
  exact (incomeContinuous.rpow_const fun _ => Or.inr thetaNonnegative).mul
    (leisureContinuous.rpow_const fun _ => Or.inr (sub_nonneg.mpr thetaAtMostOne))

theorem exists_best_response (params : Params) (theta othersEffort : ℝ)
    (firmSize : Nat) (paramsValid : ValidParams params)
    (thetaNonnegative : 0 ≤ theta) (thetaAtMostOne : theta ≤ 1) :
    ∃ effort, IsBestResponse params theta othersEffort firmSize effort := by
  have continuousUtility : ContinuousOn
      (fun effort => utility params theta effort othersEffort firmSize) FeasibleEffort :=
    (utility_continuous_in_effort params theta othersEffort firmSize
      paramsValid thetaNonnegative thetaAtMostOne).continuousOn
  obtain ⟨effort, effortFeasible, maximal⟩ :=
    isCompact_Icc.exists_isMaxOn (Set.nonempty_Icc.mpr zero_le_one) continuousUtility
  exact ⟨effort, effortFeasible, fun alternative alternativeFeasible =>
    maximal alternativeFeasible⟩

end AgenticAxtell.Baseline
