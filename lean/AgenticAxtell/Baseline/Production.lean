import AgenticAxtell.Baseline.Types

namespace AgenticAxtell.Baseline

noncomputable def production (params : Params) (totalEffort : ℝ) : ℝ :=
  params.a * totalEffort + params.b * totalEffort ^ params.beta

noncomputable def firmEffort (state : State) (firm : FirmId) : ℝ :=
  (state.agents.filter (·.firm = firm)).map (·.effort) |>.sum

noncomputable def firmOutput (params : Params) (state : State) (firm : FirmId) : ℝ :=
  production params (firmEffort state firm)

end AgenticAxtell.Baseline
