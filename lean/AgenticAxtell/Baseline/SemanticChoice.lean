import AgenticAxtell.Baseline.Transition

namespace AgenticAxtell.Baseline

noncomputable def bestEffortForFirm (params : Params) (state : State) (agent : Agent)
    (firm : FirmId) (paramsValid : ValidParams params)
    (thetaNonnegative : 0 ≤ agent.theta) (thetaAtMostOne : agent.theta ≤ 1) : ℝ :=
  Classical.choose <| exists_best_response params agent.theta
    (otherEffort state agent firm) (candidateSize state agent firm)
    paramsValid thetaNonnegative thetaAtMostOne

theorem bestEffortForFirm_spec (params : Params) (state : State) (agent : Agent)
    (firm : FirmId) (paramsValid : ValidParams params)
    (thetaNonnegative : 0 ≤ agent.theta) (thetaAtMostOne : agent.theta ≤ 1) :
    IsBestResponse params agent.theta (otherEffort state agent firm)
      (candidateSize state agent firm)
      (bestEffortForFirm params state agent firm paramsValid
        thetaNonnegative thetaAtMostOne) :=
  Classical.choose_spec <| exists_best_response params agent.theta
    (otherEffort state agent firm) (candidateSize state agent firm)
    paramsValid thetaNonnegative thetaAtMostOne

theorem exists_optimal_local_choice (params : Params) (state : State) (agent : Agent)
    (valid : Valid params state) (agentMem : agent ∈ state.agents) :
    ∃ choice : Choice,
      choice.effort ∈ FeasibleEffort ∧
      choice.firm ∈ candidateFirms state agent ∧
      choice.firm ≤ state.nextFirmId ∧
      ∀ firm ∈ candidateFirms state agent, ∀ effort ∈ FeasibleEffort,
        candidateUtility params state agent firm effort ≤
          candidateUtility params state agent choice.firm choice.effort := by
  have paramsValid := valid.1
  have thetaBounds := valid.2.2.2.2.2.1 agent agentMem
  let effortFor : FirmId → ℝ := fun firm =>
    bestEffortForFirm params state agent firm paramsValid thetaBounds.1 thetaBounds.2
  have candidatesNonempty : (candidateFirms state agent).Nonempty :=
    ⟨state.nextFirmId, startup_mem_candidateFirms state agent⟩
  obtain ⟨bestFirm, bestFirmMem, bestFirmMaximal⟩ :=
    Finset.exists_max_image (candidateFirms state agent)
      (fun firm => candidateUtility params state agent firm (effortFor firm))
      candidatesNonempty
  refine ⟨⟨bestFirm, effortFor bestFirm⟩, ?_, bestFirmMem, ?_, ?_⟩
  · exact (bestEffortForFirm_spec params state agent bestFirm paramsValid
      thetaBounds.1 thetaBounds.2).1
  · exact candidateFirm_le_nextFirmId params state agent valid agentMem bestFirmMem
  · intro firm firmMem effort effortMem
    have withinFirm := (bestEffortForFirm_spec params state agent firm paramsValid
      thetaBounds.1 thetaBounds.2).2 effort effortMem
    have acrossFirms := bestFirmMaximal firm firmMem
    exact le_trans withinFirm acrossFirms

noncomputable def maximizingFirms (params : Params) (state : State) (agent : Agent)
    (paramsValid : ValidParams params) (thetaNonnegative : 0 ≤ agent.theta)
    (thetaAtMostOne : agent.theta ≤ 1) : Finset FirmId := by
  classical
  let effortFor : FirmId → ℝ := fun firm =>
    bestEffortForFirm params state agent firm paramsValid thetaNonnegative thetaAtMostOne
  exact (candidateFirms state agent).filter fun firm =>
    ∀ other ∈ candidateFirms state agent,
      candidateUtility params state agent other (effortFor other) ≤
        candidateUtility params state agent firm (effortFor firm)

theorem maximizingFirms_nonempty (params : Params) (state : State) (agent : Agent)
    (paramsValid : ValidParams params) (thetaNonnegative : 0 ≤ agent.theta)
    (thetaAtMostOne : agent.theta ≤ 1) :
    (maximizingFirms params state agent paramsValid thetaNonnegative
      thetaAtMostOne).Nonempty := by
  let effortFor : FirmId → ℝ := fun firm =>
    bestEffortForFirm params state agent firm paramsValid thetaNonnegative thetaAtMostOne
  have candidatesNonempty : (candidateFirms state agent).Nonempty :=
    ⟨state.nextFirmId, startup_mem_candidateFirms state agent⟩
  obtain ⟨bestFirm, bestFirmMem, bestFirmMaximal⟩ :=
    Finset.exists_max_image (candidateFirms state agent)
      (fun firm => candidateUtility params state agent firm (effortFor firm))
      candidatesNonempty
  refine ⟨bestFirm, ?_⟩
  simp only [maximizingFirms, Finset.mem_filter]
  exact ⟨bestFirmMem, bestFirmMaximal⟩

def selectByDraw {α : Type} (options : List α) (nonempty : options ≠ [])
    (tieBreak : UInt64) : α :=
  options.get ⟨tieBreak.toNat % options.length,
    Nat.mod_lt _ (List.length_pos_iff.mpr nonempty)⟩

theorem selectByDraw_mem {α : Type} (options : List α) (nonempty : options ≠ [])
    (tieBreak : UInt64) : selectByDraw options nonempty tieBreak ∈ options := by
  exact List.get_mem options _

noncomputable def drawSelectedFirm (params : Params) (state : State) (agent : Agent)
    (draw : Draw) (paramsValid : ValidParams params)
    (thetaNonnegative : 0 ≤ agent.theta) (thetaAtMostOne : agent.theta ≤ 1) : FirmId :=
  let maximizers := maximizingFirms params state agent paramsValid
    thetaNonnegative thetaAtMostOne
  selectByDraw maximizers.toList
    ((maximizingFirms_nonempty params state agent paramsValid
      thetaNonnegative thetaAtMostOne).toList_ne_nil)
    draw.tieBreak

theorem drawSelectedFirm_mem_maximizingFirms (params : Params) (state : State)
    (agent : Agent) (draw : Draw) (paramsValid : ValidParams params)
    (thetaNonnegative : 0 ≤ agent.theta) (thetaAtMostOne : agent.theta ≤ 1) :
    drawSelectedFirm params state agent draw paramsValid thetaNonnegative thetaAtMostOne ∈
      maximizingFirms params state agent paramsValid thetaNonnegative thetaAtMostOne := by
  let maximizers := maximizingFirms params state agent paramsValid
    thetaNonnegative thetaAtMostOne
  have nonempty : maximizers.toList ≠ [] := by
    exact (maximizingFirms_nonempty params state agent paramsValid
      thetaNonnegative thetaAtMostOne).toList_ne_nil
  have selectedMem := selectByDraw_mem maximizers.toList nonempty draw.tieBreak
  simpa [drawSelectedFirm, maximizers, nonempty] using selectedMem

noncomputable def drawIndexedOptimalChoice (params : Params) (state : State)
    (agent : Agent) (draw : Draw) (paramsValid : ValidParams params)
    (thetaNonnegative : 0 ≤ agent.theta) (thetaAtMostOne : agent.theta ≤ 1) : Choice :=
  let firm := drawSelectedFirm params state agent draw paramsValid
    thetaNonnegative thetaAtMostOne
  ⟨firm, bestEffortForFirm params state agent firm paramsValid
    thetaNonnegative thetaAtMostOne⟩

theorem drawIndexedOptimalChoice_spec (params : Params) (state : State) (agent : Agent)
    (draw : Draw) (valid : Valid params state) (agentMem : agent ∈ state.agents) :
    let choice := drawIndexedOptimalChoice params state agent draw valid.1
      (valid.2.2.2.2.2.1 agent agentMem).1
      (valid.2.2.2.2.2.1 agent agentMem).2
    choice.effort ∈ FeasibleEffort ∧
    choice.firm ∈ candidateFirms state agent ∧
    choice.firm ≤ state.nextFirmId ∧
    ∀ firm ∈ candidateFirms state agent, ∀ effort ∈ FeasibleEffort,
      candidateUtility params state agent firm effort ≤
        candidateUtility params state agent choice.firm choice.effort := by
  let thetaBounds := valid.2.2.2.2.2.1 agent agentMem
  let selected := drawSelectedFirm params state agent draw valid.1 thetaBounds.1 thetaBounds.2
  have selectedMaximizes := drawSelectedFirm_mem_maximizingFirms params state agent draw
    valid.1 thetaBounds.1 thetaBounds.2
  have selectedSpec := Finset.mem_filter.mp selectedMaximizes
  refine ⟨?_, selectedSpec.1, ?_, ?_⟩
  · exact (bestEffortForFirm_spec params state agent selected valid.1
      thetaBounds.1 thetaBounds.2).1
  · exact candidateFirm_le_nextFirmId params state agent valid agentMem selectedSpec.1
  · intro firm firmMem effort effortMem
    have withinFirm := (bestEffortForFirm_spec params state agent firm valid.1
      thetaBounds.1 thetaBounds.2).2 effort effortMem
    have acrossFirms := selectedSpec.2 firm firmMem
    exact le_trans withinFirm acrossFirms

noncomputable def drawIndexedSemanticChoice (params : Params) (state : State)
    (agent : Agent) (draw : Draw) : Choice := by
  classical
  exact if admissible : Valid params state ∧ agent ∈ state.agents then
      drawIndexedOptimalChoice params state agent draw admissible.1.1
        (admissible.1.2.2.2.2.2.1 agent admissible.2).1
        (admissible.1.2.2.2.2.2.1 agent admissible.2).2
    else ⟨agent.firm, 0⟩

theorem drawIndexedSemanticChoice_spec (params : Params) (state : State) (agent : Agent)
    (draw : Draw) (valid : Valid params state) (agentMem : agent ∈ state.agents) :
    let choice := drawIndexedSemanticChoice params state agent draw
    choice.effort ∈ FeasibleEffort ∧
    choice.firm ∈ candidateFirms state agent ∧
    choice.firm ≤ state.nextFirmId ∧
    ∀ firm ∈ candidateFirms state agent, ∀ effort ∈ FeasibleEffort,
      candidateUtility params state agent firm effort ≤
        candidateUtility params state agent choice.firm choice.effort := by
  classical
  have admissible : Valid params state ∧ agent ∈ state.agents := ⟨valid, agentMem⟩
  simp only [drawIndexedSemanticChoice, dif_pos admissible]
  exact drawIndexedOptimalChoice_spec params state agent draw valid agentMem

noncomputable def drawIndexedSemanticChoiceRule : ChoiceRule where
  choose := drawIndexedSemanticChoice
  effortFeasible := by
    intro params state agent draw valid agentMem
    exact (drawIndexedSemanticChoice_spec params state agent draw valid agentMem).1
  firmLocal := by
    intro params state agent draw valid agentMem
    exact (drawIndexedSemanticChoice_spec params state agent draw valid agentMem).2.1
  firmBound := by
    intro params state agent draw valid agentMem
    exact (drawIndexedSemanticChoice_spec params state agent draw valid agentMem).2.2.1
  optimal := by
    intro params state agent draw firm valid agentMem firmMem effort effortMem
    exact (drawIndexedSemanticChoice_spec params state agent draw valid agentMem).2.2.2
      firm firmMem effort effortMem

noncomputable def canonicalSemanticChoice (params : Params) (state : State)
    (agent : Agent) (_draw : Draw) : Choice := by
  classical
  exact if admissible : Valid params state ∧ agent ∈ state.agents then
      Classical.choose (exists_optimal_local_choice params state agent admissible.1 admissible.2)
    else ⟨agent.firm, 0⟩

theorem canonicalSemanticChoice_spec (params : Params) (state : State) (agent : Agent)
    (draw : Draw) (valid : Valid params state) (agentMem : agent ∈ state.agents) :
    let choice := canonicalSemanticChoice params state agent draw
    choice.effort ∈ FeasibleEffort ∧
    choice.firm ∈ candidateFirms state agent ∧
    choice.firm ≤ state.nextFirmId ∧
    ∀ firm ∈ candidateFirms state agent, ∀ effort ∈ FeasibleEffort,
      candidateUtility params state agent firm effort ≤
        candidateUtility params state agent choice.firm choice.effort := by
  classical
  have admissible : Valid params state ∧ agent ∈ state.agents :=
    And.intro valid agentMem
  simp only [canonicalSemanticChoice, dif_pos admissible]
  exact Classical.choose_spec (exists_optimal_local_choice params state agent valid agentMem)

noncomputable def canonicalSemanticChoiceRule : ChoiceRule where
  choose := canonicalSemanticChoice
  effortFeasible := by
    intro params state agent draw valid agentMem
    exact (canonicalSemanticChoice_spec params state agent draw valid agentMem).1
  firmLocal := by
    intro params state agent draw valid agentMem
    exact (canonicalSemanticChoice_spec params state agent draw valid agentMem).2.1
  firmBound := by
    intro params state agent draw valid agentMem
    exact (canonicalSemanticChoice_spec params state agent draw valid agentMem).2.2.1
  optimal := by
    intro params state agent draw firm valid agentMem firmMem effort effortMem
    exact (canonicalSemanticChoice_spec params state agent draw valid agentMem).2.2.2
      firm firmMem effort effortMem

end AgenticAxtell.Baseline
