import Mathlib

namespace AgenticAxtell.Baseline

abbrev AgentId := Nat
abbrev FirmId := Nat

structure Params where
  population : Nat
  a : ℝ
  b : ℝ
  beta : ℝ
  neighborsPerAgent : Nat
  activationsPerPeriod : Nat

def ValidParams (params : Params) : Prop :=
  0 < params.population ∧ 0 ≤ params.a ∧ 0 ≤ params.b ∧ 1 ≤ params.beta ∧
  params.neighborsPerAgent < params.population ∧ 0 < params.activationsPerPeriod

structure Agent where
  id : AgentId
  theta : ℝ
  effort : ℝ
  firm : FirmId
  neighbors : List AgentId

structure State where
  agents : List Agent
  nextFirmId : FirmId

def activeFirms (state : State) : List FirmId :=
  (state.agents.map (·.firm)).eraseDups

def Valid (params : Params) (state : State) : Prop :=
  ValidParams params ∧
  state.agents.length = params.population ∧
  (∀ agent ∈ state.agents, agent.firm < state.nextFirmId) ∧
  (state.agents.map (·.id)).Nodup ∧
  (∀ agent ∈ state.agents, agent.id ≠ 0) ∧
  (∀ agent ∈ state.agents, 0 ≤ agent.theta ∧ agent.theta ≤ 1) ∧
  (∀ agent ∈ state.agents, 0 ≤ agent.effort ∧ agent.effort ≤ 1) ∧
  (∀ agent ∈ state.agents, agent.neighbors.length = params.neighborsPerAgent) ∧
  (∀ agent ∈ state.agents, agent.neighbors.Nodup) ∧
  (∀ agent ∈ state.agents, ∀ neighbor ∈ agent.neighbors,
    neighbor ≠ agent.id ∧ neighbor ∈ state.agents.map (·.id))

structure Draw where
  selectedAgent : AgentId
  tieBreak : UInt64
  deriving DecidableEq, Repr

end AgenticAxtell.Baseline
