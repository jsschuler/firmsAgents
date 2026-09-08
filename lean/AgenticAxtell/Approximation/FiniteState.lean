import AgenticAxtell.Approximation.EffortGrid

namespace AgenticAxtell.Approximation

/-- Static bounds for the explicitly finite approximation. -/
structure StateBounds where
  agentSlots : Nat
  firmSlots : Nat

abbrev FiniteAgentId (bounds : StateBounds) := Fin bounds.agentSlots
abbrev FiniteFirmId (bounds : StateBounds) := Fin bounds.firmSlots

/-- An active agent in the finite approximation. Preferences and efforts share
the same unit-interval grid at this first finite milestone. -/
structure FiniteAgentState (grid : EffortGrid) (bounds : StateBounds) where
  theta : EffortLevel grid
  effort : EffortLevel grid
  firm : FiniteFirmId bounds
  neighbors : Finset (FiniteAgentId bounds)
  deriving DecidableEq, Fintype

/-- Bounded global state. Agent slots are optional so termination can later be
added without changing the carrier; firm membership remains canonical in the
agents, while `activeFirms` records the currently valid firm identifiers. -/
structure FiniteModelState (grid : EffortGrid) (bounds : StateBounds) where
  agents : FiniteAgentId bounds → Option (FiniteAgentState grid bounds)
  activeFirms : Finset (FiniteFirmId bounds)
  nextAgent : Option (FiniteAgentId bounds)
  nextFirm : Option (FiniteFirmId bounds)
  deriving DecidableEq, Fintype

instance finite_finiteAgentState (grid : EffortGrid) (bounds : StateBounds) :
    Finite (FiniteAgentState grid bounds) := by infer_instance

instance finite_finiteModelState (grid : EffortGrid) (bounds : StateBounds) :
    Finite (FiniteModelState grid bounds) := by infer_instance

/-- The bounded approximation has a finite global state space before imposing
the semantic validity predicate. -/
theorem finite_global_state_space (grid : EffortGrid) (bounds : StateBounds) :
    Set.Finite (Set.univ : Set (FiniteModelState grid bounds)) :=
  Set.toFinite _

/-- Any validity-restricted state space is finite as a subset of the bounded
global carrier. -/
theorem finite_valid_state_space (grid : EffortGrid) (bounds : StateBounds)
    (Valid : FiniteModelState grid bounds → Prop) :
    Set.Finite {state | Valid state} :=
  Set.toFinite _

end AgenticAxtell.Approximation
