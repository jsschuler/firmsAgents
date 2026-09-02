import AgenticAxtell.Baseline.Candidates

namespace AgenticAxtell.Baseline

structure Choice where
  firm : FirmId
  effort : ℝ

structure ChoiceRule where
  choose : Params → State → Agent → Draw → Choice
  effortFeasible : ∀ params state agent draw,
    Valid params state → agent ∈ state.agents →
    (choose params state agent draw).effort ∈ FeasibleEffort
  firmLocal : ∀ params state agent draw,
    Valid params state → agent ∈ state.agents →
    (choose params state agent draw).firm ∈ candidateFirms state agent
  firmBound : ∀ params state agent draw,
    Valid params state → agent ∈ state.agents →
    (choose params state agent draw).firm ≤ state.nextFirmId
  optimal : ∀ params state agent draw firm,
    Valid params state → agent ∈ state.agents →
    firm ∈ candidateFirms state agent → ∀ effort ∈ FeasibleEffort,
    candidateUtility params state agent firm effort ≤
      candidateUtility params state agent (choose params state agent draw).firm
        (choose params state agent draw).effort

def updateAgent (selected : AgentId) (choice : Choice) (agent : Agent) : Agent :=
  if agent.id = selected then
    { agent with effort := choice.effort, firm := choice.firm }
  else agent

@[simp] theorem updateAgent_id (selected : AgentId) (choice : Choice) (agent : Agent) :
    (updateAgent selected choice agent).id = agent.id := by
  by_cases selectedEq : agent.id = selected <;> simp [updateAgent, selectedEq]

@[simp] theorem updateAgent_theta (selected : AgentId) (choice : Choice) (agent : Agent) :
    (updateAgent selected choice agent).theta = agent.theta := by
  by_cases selectedEq : agent.id = selected <;> simp [updateAgent, selectedEq]

@[simp] theorem updateAgent_neighbors (selected : AgentId) (choice : Choice) (agent : Agent) :
    (updateAgent selected choice agent).neighbors = agent.neighbors := by
  by_cases selectedEq : agent.id = selected <;> simp [updateAgent, selectedEq]

def updateSelected (state : State) (selected : AgentId) (choice : Choice) : State :=
  { state with
    agents := state.agents.map (updateAgent selected choice)
    nextFirmId := if choice.firm = state.nextFirmId then state.nextFirmId + 1 else state.nextFirmId }

def transition (rule : ChoiceRule) (params : Params) (state : State) (draw : Draw) : State :=
  match findAgent? state draw.selectedAgent with
  | none => state
  | some agent => updateSelected state agent.id (rule.choose params state agent draw)

theorem updateSelected_preserves_validity (params : Params) (state : State)
    (selected : AgentId) (choice : Choice) (valid : Valid params state)
    (effortFeasible : choice.effort ∈ FeasibleEffort)
    (firmBound : choice.firm ≤ state.nextFirmId) :
    Valid params (updateSelected state selected choice) := by
  rcases valid with ⟨paramsValid, population, firms, ids, idPositive, thetaBound,
    effortBound, neighborCount, neighborUnique, neighborsExist⟩
  have mappedIds :
      (updateSelected state selected choice).agents.map (·.id) =
        state.agents.map (·.id) := by
    simp [updateSelected, List.map_map]
  refine ⟨paramsValid, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · simpa [updateSelected] using population
  · intro agent agentMem
    rcases List.mem_map.mp agentMem with ⟨oldAgent, oldMem, rfl⟩
    have oldFirmBound := firms oldAgent oldMem
    by_cases selectedEq : oldAgent.id = selected
    · by_cases fresh : choice.firm = state.nextFirmId
      · simp [updateSelected, updateAgent, selectedEq, fresh]
      · have choiceLt : choice.firm < state.nextFirmId :=
          Nat.lt_of_le_of_ne firmBound fresh
        simpa [updateSelected, updateAgent, selectedEq, fresh] using choiceLt
    · by_cases fresh : choice.firm = state.nextFirmId
      · have oldFirmNext : oldAgent.firm < state.nextFirmId + 1 :=
          Nat.lt.step oldFirmBound
        simpa [updateSelected, updateAgent, selectedEq, fresh] using oldFirmNext
      · simpa [updateSelected, updateAgent, selectedEq, fresh] using oldFirmBound
  · simpa [mappedIds] using ids
  · intro agent agentMem
    rcases List.mem_map.mp agentMem with ⟨oldAgent, oldMem, rfl⟩
    simpa using idPositive oldAgent oldMem
  · intro agent agentMem
    rcases List.mem_map.mp agentMem with ⟨oldAgent, oldMem, rfl⟩
    simpa using thetaBound oldAgent oldMem
  · intro agent agentMem
    rcases List.mem_map.mp agentMem with ⟨oldAgent, oldMem, rfl⟩
    by_cases selectedEq : oldAgent.id = selected
    · simpa [updateAgent, selectedEq, FeasibleEffort] using effortFeasible
    · simpa [updateAgent, selectedEq] using effortBound oldAgent oldMem
  · intro agent agentMem
    rcases List.mem_map.mp agentMem with ⟨oldAgent, oldMem, rfl⟩
    simpa using neighborCount oldAgent oldMem
  · intro agent agentMem
    rcases List.mem_map.mp agentMem with ⟨oldAgent, oldMem, rfl⟩
    simpa using neighborUnique oldAgent oldMem
  · intro agent agentMem neighbor neighborMem
    rcases List.mem_map.mp agentMem with ⟨oldAgent, oldMem, rfl⟩
    have original := neighborsExist oldAgent oldMem neighbor (by simpa using neighborMem)
    simpa [mappedIds] using original

theorem transition_preserves_validity (rule : ChoiceRule) (params : Params)
    (state : State) (draw : Draw) (valid : Valid params state) :
    Valid params (transition rule params state draw) := by
  cases found : findAgent? state draw.selectedAgent with
  | none => simpa [transition, found] using valid
  | some agent =>
    have agentMem : agent ∈ state.agents := by
      apply List.mem_of_find?_eq_some
      exact found
    simp only [transition, found]
    apply updateSelected_preserves_validity params state
    · exact valid
    · exact rule.effortFeasible params state agent draw valid agentMem
    · exact rule.firmBound params state agent draw valid agentMem

end AgenticAxtell.Baseline
