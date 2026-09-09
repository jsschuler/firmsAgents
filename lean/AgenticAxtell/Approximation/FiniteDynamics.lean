import AgenticAxtell.Approximation.FiniteKernel

namespace AgenticAxtell.Approximation

/-- The distribution after `steps` independent finite draws, starting from a
point mass at `state`. -/
noncomputable def finiteKernelIterate {grid : EffortGrid} {bounds : StateBounds}
    {tieSlots : Nat} [Nonempty (FiniteDraw bounds tieSlots)]
    (choose : FiniteChoiceRule grid bounds tieSlots) :
    Nat → FiniteModelState grid bounds → PMF (FiniteModelState grid bounds)
  | 0, state => PMF.pure state
  | steps + 1, state =>
      (finiteKernelIterate choose steps state).bind (finiteKernel choose)

theorem finiteKernelIterate_preserves_valid {grid : EffortGrid}
    {bounds : StateBounds} {tieSlots : Nat}
    [Nonempty (FiniteDraw bounds tieSlots)]
    (choose : FiniteChoiceRule grid bounds tieSlots)
    (chooseSound : IsSoundFiniteChoiceRule choose)
    (state : FiniteModelState grid bounds) (stateValid : FiniteValid state)
    (steps : Nat) {next : FiniteModelState grid bounds}
    (nextSupport : next ∈ (finiteKernelIterate choose steps state).support) :
    FiniteValid next := by
  induction steps generalizing next with
  | zero =>
      have nextEq : next = state := (PMF.mem_support_pure_iff state next).mp
        (by simpa [finiteKernelIterate] using nextSupport)
      simpa [nextEq] using stateValid
  | succ steps ih =>
      have supportBind : next ∈
          ((finiteKernelIterate choose steps state).bind (finiteKernel choose)).support := by
        simpa [finiteKernelIterate] using nextSupport
      rcases (PMF.mem_support_bind_iff (finiteKernelIterate choose steps state)
        (finiteKernel choose) next).mp supportBind with
        ⟨middle, middleSupport, nextFromMiddle⟩
      exact finiteKernel_preserves_valid choose chooseSound middle
        (ih middleSupport) nextFromMiddle

theorem finiteKernelIterate_preserves_graphValid {grid : EffortGrid}
    {bounds : StateBounds} {tieSlots : Nat}
    [Nonempty (FiniteDraw bounds tieSlots)]
    (choose : FiniteChoiceRule grid bounds tieSlots)
    (state : FiniteModelState grid bounds)
    (stateGraphValid : FiniteGraphValid state)
    (steps : Nat) {next : FiniteModelState grid bounds}
    (nextSupport : next ∈ (finiteKernelIterate choose steps state).support) :
    FiniteGraphValid next := by
  induction steps generalizing next with
  | zero =>
      have nextEq : next = state := (PMF.mem_support_pure_iff state next).mp
        (by simpa [finiteKernelIterate] using nextSupport)
      simpa [nextEq] using stateGraphValid
  | succ steps ih =>
      have supportBind : next ∈
          ((finiteKernelIterate choose steps state).bind (finiteKernel choose)).support := by
        simpa [finiteKernelIterate] using nextSupport
      rcases (PMF.mem_support_bind_iff (finiteKernelIterate choose steps state)
        (finiteKernel choose) next).mp supportBind with
        ⟨middle, middleSupport, nextFromMiddle⟩
      exact finiteKernel_preserves_graphValid choose middle
        (ih middleSupport) nextFromMiddle

end AgenticAxtell.Approximation
