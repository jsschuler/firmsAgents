import AgenticAxtell.Baseline.BestResponse

namespace AgenticAxtell.Baseline

def findAgent? (state : State) (id : AgentId) : Option Agent :=
  state.agents.find? (·.id = id)

def candidateFirms (state : State) (agent : Agent) : Finset FirmId :=
  let neighborFirms := agent.neighbors.filterMap fun id =>
    (findAgent? state id).map (·.firm)
  {agent.firm} ∪ neighborFirms.toFinset ∪ {state.nextFirmId}

noncomputable def otherEffort (state : State) (agent : Agent) (firm : FirmId) : ℝ :=
  (state.agents.filter fun other => other.firm = firm ∧ other.id ≠ agent.id)
    |>.map (·.effort) |>.sum

def candidateSize (state : State) (agent : Agent) (firm : FirmId) : Nat :=
  if firm = state.nextFirmId then 1
  else (state.agents.filter (·.firm = firm)).length + if firm = agent.firm then 0 else 1

noncomputable def candidateUtility (params : Params) (state : State) (agent : Agent)
    (firm : FirmId) (effort : ℝ) : ℝ :=
  utility params agent.theta effort (otherEffort state agent firm)
    (candidateSize state agent firm)

theorem currentFirm_mem_candidateFirms (state : State) (agent : Agent) :
    agent.firm ∈ candidateFirms state agent := by
  simp [candidateFirms]

theorem startup_mem_candidateFirms (state : State) (agent : Agent) :
    state.nextFirmId ∈ candidateFirms state agent := by
  simp [candidateFirms]

theorem candidateFirm_le_nextFirmId (params : Params) (state : State) (agent : Agent)
    (valid : Valid params state) (agentMem : agent ∈ state.agents)
    {firm : FirmId} (firmMem : firm ∈ candidateFirms state agent) :
    firm ≤ state.nextFirmId := by
  rcases valid with ⟨_, _, firmBounds, _, _, _, _, _, _, neighborsExist⟩
  have agentFirmBound := firmBounds agent agentMem
  simp [candidateFirms] at firmMem
  rcases firmMem with rfl | neighborFirmMem | rfl
  · exact Nat.le_of_lt agentFirmBound
  · rcases neighborFirmMem with ⟨neighborId, neighborIdMem, found, foundEq, foundFirm⟩
    obtain ⟨_, neighborExists⟩ := neighborsExist agent agentMem neighborId neighborIdMem
    rcases List.mem_map.mp neighborExists with ⟨neighbor, neighborMem, neighborIdEq⟩
    have neighborFirmBound := firmBounds neighbor neighborMem
    have foundMem : found ∈ state.agents := by
      apply List.mem_of_find?_eq_some
      exact foundEq
    rw [← foundFirm]
    exact Nat.le_of_lt (firmBounds found foundMem)
  · exact Nat.le_refl _

end AgenticAxtell.Baseline
