import AgenticAxtell.Baseline.Production

namespace AgenticAxtell.Baseline

noncomputable def utility (params : Params) (theta effort othersEffort : ℝ)
    (firmSize : Nat) : ℝ :=
  (production params (effort + othersEffort) / firmSize) ^ theta *
    (1 - effort) ^ (1 - theta)

def FeasibleEffort : Set ℝ := Set.Icc 0 1

end AgenticAxtell.Baseline
