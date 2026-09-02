import AgenticAxtell.Baseline.BestResponse
import Mathlib.Topology.MetricSpace.Contracting

namespace AgenticAxtell.Baseline

/-- An effort profile for a fixed group of `groupSize` agents. -/
abbrev FixedGroupProfile (groupSize : Nat) := Fin groupSize → ℝ

/-- Effort supplied by every member other than `agent`. -/
def fixedGroupOtherEffort {groupSize : Nat} (profile : FixedGroupProfile groupSize)
    (agent : Fin groupSize) : ℝ :=
  ∑ other ∈ Finset.univ.filter (· ≠ agent), profile other

/-- A fixed-membership Nash equilibrium in effort. This says nothing about
firm switching or stationarity of the full formation process. -/
def IsFixedGroupNash (params : Params) {groupSize : Nat}
    (theta : Fin groupSize → ℝ) (profile : FixedGroupProfile groupSize) : Prop :=
  ∀ agent, IsBestResponse params (theta agent)
    (fixedGroupOtherEffort profile agent) groupSize (profile agent)

/-- A simultaneous best-response update for fixed membership. -/
def IsFixedGroupBestResponseMap (params : Params) {groupSize : Nat}
    (theta : Fin groupSize → ℝ)
    (response : FixedGroupProfile groupSize → FixedGroupProfile groupSize) : Prop :=
  ∀ profile agent, IsBestResponse params (theta agent)
    (fixedGroupOtherEffort profile agent) groupSize (response profile agent)

/-- The selected response is the unique best response in every environment. -/
def HasUniqueFixedGroupBestResponses (params : Params) {groupSize : Nat}
    (theta : Fin groupSize → ℝ)
    (response : FixedGroupProfile groupSize → FixedGroupProfile groupSize) : Prop :=
  ∀ profile agent effort,
    IsBestResponse params (theta agent) (fixedGroupOtherEffort profile agent)
      groupSize effort →
    effort = response profile agent

theorem isFixedGroupNash_iff (params : Params) {groupSize : Nat}
    (theta : Fin groupSize → ℝ) (profile : FixedGroupProfile groupSize) :
    IsFixedGroupNash params theta profile ↔
      ∀ agent, profile agent ∈ FeasibleEffort ∧
        ∀ alternative ∈ FeasibleEffort,
          utility params (theta agent) alternative
              (fixedGroupOtherEffort profile agent) groupSize ≤
            utility params (theta agent) (profile agent)
              (fixedGroupOtherEffort profile agent) groupSize := by
  rfl

theorem fixedGroupNash_effort_feasible (params : Params) {groupSize : Nat}
    (theta : Fin groupSize → ℝ) (profile : FixedGroupProfile groupSize)
    (equilibrium : IsFixedGroupNash params theta profile) (agent : Fin groupSize) :
    profile agent ∈ FeasibleEffort :=
  (equilibrium agent).1

theorem fixedPoint_of_bestResponseMap_is_nash (params : Params) {groupSize : Nat}
    (theta : Fin groupSize → ℝ)
    (response : FixedGroupProfile groupSize → FixedGroupProfile groupSize)
    (responseIsBest : IsFixedGroupBestResponseMap params theta response)
    (profile : FixedGroupProfile groupSize) (fixedPoint : response profile = profile) :
    IsFixedGroupNash params theta profile := by
  intro agent
  have best := responseIsBest profile agent
  rw [fixedPoint] at best
  exact best

theorem exists_fixedGroupNash_of_bestResponseMap_fixedPoint (params : Params)
    {groupSize : Nat} (theta : Fin groupSize → ℝ)
    (response : FixedGroupProfile groupSize → FixedGroupProfile groupSize)
    (responseIsBest : IsFixedGroupBestResponseMap params theta response)
    (hasFixedPoint : ∃ profile, response profile = profile) :
    ∃ profile, IsFixedGroupNash params theta profile := by
  obtain ⟨profile, fixedPoint⟩ := hasFixedPoint
  exact ⟨profile, fixedPoint_of_bestResponseMap_is_nash params theta response
    responseIsBest profile fixedPoint⟩

/-- Banach's theorem supplies an equilibrium for any contracting simultaneous
best-response map, for an arbitrary finite fixed group. -/
theorem exists_fixedGroupNash_of_contracting_bestResponseMap (params : Params)
    {groupSize : Nat} (theta : Fin groupSize → ℝ)
    (response : FixedGroupProfile groupSize → FixedGroupProfile groupSize)
    (responseIsBest : IsFixedGroupBestResponseMap params theta response)
    {K : NNReal} (contracting : ContractingWith K response) :
    ∃ profile, IsFixedGroupNash params theta profile := by
  let profile := ContractingWith.fixedPoint response contracting
  have fixedPoint : response profile = profile := contracting.fixedPoint_isFixedPt
  exact ⟨profile, fixedPoint_of_bestResponseMap_is_nash params theta response
    responseIsBest profile fixedPoint⟩

/-- Under the same contraction condition, synchronous best-response iteration
converges to a fixed-group Nash equilibrium from every initial effort profile. -/
theorem tendsto_fixedGroupNash_of_contracting_bestResponseMap (params : Params)
    {groupSize : Nat} (theta : Fin groupSize → ℝ)
    (response : FixedGroupProfile groupSize → FixedGroupProfile groupSize)
    (responseIsBest : IsFixedGroupBestResponseMap params theta response)
    {K : NNReal} (contracting : ContractingWith K response)
    (initial : FixedGroupProfile groupSize) :
    ∃ equilibrium, IsFixedGroupNash params theta equilibrium ∧
      Filter.Tendsto (fun iteration => response^[iteration] initial) Filter.atTop
        (nhds equilibrium) := by
  let equilibrium := ContractingWith.fixedPoint response contracting
  have fixedPoint : response equilibrium = equilibrium := contracting.fixedPoint_isFixedPt
  refine ⟨equilibrium,
    fixedPoint_of_bestResponseMap_is_nash params theta response responseIsBest
      equilibrium fixedPoint, ?_⟩
  exact contracting.tendsto_iterate_fixedPoint initial

theorem nash_is_fixedPoint_of_unique_bestResponses (params : Params)
    {groupSize : Nat} (theta : Fin groupSize → ℝ)
    (response : FixedGroupProfile groupSize → FixedGroupProfile groupSize)
    (responsesUnique : HasUniqueFixedGroupBestResponses params theta response)
    (profile : FixedGroupProfile groupSize)
    (equilibrium : IsFixedGroupNash params theta profile) :
    response profile = profile := by
  funext agent
  exact (responsesUnique profile agent (profile agent) (equilibrium agent)).symm

/-- A contracting map of unique best responses has exactly one fixed-group Nash
equilibrium. -/
theorem existsUnique_fixedGroupNash_of_contracting_uniqueBestResponseMap
    (params : Params) {groupSize : Nat} (theta : Fin groupSize → ℝ)
    (response : FixedGroupProfile groupSize → FixedGroupProfile groupSize)
    (responseIsBest : IsFixedGroupBestResponseMap params theta response)
    (responsesUnique : HasUniqueFixedGroupBestResponses params theta response)
    {K : NNReal} (contracting : ContractingWith K response) :
    ∃! profile, IsFixedGroupNash params theta profile := by
  let profile := ContractingWith.fixedPoint response contracting
  have profileFixed : response profile = profile := contracting.fixedPoint_isFixedPt
  refine ⟨profile,
    fixedPoint_of_bestResponseMap_is_nash params theta response responseIsBest
      profile profileFixed, ?_⟩
  intro other otherNash
  have otherFixed := nash_is_fixedPoint_of_unique_bestResponses params theta response
    responsesUnique other otherNash
  exact contracting.fixedPoint_unique' otherFixed profileFixed

/-- The first unconditional fixed-group existence result: a singleton firm has
a Nash effort equilibrium by compactness and continuity of its utility. -/
theorem exists_singleton_fixedGroupNash (params : Params) (theta : Fin 1 → ℝ)
    (paramsValid : ValidParams params) (thetaNonnegative : ∀ agent, 0 ≤ theta agent)
    (thetaAtMostOne : ∀ agent, theta agent ≤ 1) :
    ∃ profile : FixedGroupProfile 1, IsFixedGroupNash params theta profile := by
  obtain ⟨effort, best⟩ := exists_best_response params (theta 0) 0 1 paramsValid
    (thetaNonnegative 0) (thetaAtMostOne 0)
  let profile : FixedGroupProfile 1 := fun _ => effort
  refine ⟨profile, ?_⟩
  intro agent
  have agentEq : agent = 0 := Fin.eq_zero agent
  subst agent
  have othersZero : fixedGroupOtherEffort profile 0 = 0 := by
    unfold fixedGroupOtherEffort
    apply Finset.sum_eq_zero
    intro other otherMem
    simp only [Finset.mem_filter, Finset.mem_univ, true_and] at otherMem
    exact (otherMem (Fin.eq_zero other)).elim
  change IsBestResponse params (theta 0) (fixedGroupOtherEffort profile 0) 1 effort
  rw [othersZero]
  exact best

theorem utility_theta_zero (params : Params) (effort othersEffort : ℝ)
    (groupSize : Nat) :
    utility params 0 effort othersEffort groupSize = 1 - effort := by
  simp [utility]

theorem theta_zero_bestResponse_zero (params : Params) (othersEffort : ℝ)
    (groupSize : Nat) : IsBestResponse params 0 othersEffort groupSize 0 := by
  refine ⟨by simp [FeasibleEffort], ?_⟩
  intro alternative alternativeFeasible
  have alternativeNonnegative : 0 ≤ alternative := alternativeFeasible.1
  rw [utility_theta_zero, utility_theta_zero]
  linarith

theorem theta_zero_bestResponse_unique (params : Params) (othersEffort : ℝ)
    (groupSize : Nat) (effort : ℝ)
    (best : IsBestResponse params 0 othersEffort groupSize effort) : effort = 0 := by
  have effortNonnegative : 0 ≤ effort := best.1.1
  have zeroFeasible : (0 : ℝ) ∈ FeasibleEffort := by simp [FeasibleEffort]
  have dominatesZero := best.2 0 zeroFeasible
  rw [utility_theta_zero, utility_theta_zero] at dominatesZero
  linarith

def zeroEffortResponse {groupSize : Nat} :
    FixedGroupProfile groupSize → FixedGroupProfile groupSize :=
  fun _ _ => 0

theorem zeroEffortResponse_isBest (params : Params) {groupSize : Nat}
    (theta : Fin groupSize → ℝ) (thetaZero : ∀ agent, theta agent = 0) :
    IsFixedGroupBestResponseMap params theta zeroEffortResponse := by
  intro profile agent
  rw [thetaZero agent]
  exact theta_zero_bestResponse_zero params (fixedGroupOtherEffort profile agent) groupSize

theorem zeroEffortResponse_unique (params : Params) {groupSize : Nat}
    (theta : Fin groupSize → ℝ) (thetaZero : ∀ agent, theta agent = 0) :
    HasUniqueFixedGroupBestResponses params theta zeroEffortResponse := by
  intro profile agent effort best
  rw [thetaZero agent] at best
  exact theta_zero_bestResponse_unique params (fixedGroupOtherEffort profile agent)
    groupSize effort best

theorem zeroEffortResponse_contracting {groupSize : Nat} :
    ContractingWith (0 : NNReal) (zeroEffortResponse (groupSize := groupSize)) := by
  exact ⟨by norm_num, LipschitzWith.const _⟩

theorem fixedGroupNash_theta_zero_iff (params : Params) {groupSize : Nat}
    (theta : Fin groupSize → ℝ) (thetaZero : ∀ agent, theta agent = 0)
    (profile : FixedGroupProfile groupSize) :
    IsFixedGroupNash params theta profile ↔ profile = fun _ => 0 := by
  constructor
  · intro equilibrium
    funext agent
    have best := equilibrium agent
    rw [thetaZero agent] at best
    exact theta_zero_bestResponse_unique params (fixedGroupOtherEffort profile agent)
      groupSize (profile agent) best
  · intro profileZero agent
    subst profile
    rw [thetaZero agent]
    exact theta_zero_bestResponse_zero params
      (fixedGroupOtherEffort (fun _ => 0) agent) groupSize

/-- For any finite fixed group whose members have `theta = 0`, the all-zero
effort profile is the unique Nash equilibrium. -/
theorem existsUnique_fixedGroupNash_theta_zero (params : Params) {groupSize : Nat}
    (theta : Fin groupSize → ℝ) (thetaZero : ∀ agent, theta agent = 0) :
    ∃! profile, IsFixedGroupNash params theta profile := by
  exact existsUnique_fixedGroupNash_of_contracting_uniqueBestResponseMap params theta
    zeroEffortResponse (zeroEffortResponse_isBest params theta thetaZero)
    (zeroEffortResponse_unique params theta thetaZero) zeroEffortResponse_contracting

end AgenticAxtell.Baseline
