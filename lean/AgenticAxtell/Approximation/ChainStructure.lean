import AgenticAxtell.Approximation.Stationary

namespace AgenticAxtell.Approximation

variable {grid : EffortGrid} {bounds : StateBounds} {tieSlots : Nat}
  [Nonempty (FiniteDraw bounds tieSlots)]

/-- A directed edge of the finite Markov chain: the successor has positive
one-step probability, expressed through PMF support. -/
def FinitePositiveStep (choose : FiniteChoiceRule grid bounds tieSlots)
    (state next : FiniteModelState grid bounds) : Prop :=
  next ∈ (finiteKernel choose state).support

/-- Reachability by zero or more positive-probability transitions. -/
def FiniteReachable (choose : FiniteChoiceRule grid bounds tieSlots)
    (state target : FiniteModelState grid bounds) : Prop :=
  Relation.ReflTransGen (FinitePositiveStep choose) state target

def FiniteCommunicate (choose : FiniteChoiceRule grid bounds tieSlots)
    (first second : FiniteModelState grid bounds) : Prop :=
  FiniteReachable choose first second ∧ FiniteReachable choose second first

/-- A set is closed when no positive-probability transition leaves it. -/
def IsClosedFiniteClass (choose : FiniteChoiceRule grid bounds tieSlots)
    (states : Set (FiniteModelState grid bounds)) : Prop :=
  ∀ ⦃state next⦄, state ∈ states → FinitePositiveStep choose state next → next ∈ states

/-- A closed communicating class is nonempty, internally communicating, and
closed under every positive-probability transition. -/
def IsClosedFiniteCommunicatingClass
    (choose : FiniteChoiceRule grid bounds tieSlots)
    (states : Set (FiniteModelState grid bounds)) : Prop :=
  states.Nonempty ∧
    (∀ ⦃first second⦄, first ∈ states → second ∈ states →
      FiniteCommunicate choose first second) ∧
    IsClosedFiniteClass choose states

/-- An absorbing state has a point-mass successor distribution. -/
def IsFiniteAbsorbing (choose : FiniteChoiceRule grid bounds tieSlots)
    (state : FiniteModelState grid bounds) : Prop :=
  finiteKernel choose state = PMF.pure state

def IsFiniteIrreducible (choose : FiniteChoiceRule grid bounds tieSlots) : Prop :=
  ∀ state target, FiniteReachable choose state target

/-- Eventual-return characterization of aperiodicity: after some cutoff every
larger time is a possible return time. For a finite irreducible chain this is
equivalent to the usual gcd-of-return-times definition. -/
def IsFiniteAperiodic (choose : FiniteChoiceRule grid bounds tieSlots) : Prop :=
  ∀ state, ∃ cutoff, ∀ steps, cutoff ≤ steps →
    state ∈ (finiteKernelIterate choose steps state).support

theorem finiteReachable_refl (choose : FiniteChoiceRule grid bounds tieSlots)
    (state : FiniteModelState grid bounds) :
    FiniteReachable choose state state :=
  Relation.ReflTransGen.refl

theorem finitePositiveStep_reachable (choose : FiniteChoiceRule grid bounds tieSlots)
    {state next : FiniteModelState grid bounds}
    (step : FinitePositiveStep choose state next) :
    FiniteReachable choose state next :=
  Relation.ReflTransGen.single step

theorem finiteReachable_trans (choose : FiniteChoiceRule grid bounds tieSlots)
    {first second third : FiniteModelState grid bounds}
    (firstSecond : FiniteReachable choose first second)
    (secondThird : FiniteReachable choose second third) :
    FiniteReachable choose first third :=
  firstSecond.trans secondThird

theorem finiteCommunicate_refl (choose : FiniteChoiceRule grid bounds tieSlots)
    (state : FiniteModelState grid bounds) :
    FiniteCommunicate choose state state :=
  ⟨finiteReachable_refl choose state, finiteReachable_refl choose state⟩

theorem finiteCommunicate_symm (choose : FiniteChoiceRule grid bounds tieSlots)
    {first second : FiniteModelState grid bounds}
    (communicate : FiniteCommunicate choose first second) :
    FiniteCommunicate choose second first :=
  communicate.symm

theorem finiteCommunicate_trans (choose : FiniteChoiceRule grid bounds tieSlots)
    {first second third : FiniteModelState grid bounds}
    (firstSecond : FiniteCommunicate choose first second)
    (secondThird : FiniteCommunicate choose second third) :
    FiniteCommunicate choose first third :=
  ⟨finiteReachable_trans choose firstSecond.1 secondThird.1,
   finiteReachable_trans choose secondThird.2 firstSecond.2⟩

theorem absorbing_positiveStep_iff (choose : FiniteChoiceRule grid bounds tieSlots)
    {state next : FiniteModelState grid bounds}
    (absorbing : IsFiniteAbsorbing choose state) :
    FinitePositiveStep choose state next ↔ next = state := by
  rw [FinitePositiveStep, absorbing, PMF.mem_support_pure_iff]

theorem absorbing_singleton_closed (choose : FiniteChoiceRule grid bounds tieSlots)
    {state : FiniteModelState grid bounds}
    (absorbing : IsFiniteAbsorbing choose state) :
    IsClosedFiniteClass choose ({state} : Set (FiniteModelState grid bounds)) := by
  intro current next currentMem step
  have currentEq : current = state := Set.mem_singleton_iff.mp currentMem
  subst current
  exact Set.mem_singleton_iff.mpr ((absorbing_positiveStep_iff choose absorbing).mp step)

theorem absorbing_singleton_communicatingClass
    (choose : FiniteChoiceRule grid bounds tieSlots)
    {state : FiniteModelState grid bounds}
    (absorbing : IsFiniteAbsorbing choose state) :
    IsClosedFiniteCommunicatingClass choose
      ({state} : Set (FiniteModelState grid bounds)) := by
  refine ⟨Set.singleton_nonempty state, ?_, absorbing_singleton_closed choose absorbing⟩
  intro first second firstMem secondMem
  rw [Set.mem_singleton_iff] at firstMem secondMem
  subst first
  subst second
  exact finiteCommunicate_refl choose state

end AgenticAxtell.Approximation
