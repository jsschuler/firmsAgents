import AgenticAxtell.Agentic.Transition

namespace AgenticAxtell

open Baseline Agentic

theorem semantic_baseline_recovery (rule : ChoiceRule) (params : Params)
    (state : State) (draw : Draw) :
    Agentic.transition baselineConfig rule params state draw =
      Baseline.transition rule params state draw := rfl

def runBaseline (rule : ChoiceRule) (params : Params) : State → List Draw → State
  | state, [] => state
  | state, draw :: draws =>
      runBaseline rule params (Baseline.transition rule params state draw) draws

def runExtended (config : Config) (rule : ChoiceRule) (params : Params) :
    State → List Draw → State
  | state, [] => state
  | state, draw :: draws =>
      runExtended config rule params (Agentic.transition config rule params state draw) draws

theorem semantic_pathwise_recovery (rule : ChoiceRule) (params : Params)
    (state : State) (draws : List Draw) :
    runExtended baselineConfig rule params state draws =
      runBaseline rule params state draws := by
  induction draws generalizing state with
  | nil => rfl
  | cons draw draws ih =>
      simp only [runExtended, runBaseline]
      rw [semantic_baseline_recovery]
      exact ih (Baseline.transition rule params state draw)

theorem runBaseline_preserves_validity (rule : ChoiceRule) (params : Params)
    (state : State) (draws : List Draw) (valid : Valid params state) :
    Valid params (runBaseline rule params state draws) := by
  induction draws generalizing state with
  | nil => exact valid
  | cons draw draws ih =>
      apply ih
      exact Baseline.transition_preserves_validity rule params state draw valid

theorem recovered_run_preserves_validity (rule : ChoiceRule) (params : Params)
    (state : State) (draws : List Draw) (valid : Valid params state) :
    Valid params (runExtended baselineConfig rule params state draws) := by
  rw [semantic_pathwise_recovery]
  exact runBaseline_preserves_validity rule params state draws valid

end AgenticAxtell
