import AgenticAxtell.Approximation.FiniteDynamics

namespace AgenticAxtell.Approximation

/-- Number of occupied agent slots assigned to a particular bounded firm. -/
def finiteFirmSize {grid : EffortGrid} {bounds : StateBounds}
    (state : FiniteModelState grid bounds) (firm : FiniteFirmId bounds) : Nat :=
  (Finset.univ.filter fun id => ∃ agent, state.agents id = some agent ∧ agent.firm = firm).card

theorem finiteFirmSize_le_agentSlots {grid : EffortGrid} {bounds : StateBounds}
    (state : FiniteModelState grid bounds) (firm : FiniteFirmId bounds) :
    finiteFirmSize state firm ≤ bounds.agentSlots := by
  unfold finiteFirmSize
  calc
    _ ≤ Finset.univ.card := Finset.card_le_card (Finset.filter_subset _ _)
    _ = bounds.agentSlots := Fintype.card_fin bounds.agentSlots

/-- The bounded analogue of a firm-size upper-tail event. It is suitable for
finite-horizon and stationary PMF evaluation, but makes no asymptotic power-law
claim because all sizes are bounded by `agentSlots`. -/
def finiteFirmTailEvent {grid : EffortGrid} {bounds : StateBounds}
    (threshold : Nat) (state : FiniteModelState grid bounds) : Prop :=
  ∃ firm ∈ state.activeFirms, threshold ≤ finiteFirmSize state firm

theorem finiteFirmTailEvent_impossible_above_bound {grid : EffortGrid}
    {bounds : StateBounds} (state : FiniteModelState grid bounds)
    {threshold : Nat} (above : bounds.agentSlots < threshold) :
    ¬ finiteFirmTailEvent threshold state := by
  rintro ⟨firm, _, large⟩
  exact (Nat.not_le_of_gt above) (large.trans (finiteFirmSize_le_agentSlots state firm))

end AgenticAxtell.Approximation
