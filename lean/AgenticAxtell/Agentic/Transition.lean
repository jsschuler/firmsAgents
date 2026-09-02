import AgenticAxtell.Baseline.SemanticChoice

namespace AgenticAxtell.Agentic

open Baseline

structure Config where
  faithfulAxtell : Bool := true
  allowCompute : Bool := false
  allowSpawn : Bool := false
  allowTermination : Bool := false
  allowDelegation : Bool := false
  allowSpecialization : Bool := false
  allowHierarchy : Bool := false
  allowComputeMarket : Bool := false
  allowComputeInheritance : Bool := false
  allowAgentMutation : Bool := false
  deriving DecidableEq, Repr

def baselineConfig : Config := {}

def transition (_config : Config) (rule : ChoiceRule) (params : Params)
    (state : State) (draw : Draw) : State :=
  Baseline.transition rule params state draw

end AgenticAxtell.Agentic
