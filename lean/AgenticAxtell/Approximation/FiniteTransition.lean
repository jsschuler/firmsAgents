import AgenticAxtell.Approximation.FiniteState

namespace AgenticAxtell.Approximation

structure FiniteAction (grid : EffortGrid) (bounds : StateBounds) where
  effort : EffortLevel grid
  firm : FiniteFirmId bounds
  deriving DecidableEq, Fintype

/-- All primitive randomness consumed by one finite activation. -/
structure FiniteDraw (bounds : StateBounds) (tieSlots : Nat) where
  selectedAgent : FiniteAgentId bounds
  tieBreak : Fin tieSlots
  deriving DecidableEq, Fintype

def IsCandidateFirm {grid : EffortGrid} {bounds : StateBounds}
    (state : FiniteModelState grid bounds) (agent : FiniteAgentState grid bounds)
    (firm : FiniteFirmId bounds) : Prop :=
  firm = agent.firm ∨ firm ∈ state.activeFirms ∨ state.nextFirm = some firm

def IsAdmissibleAction {grid : EffortGrid} {bounds : StateBounds}
    (state : FiniteModelState grid bounds) (agent : FiniteAgentState grid bounds)
    (action : FiniteAction grid bounds) : Prop :=
  IsCandidateFirm state agent action.firm

/-- Policy boundary: optimization and tie-breaking choose an action, while the
transition below remains deterministic and randomness-free. -/
abbrev FiniteChoiceRule (grid : EffortGrid) (bounds : StateBounds)
    (tieSlots : Nat) :=
  FiniteModelState grid bounds → FiniteDraw bounds tieSlots →
    Option (FiniteAction grid bounds)

def replaceAgent {grid : EffortGrid} {bounds : StateBounds}
    (agents : FiniteAgentId bounds → Option (FiniteAgentState grid bounds))
    (id : FiniteAgentId bounds) (agent : FiniteAgentState grid bounds) :=
  Function.update agents id (some agent)

def activeFirmsOf {grid : EffortGrid} {bounds : StateBounds}
    (agents : FiniteAgentId bounds → Option (FiniteAgentState grid bounds)) :
    Finset (FiniteFirmId bounds) :=
  Finset.univ.filter fun firm => ∃ id agent, agents id = some agent ∧ agent.firm = firm

def activeAgentsOf {grid : EffortGrid} {bounds : StateBounds}
    (agents : FiniteAgentId bounds → Option (FiniteAgentState grid bounds)) :
    Finset (FiniteAgentId bounds) :=
  Finset.univ.filter fun id => (agents id).isSome

/-- Bounded IDs and grid feasibility are enforced by types. The remaining
partition invariant says that listed firms are exactly occupied firms. -/
def FiniteValid {grid : EffortGrid} {bounds : StateBounds}
    (state : FiniteModelState grid bounds) : Prop :=
  state.activeFirms = activeFirmsOf state.agents

/-- Neighbor lists contain only occupied slots and never the agent itself. -/
def FiniteGraphValid {grid : EffortGrid} {bounds : StateBounds}
    (state : FiniteModelState grid bounds) : Prop :=
  ∀ id agent, state.agents id = some agent →
    id ∉ agent.neighbors ∧ agent.neighbors ⊆ activeAgentsOf state.agents

theorem agentFirm_mem_activeFirms {grid : EffortGrid} {bounds : StateBounds}
    {state : FiniteModelState grid bounds} (stateValid : FiniteValid state)
    {id : FiniteAgentId bounds} {agent : FiniteAgentState grid bounds}
    (agentActive : state.agents id = some agent) :
    agent.firm ∈ state.activeFirms := by
  rw [stateValid]
  simp only [activeFirmsOf, Finset.mem_filter, Finset.mem_univ, true_and]
  exact ⟨id, agent, agentActive, rfl⟩

def IsSoundFiniteChoiceRule {grid : EffortGrid} {bounds : StateBounds}
    {tieSlots : Nat} (choose : FiniteChoiceRule grid bounds tieSlots) : Prop :=
  ∀ state draw agent action,
    FiniteValid state → state.agents draw.selectedAgent = some agent →
      choose state draw = some action → IsAdmissibleAction state agent action

def boundedSuccessor {n : Nat} (id : Fin n) : Option (Fin n) :=
  if within : id.val + 1 < n then some ⟨id.val + 1, within⟩ else none

theorem activeAgentsOf_replaceAgent {grid : EffortGrid} {bounds : StateBounds}
    (agents : FiniteAgentId bounds → Option (FiniteAgentState grid bounds))
    (id : FiniteAgentId bounds) (old updated : FiniteAgentState grid bounds)
    (active : agents id = some old) :
    activeAgentsOf (replaceAgent agents id updated) = activeAgentsOf agents := by
  ext candidate
  by_cases same : candidate = id
  · subst candidate
    simp [activeAgentsOf, replaceAgent, active]
  · simp [activeAgentsOf, replaceAgent, Function.update_of_ne same]

theorem graphValid_replaceAgent {grid : EffortGrid} {bounds : StateBounds}
    {state : FiniteModelState grid bounds} {id : FiniteAgentId bounds}
    {old updated : FiniteAgentState grid bounds}
    (stateGraphValid : FiniteGraphValid state)
    (active : state.agents id = some old)
    (sameNeighbors : updated.neighbors = old.neighbors) :
    FiniteGraphValid { state with agents := replaceAgent state.agents id updated } := by
  intro candidate agent candidateActive
  have activeSet := activeAgentsOf_replaceAgent state.agents id old updated active
  by_cases same : candidate = id
  · subst candidate
    have someEq : some updated = some agent := by
      simpa [replaceAgent] using candidateActive
    have updatedEq : updated = agent := Option.some.inj someEq
    subst agent
    simpa [sameNeighbors, activeSet] using stateGraphValid id old active
  · have oldActive : state.agents candidate = some agent := by
      simpa [replaceAgent, Function.update_of_ne same] using candidateActive
    simpa [activeSet] using stateGraphValid candidate agent oldActive

/-- Deterministic finite transition. Missing agents or rejected choices leave
the state unchanged; successful choices update effort and membership atomically. -/
def finiteTransition {grid : EffortGrid} {bounds : StateBounds} {tieSlots : Nat}
    (choose : FiniteChoiceRule grid bounds tieSlots)
    (state : FiniteModelState grid bounds) (draw : FiniteDraw bounds tieSlots) :
    FiniteModelState grid bounds :=
  match state.agents draw.selectedAgent, choose state draw with
  | some agent, some action =>
      let updatedAgent := { agent with effort := action.effort, firm := action.firm }
      let updatedAgents := replaceAgent state.agents draw.selectedAgent updatedAgent
      { agents := updatedAgents
        activeFirms := activeFirmsOf updatedAgents
        nextAgent := state.nextAgent
        nextFirm := if state.nextFirm = some action.firm
          then boundedSuccessor action.firm else state.nextFirm }
  | _, _ => state

@[simp] theorem finiteTransition_missingAgent {grid : EffortGrid}
    {bounds : StateBounds} {tieSlots : Nat}
    (choose : FiniteChoiceRule grid bounds tieSlots)
    (state : FiniteModelState grid bounds) (draw : FiniteDraw bounds tieSlots)
    (missing : state.agents draw.selectedAgent = none) :
    finiteTransition choose state draw = state := by
  simp [finiteTransition, missing]

@[simp] theorem finiteTransition_rejected {grid : EffortGrid}
    {bounds : StateBounds} {tieSlots : Nat}
    (choose : FiniteChoiceRule grid bounds tieSlots)
    (state : FiniteModelState grid bounds) (draw : FiniteDraw bounds tieSlots)
    (rejected : choose state draw = none) :
    finiteTransition choose state draw = state := by
  simp [finiteTransition, rejected]

theorem finiteTransition_valid {grid : EffortGrid} {bounds : StateBounds}
    {tieSlots : Nat} (choose : FiniteChoiceRule grid bounds tieSlots)
    (_chooseSound : IsSoundFiniteChoiceRule choose)
    (state : FiniteModelState grid bounds) (draw : FiniteDraw bounds tieSlots)
    (stateValid : FiniteValid state) :
    FiniteValid (finiteTransition choose state draw) := by
  unfold finiteTransition
  split <;> simp_all [FiniteValid]

theorem finiteTransition_graphValid {grid : EffortGrid} {bounds : StateBounds}
    {tieSlots : Nat} (choose : FiniteChoiceRule grid bounds tieSlots)
    (state : FiniteModelState grid bounds) (draw : FiniteDraw bounds tieSlots)
    (stateGraphValid : FiniteGraphValid state) :
    FiniteGraphValid (finiteTransition choose state draw) := by
  unfold finiteTransition
  split
  · rename_i agent action active selected
    apply graphValid_replaceAgent stateGraphValid active
    rfl
  · exact stateGraphValid

end AgenticAxtell.Approximation
